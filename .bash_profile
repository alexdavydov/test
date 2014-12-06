# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:/foss/bin

export PATH
rm -f ~/.ssh/ssh_auth_sock
ln -s $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
