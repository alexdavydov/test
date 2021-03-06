#!/bin/bash
usage="Usage: gitbackup.sh [-m message] [-r repository] file1 [file2] ..."
repo=~/test
# Start the options handling block. We accept -m for commit msg and repo name. Repo dir is assumed to be under ~
while getopts ":m:qr:" opt; do 
	case $opt in 
		m ) if [[ -n "$OPTARG" ]]; then message="$OPTARG"; fi ;; 
		r ) if [[ -n "$OPTARG" ]]; then repo="$OPTARG"; fi ;;
		q ) quiet="-q" ;;
		\? ) echo $usage 
		exit 1 ;;
	esac
done
shift $((OPTIND - 1))

if [[ -z "$*" ]]; then	# Exit if no arguments
	echo $usage
	exit 1
fi

if !  [[ -d "$repo/.git" ]]; then		# Check if the repository exists at given location
	echo "$repo is not a git repository"
	exit 1
fi	

# Move the files into repo
for filename in "$@"; do 
	target=$repo/${filename##*/} # Strip directory part and append repo path
	if [[ -e $filename ]] && [[ -r $filename ]];  then 
		if ! [[ -e $target ]] || [[ $filename -nt $target ]]; then  # Check if the file already exists in repository, if not, put it there
			cp -r $filename $target
		fi

		cd "$repo" # We should be in git's repo directory
		git add ${filename##*/}
		cd $OLDPWD
	fi
done

# Commit and push
cd $repo
if [[ -n "$message" ]]; then 
	message="-m $message"
fi
git commit "$message" "$quiet" # Supply the commit message if present, otherwise we rely on git's prompt
reponame=${repo#/home/$USER/}
if [[ -n $quiet ]]; then
	git push -q ${reponame%%/*} 
else git push ${reponame%%/*}
fi
