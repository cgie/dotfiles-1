#!/bin/bash
#
# CRM .bash_profile Time-stamp: "2008-12-07 19:42"
#
# echo "Loading ${HOME}/.bash_profile"

source ~/.profile # Get the paths
source ~/.bashrc  # get aliases

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

#
#- end
