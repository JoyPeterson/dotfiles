COMMON_REVIEWERS="'krichards, iellsworth'"

# Pull changes from upstream and send the current branch to arc for review
function arcr ()
{
	rebase_feature_branch && arc diff $@ --reviewers $COMMON_REVIEWERS
}


# Pull latest version of upstream branch and then rebase the current branch
# onto the upstream branch
function rebase_feature_branch()
{
	# get current branch name
	c_branch=$(git rev-parse --abbrev-ref HEAD)
	echo $c_branch

	# get upstream branch name
	us_branch=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
	echo $us_branch

	git checkout $us_branch
	git pull origin
	git checkout $c_branch
	git rebase $us_branch
}