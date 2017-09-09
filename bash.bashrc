# a lot of environment variables that it's better keep "classified"
################################################################################
# a lot of environment variables that it's better keep "classified"
################################################################################
# a lot of environment variables that it's better keep "classified"
################################################################################
export EDITOR=/usr/local/bin/vim
export LANG=C
# export LANG=en_US.UTF-8
export HISTCONTROL=ignoreboth:erasedups
export NODE_ENV='development'
export TERM=xterm-256color
export GOPATH=$WORKSPACES/go.sources
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$HOME/.rvm/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:/Users/user/.symlinks/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:/Users/user/.local/bin

# Do something good with my prompt
. ~/.bash_prompt
. ~/.bash_aliases

# config_docker() {
#    [ -z $DOCKER_HOST ] && boot2docker up && export DOCKER_HOST="tcp://$(boot2docker ip 2>/dev/null):2376"
#    export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
#    export DOCKER_TLS_VERIFY=1
# }
# docker() {
#    config_docker
#    /usr/local/bin/docker "$@"
# }
# fig() {
#    config_docker
#    /usr/local/bin/fig "$@"
# }

## git tab completion (homebrew)
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ];
then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

## FZF
## https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--extended --cycle"
# Use ~~ as the trigger sequence instead of the default **
# export FZF_COMPLETION_TRIGGER='~~'
# Options to fzf command
# export FZF_COMPLETION_OPTS='+c -x'
eval "$(stack --bash-completion-script stack)"

## GPG - GPG-Agent:
## https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)

## NVM (Node Version Manager)
## https://github.com/creationix/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
