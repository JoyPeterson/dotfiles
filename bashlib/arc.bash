pathadd /c/bin/arcanist/bin

export COMPOSER_HOME=~/.composer
pathadd ~/.composer/vendor/bin

if [[ -f /c/bin/arcanist/resources/shell/bash-completion ]]; then
	source /c/bin/arcanist/resources/shell/bash-completion
fi


COMMON_REVIEWERS="krichards, iellsworth"

# display useful aliases and functions
function arc_h() {
	echo "arcr: Rebase the current branch from upstream and send the current branch to arc for review."
    echo "arcd: Diff the current branch against its upstream branch and send the result to arc for review."
    echo "arcl [source_branch]: Land source_branch or the current branch onto the upstream branch."
}

# Rebase the current branch from upstream and send the current branch to arc for review.
function arcr ()
{
	rebase_feature_branch && arcd
}

# Diff the current branch against its upstream branch and send the result to
# arc for review.
function arcd()
{
	arc diff $(us_branch) --reviewers "$COMMON_REVIEWERS"
}

# Land a branch onto its upstream branch
function arcl()
{
	git fetch origin

	if [[ "$1" == "" ]]; then
		src_branch=$(c_branch)
	else
		src_branch=$1
		git checkout $src_branch || fail "$src_branch does not exist.\n";
	fi

	trg_branch=$(us_branch)
	printf "Landing $src_branch onto $trg_branch.\n\n"
	arc land $src_branch --onto $trg_branch
}

# Pull latest version of upstream branch and then rebase the current branch
# onto the upstream branch
function rebase_feature_branch()
{
	git fetch origin
	# get current branch name
	trg_branch=$(c_branch)
	echo $trg_branch

	# get upstream branch name
	us_branch=$(us_branch)
	echo $us_branch

	# TODO - If upstream branch tracks a remote branch
	# This might be helpful: http://stackoverflow.com/questions/171550/find-out-which-remote-branch-a-local-branch-is-tracking
	# parse output of 'git status -sb $(us_branch)'
	git checkout $us_branch
	git pull origin
	git checkout $trg_branch
	# endif

	git rebase $us_branch
}

# Returns the name of the current branch
function c_branch()
{
	echo $(git rev-parse --abbrev-ref HEAD)
}

# Checks if $1 is a remote branch
function is_remote_branch()
{
	branch=$1
	if [ $(git branch -r | grep $branch) "==" $branch ]; then
		echo 1;
	else
		echo 0;
	fi
}

# Get the name of the upstream branch
function us_branch()
{
	if [[ "" == "$1" ]]; then
		echo $(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
	else
		echo $(git rev-parse --abbrev-ref --symbolic-full-name $1@\{upstream\})
	fi
}

# Find the remote branch that is an ancestor of the current branch.
function find_us_remote_branch()
{
	us_branch=$(us_branch)
	is_remote=$(is_remote_branch $us_branch)
	i="0"
	while [[ $i -lt 4 && $is_remote -eq 0 ]]; do
		us_branch=$(us_branch $us_branch)
		is_remote=$(is_remote_branch $us_branch)
		i=$[i+1]
	done

	if [ $is_remote ]; then
		echo $us_branch
	else
		echo ""
	fi
}

# Exit with a failure message.
function fail()
{
	printf "ERROR: $1"
	kill -INT $$
}

# Merge current branch into visionqa
function push_to_qa()
{
	target_branch=visionqa
	gitroot=$(git rev-parse --show-toplevel)
	src_branch=$(c_branch)


	printf "Updating $src_branch...\n" && \
	git pull origin && \
	printf "Checking out branch: $target_branch...\n" && \
	git checkout $target_branch && \
	printf "Updating $target_branch...\n" && \
	git pull origin && \
	printf "Checking out branch: $src_branch...\n" && \
	git checkout $src_branch && \
	printf "Merging from $target_branch...\n" && \
	git merge $target_branch --no-commit

	config_path=$(git status -s | grep .arcconfig | awk '{ print $2}')
	if [[ "$config_path" != "" ]]; then
		printf "Reverting $config_path...\n" && \
		git checkout $src_branch $config_path
	fi

	[[ $? == 0 ]] && \
	printf "Finishing merge from $target_branch...\n" && \
	git commit -F $gitroot/.git/MERGE_MSG && \
	printf "Pushing to origin\$src_branch...\n" && \
	git push origin && \
	printf "Checking out branch: $target_branch...\n" && \
	git checkout $target_branch && \
	printf "Merging from $src_branch...\n" && \
	git merge $src_branch --no-commit  --no-ff && \

	config_path=$(git status -s | grep .arcconfig | awk '{ print $2}')
	if [[ "$config_path" != "" ]]; then
		printf "Reverting $config_path...\n" && \
		git checkout $target_branch $config_path
	fi

	[[ $? == 0 ]] && \
	printf "Finishing merge from $src_branch...\n" && \
	git commit -F $gitroot/.git/MERGE_MSG && \
	printf "Pushing to origin/$target_branch...\n" && \
	git push origin && \
	printf "Switching back to $src_branch...\n"
	git checkout $src_branch
}


# Implement tab completion for arcl
function __arcl ()
{
  local cur opts
  COMP_WORDS=( arc land "${COMP_WORDS[@]:1}")
  COMP_CWORD=$((COMP_CWORD + 1))
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts=$(echo | arc shell-complete --current ${COMP_CWORD} -- ${COMP_WORDS[@]})
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
complete -F __arcl arcl