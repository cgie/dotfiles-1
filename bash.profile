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
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load RBENV
# https://github.com/rbenv/rbenv
eval "$(rbenv init -)"

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

function bp_define_helpers () {
  Time12a="\$(date +%H:%M)"
  Time24h="\$(date +%T)"
  PathShort="\w"
  User="\u"
  Hostname="\h"
}

# Load GitBashPrompt
# https://github.com/magicmonty/bash-git-prompt
# gitprompt configuration
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share

    # Set config variables first
    GIT_PROMPT_ONLY_IN_REPO=0

    # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
    # GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
    # GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files
    # GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10
    # GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
    # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence
    # as last entry source the gitprompt script
    # GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
    # GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
    # GIT_PROMPT_THEME=Default
    GIT_PROMPT_THEME="Custom"

    # GIT_PROMPT_START="_LAST_COMMAND_INDICATOR_ ${Cyan}${User}@${Hostname} ${Yellow}${PathShort}${ResetColor}"
    # GIT_PROMPT_END=" \n${White}${Time24h}${ResetColor} $ "

    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

source "/usr/local/opt/autoenv/activate.sh"

#
#- end
