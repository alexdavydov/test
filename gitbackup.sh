#!/bin/bash
set -o xtrace
message="New revision"
usage="Usage: $0 [-m message] [-r repository] file1 ..."
repo=~/test

while getopts ":m:r" opt; do #Start the options handling block. We accept -m for commit msg and repo name. Repo dir is assumed to be under ~
	case $opt in 
		m ) message="$OPTARG";  echo $OPTARG;;
		r ) ;; # repo=$OPTARTG; echo $repo ;;
		\? ) echo $usage 
		exit 1 ;;
	esac
done

shift $((OPTIND - 1))
echo "$*"
if [ -z "$*" ]; then	#Exit if no arguments
	echo $usage
	exit 1
fi
echo $repo
if !  [ -d "$repo/.git" ]; then
	echo "$repo is not a git repository"
	exit 1

else 
	for filename in "$@"; do 

	if [ -f $1 ] && [ -r $1 ]; then 
	
	if ! [ -f $repo/${filename#*/} ]; then  #Check if the file already exists in repository, if not, put it there
		cp $filename $repo
	fi
	
	cd "$repo"
	git add ${filename#*/}
	cd $OLDPWD
	fi
done
cd $repo
git commit -m "$message"
echo $repo
reponame=${repo%%/*}
git push ${repository#~/}
fi
