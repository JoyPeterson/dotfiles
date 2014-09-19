if [ -f /c/bin/arcanist/resources/shell/bash-completion ]; then
	source /c/bin/arcanist/resources/shell/bash-completion
fi


COMMON_REVIEWERS="krichards, iellsworth"

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