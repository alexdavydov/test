#!/bin/bash

# Setup current user's environment on a remote host
# (c) 2013 Alex Davydov 

function printhelp () {
cat << EOF
setupenv - setup current user's environment and keys on a remote host
Usage:	setupenv [OPTIONS] REMOTE_HOST

	-h		print this message
	-k [PATH]	path to public key, if not set, look into ssh-agent 
	-n		only copy public key and setup authorized_keys
	-q		suppress output
	-u USERNAME	username to be used for remote login

REMOTE_HOST can be either hostname or IP address
Default key is ~/.ssh/id_rsa.pub
If you do not specify the key file and multiple identities are present in ssh-agent, the first one is used.
EOF
exit 0
}

function printusage ()
{
echo "Usage: setupenv [-hnq] [-k PUBKEY] [-u USERNAME] REMOTE_HOST"
exit 1
}

# Declarations
testfile=file_$(cat /dev/urandom | tr -dc [:alnum:] | head -c16) # Make a good random filename
username=$USER
keysonly=0
quiet=""

while getopts ":hk:nqu:" arg; do 
	case $arg in
	h ) printhelp  ;;
	k ) key=$OPTARG ;;
	n ) keysonly=1 ;;
	q ) quiet="-q" ;;
	u ) if [[ -n $OPTARG ]]; then 
		username="$OPTARG" 
	    else printusage; fi ;;
	* ) printusage ;;
	\?) printusage ;; 
	esac
done
shift $((OPTIND-1))

# Check validity of $remotehost
remotehost=$1
if ! [[ $remotehost =~ ^[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}$ || $remotehost =~ ^[[:alnum:]]\_\.{1,255}$  ]]; then # Simple 4-octet regex, can be improved with a full-blown match
	printusage 
#elif ! [[ $remotehost =~ ^[a-zA-Z0-9\-\.]{1,255}$ ]]; then  # We also accept hostnames
#	printusage 
fi

# Verify OpenSSH pubkey file validity. If there's none specified, check ssh-agent for useable identities.
if [[ -z $key ]]; then 
	if [[ -n $(pgrep ssh-agent) ]]; then 
		if ! [[ $(ssh-add -l) =~ "The agent has no identities" ]]; then 
			key=$(ssh-add -l | head -1 | cut -d" " -f3).pub
		fi
	elif [[ -r ~/.ssh/id_rsa.pub ]]; then 
		key=~/.ssh/id_rsa.pub
	else 
		printusage
	fi
elif  [[ -z $(grep ssh-rsa $key) && -z $(grep ssh-dss $key) ]]; then
	echo "$key is not a valid OpenSSH public key"
	exit 1
fi

# Verify writeability of the remote directory
# Then check existence of .ssh and authorized_keys. If not, create them
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
	chmod 600 authorized_keys
fi
EOF


if [[ -z  $quiet ]]; then echo "Copying public key...:"; fi
scp $quiet $key $username@$remotehost:~/.ssh

key=${key##*/}
if [[ -z  $quiet ]]; then echo "Setting up remote authorized_keys..."; fi
ssh $quiet $username@$remotehost bash << EOF
	cd ~/.ssh
	chmod 644 $key
	cat $key >> authorized_keys
EOF

# Copy user's environment files
if [[ $keysonly = 0 ]]; then

	if [[ -z  $quiet ]]; then echo "Copying environment files..."; fi

	if [[ -r ~/.bashrc ]]; then bashrc=~/.bashrc; fi
	if [[ -r ~/.bash_profile ]]; then bash_profile=~/.bash_profile; fi
	if [[ -r ~/.vimrc ]]; then vimrc=~/.vimrc; fi
	if [[ -r ~/.screenrc ]]; then screenrc=~/.screenrc; fi
	if [[ -r ~/.bash_logout ]]; then bash_logout=~/.bash_logout; fi
	
	scp $quiet $bashrc $bash_profile $vimrc $screenrc $bash_logout $username@$remotehost:~
fi
