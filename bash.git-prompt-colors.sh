# This is the custom theme template for gitprompt.sh
# https://github.com/magicmonty/bash-git-prompt

override_git_prompt_colors() {
	# Time12a="\$(date +%H:%M)"
	Time24h="\$(date +%T)"
	# PathShort="\w"
	# User="\u"
	# Hostname="\h"
	GIT_PROMPT_THEME_NAME="Custom"
	GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${Cyan}${USER}@${HOSTNAME} ${Yellow}${PathShort}${ResetColor}"
	GIT_PROMPT_START_ROOT="${GIT_PROMPT_START_USER}"
	GIT_PROMPT_END_USER=" \n${White}${Time24h}${ResetColor} $ "
	GIT_PROMPT_END_ROOT="${GIT_PROMPT_END_USER}"
}

reload_git_prompt_colors "Custom"
