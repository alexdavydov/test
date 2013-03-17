#!/bin/bash

#Setup current user's environment on a remote host
#(C) 2013 Alex Davydov 

function printhelp () {
cat << EOF
setupenv - setup current user's environment and keys on a remote host

Usage:	setupenv [OPTIONS] REMOTE_HOST

-h	print this message
-n	only copy public keys and setup authorized_keys
-q	suppress output
-u	username

REMOTE_HOST can be either hostname or IP address
EOF
exit 0
}

function printusage ()
{
echo "Usage: setupenv [-hnq] [-u USERNAME] REMOTE_HOST"
exit 1
}

declare remotehost
testfile=file_$(cat /dev/urandom | tr -dc [:alnum:] | head -c16) #Make a good random filename
username=$USER
keysonly=0
quiet=""

while getopts "hnqu:" arg
	do 
	case $arg in
	h ) printhelp  ;;
	n ) keysonly=1 ;;
	q ) quiet="-q" ;;
	u ) if [[ -n $OPTARG ]]; then username="$OPTARG"; else printusage; fi ;;
	\?) printusage ;; 
	esac
done
shift $((OPTIND-1))

#Check validity of the argument
if [[ $1 =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then remotehost=$1; #Simple 4-octet regex, can be improved with a full-blown match
	elif [[ $1 =~ ^[a-zA-Z0-9\-\.]{1,255}$ ]]; then remotehost=$1; #We also accept hostnames
	else printusage; 
fi

#Verify writeability of the remote directory
#Then check existence of .ssh and authorized_keys. If not, create those
if [[ -z $quiet ]]; then echo "Testing if we can write to remote directory..."; fi
ssh $quiet $username@$remotehost bash << EOF
touch "$testfile"
if [[ -e "$testfile" ]]; then 
	rm $testfile; 
	else echo "Remote directory not writeable"; exit 1
fi
cd ~
if ! [[ -d .ssh ]]; then 
	mkdir .ssh
	chmod 0700 .ssh
fi
cd .ssh
if ! [[ -e authorized_keys ]]; then 
	touch authorized_keys
	chmod 700 authorized_keys
fi
EOF


if [[ -z  $quiet ]]; then echo "Copying public and private keys...:"; fi
scp $quiet ~/.ssh/id_rsa ~/.ssh/id_rsa.pub $username@$remotehost:~/.ssh

if [[ -z  $quiet ]]; then echo "Setting up remote authorized_keys..."; fi
ssh $quiet $username@$remotehost bash << EOF
cd ~/.ssh
cat id_rsa.pub >> authorized_keys
EOF

#Copy user's environment files
if [[ $keysonly = 0 ]]; then

	if [[ -z  $quiet ]]; then echo "Copying environment files..."; fi

	if [[ -r ~/.bashrc ]]; then bashrc=~/.bashrc; fi
	if [[ -r ~/.bash_profile ]]; then bash_profile=~/.bash_profile; fi
	if [[ -r ~/.vimrc ]]; then vimrc=~/.vimrc; fi
	if [[ -r ~/.screenrc ]]; then screenrc=~/.screenrc; fi
	if [[ -r ~/.bash_logout ]]; then bash_logout=~/.bash_logout; fi
	
	scp $quiet $bashrc $bash_profile $vimrc $screenrc $bash_logout $username@$remotehost:~
	if [[ -z $? ]]; then echo "Success"; fi
fi 
