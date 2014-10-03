if [ -f /c/bin/arcanist/resources/shell/bash-completion ]; then
	source /c/bin/arcanist/resources/shell/bash-completion
fi


COMMON_REVIEWERS="krichards, iellsworth, ssandberg"

# Pull changes from upstream and send the current branch to arc for review
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


# Pull latest version of upstream branch and then rebase the current branch
# onto the upstream branch
function rebase_feature_branch()
{
	# get current branch name
	c_branch=$(git rev-parse --abbrev-ref HEAD)
	echo $c_branch

	# get upstream branch name
	us_branch=$(us_branch)
	echo $us_branch

	# TODO - If upstream branch tracks a remote branch
	# This might be helpful: http://stackoverflow.com/questions/171550/find-out-which-remote-branch-a-local-branch-is-tracking
	# parse output of 'git status -sb $(us_branch)'
	git checkout $us_branch
	git pull origin
	git checkout $c_branch
	# endif

	git rebase $us_branch
}

# Get the name of the upstream branch
function us_branch()
{
	echo $(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
}

# Merge current branch into visionqa
function push_to_qa()
{
	target_branch=visionqa
	gitroot=$(git rev-parse --show-toplevel)
	c_branch=$(git rev-parse --abbrev-ref HEAD)


	printf "Updating $c_branch...\n" && \
	git pull origin && \
	printf "Checking out branch: $target_branch...\n" && \
	git checkout $target_branch && \
	printf "Updating $target_branch...\n" && \
	git pull origin && \
	printf "Checking out branch: $c_branch...\n" && \
	git checkout $c_branch && \
	printf "Merging from $target_branch...\n" && \
	git merge $target_branch --no-commit

	config_path=$(git status -s | grep .arcconfig | awk '{ print $2}')
	if [ "$config_path" != "" ]; then
		printf "Reverting $config_path...\n" && \
		git checkout $c_branch $config_path
	fi

	[ $? == 0 ] && \
	printf "Finishing merge from $target_branch...\n" && \
	git commit -F $gitroot/.git/MERGE_MSG && \
	printf "Pushing to origin\$c_branch...\n" && \
	git push origin && \
	printf "Checking out branch: $target_branch...\n" && \
	git checkout $target_branch && \
	printf "Merging from $c_branch...\n" && \
	git merge $c_branch --no-commit  --no-ff && \

	config_path=$(git status -s | grep .arcconfig | awk '{ print $2}')
	if [ "$config_path" != "" ]; then
		printf "Reverting $config_path...\n" && \
		git checkout $target_branch $config_path
	fi

	[ $? == 0 ] && \
	printf "Finishing merge from $c_branch...\n" && \
	git commit -F $gitroot/.git/MERGE_MSG && \
	printf "Pushing to origin/$target_branch...\n" && \
	git push origin && \
	printf "Switching back to $c_branch...\n"
	git checkout $c_branch
}

# 10:54:18 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce ± git up
# 10:54:57 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce ± git co visionqa && git up
# 10:59:07 [jpeterson:/c/Projects/EmailTracker] visionqa ± git co feature/dreamforce
# 10:59:15 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce ± git merge visionqa --no-commit
# 10:59:25 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce(+0/-0) ± git st
# 10:59:28 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce(+0/-0) ± git reset HEAD .arcconfig
# 10:59:38 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce(+3/-3) ± git co -- .arcconfig
# 10:59:46 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce(+0/-0) ± git commit

# 10:59:50 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce(1) ± git push
# 10:59:58 [jpeterson:/c/Projects/EmailTracker] feature/dreamforce ± git co visionqa
# 11:00:05 [jpeterson:/c/Projects/EmailTracker] visionqa ± git merge feature/dreamforce --no-commit --no-ff
# 11:00:32 [jpeterson:/c/Projects/EmailTracker] visionqa(+0/-0) ± git st
# Unstaged changes after reset:
# 11:00:41 [jpeterson:/c/Projects/EmailTracker] visionqa(+3/-3) ± git co -- .arcconfig
# 11:00:46 [jpeterson:/c/Projects/EmailTracker] visionqa(+0/-0) ± git commit
# 11:00:54 [jpeterson:/c/Projects/EmailTracker] visionqa(2) ± git push