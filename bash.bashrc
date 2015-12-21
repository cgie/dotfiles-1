export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export GT_USER="edoardo"
export GT_KEY="*******************************"
export GT_AWS_ZONE="us-west-2c"
export GT_URL="https://*******************.com"
export WORKSPACES="/Users/edoardo/Workspaces"
export DOWNLOADS="/Users/edoardo/Downloads"
export TUNA_HOME=$WORKSPACES/tuna_src/Tuna
export GOPATH=$WORKSPACES/go.sources
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export BONSAIO_HOST="*********"
export BONSAIO_KEY="**********"
export BONSAIO_SECRET="*******"
export MONGOLAB_HOST="********"
export MONGOLAB_USER="********"
export MONGOLAB_PASS="********"
export HOMEBREW_GITHUB_API_TOKEN="********"
export DEVELOPMENT_PROXY="********"
export EDITOR=/usr/local/bin/nvim
export LANG=en_US.UTF-8

# Do something good with my prompt
. ~/.bash_prompt
. ~/.bash_aliases

# config_docker() {
#    [ -z $DOCKER_HOST ] && boot2docker up && export DOCKER_HOST="tcp://$(boot2docker ip 2>/dev/null):2376"
#    export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
#    export DOCKER_TLS_VERIFY=1
# }
#
# docker() {
#    config_docker
#    /usr/local/bin/docker "$@"
# }
#
# fig() {
#    config_docker
#    /usr/local/bin/fig "$@"
# }

# git tab completion (homebrew)
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ];
then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--extended --cycle"

# Use ~~ as the trigger sequence instead of the default **
# export FZF_COMPLETION_TRIGGER='~~'
# Options to fzf command
# export FZF_COMPLETION_OPTS='+c -x'

