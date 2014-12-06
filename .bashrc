# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export EDITOR=/usr/bin/vim
alias grep='grep --color'
export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\n\$ '
