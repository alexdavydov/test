#!/bin/bash
#set -o xtrace
usage="Usage: $0 -m message [-r repository] file1 ..."
repo=~/test

while getopts "m:r:" opt; do #Start the options handling block. We accept -m for commit msg and repo name. Repo dir is assumed to be under ~
	case $opt in 
		m ) if [ -n "$OPTARG" ]; then message=$OPTARG; fi ;; 
		r ) ;; #repo=$OPTARTG; echo $repo ;;
		\? ) echo $usage 
		exit 1 ;;
	esac
done

shift $((OPTIND - 1))

if [ -z "$*" ]; then	#Exit if no arguments
	echo $usage
	exit 1
fi

if !  [ -d "$repo/.git" ]; then		#Check if the repository exists at given location
	echo "$repo is not a git repository"
	exit 1
#Move the files into repo
fi	
for filename in "$@"; do 
	target=$repo/${filename#*/}
	if [ -f $1 ] && [ -r $1 ]; then 

		if ! [ -f $target ] || [ $filename -nt $target ]; then  #Check if the file already exists in repository, if not, put it there
			cp $filename $target
		fi

		cd "$repo"
		git add ${filename#*/}
		cd $OLDPWD
	fi
done

#Commit and push
cd $repo
if [ -n "$message" ]; then 
	msg="-m \"$message\""
fi
eval "git commit" $msg
reponame=${repo#/home/$USER/}
git push ${reponame%/*}
