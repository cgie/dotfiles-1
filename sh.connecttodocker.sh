#!/bin/bash

source ~/.bashrc

set -o nounset
set -o errexit
set -o pipefail

SAFER_IFS=$'\n\t,'
IFS="$SAFER_IFS"

# eval export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://192.168.64.4:2376"
# export DOCKER_CERT_PATH="/Users/edoardo/.docker/machine/machines/default"
# export DOCKER_MACHINE_NAME="default"
# # Run this command to configure your shell:
# # eval $(docker-machine env) && export DOCKER_HOST_IP=192.168.64.4
# eval $(docker-machine env) && export DOCKER_HOST_IP=$(docker-machine ip default)

##
# Basic helpers
out() { echo "$(date +%Y%m%dT%H%M%SZ): $*"; }
err() { out "$*" 1>&2; }
vrb() { [ ! "$VERBOSE" ] || out "$@"; }
dbg() { [ ! "$DEBUG" ] || err "$@"; }

## DockerMachine upgrade
upgrade_docker_machine() {
  docker-machine upgrade
  if [ $? == 0 ]; then
    echo "DockerMachine upgraded"
    return 0
  else
    echo "DockerMachine cannot upgrade"
    return 1
  fi
}

##
# Docker connection
is_docker_running() {
   ret=$(docker-machine status default)
   if [ $? == 0 ]; then
     if [ "$1" = true ]; then
       echo "DockerMachine is $ret"
     fi
     if [[ $ret == "Running" ]] ; then
       return 0
     else
       return 1
     fi
   else
     echo "DockerMachine status error"
     return 1
  fi
}

start_docker_machine() {
  ret=$(docker-machine start default )
  if [ $? == 0 ]; then
    echo "DockerMachine started"
    docker-machine ls
    return 0
  else
    echo "DockerMachine cannot start"
    return 1
  fi
}

set_docker_environment() {
  eval "$(docker-machine env default)"
  export DOCKER_HOST_IP=$(docker-machine ip default)
  echo "DockerMachine listening on $DOCKER_HOST_IP"
  docker ps -a
}

into_docker_machine() {
  docker-machine ssh default
}

main() {
  echo "Starting DockerMachine"
  end=$((SECONDS+60))
  if ! is_docker_running true; then
    start_docker_machine
  fi
  while ! is_docker_running false; do
    echo -n .
    sleep 2
    if [ $SECONDS -gt $end ]; then
      echo "DockerMachine is taking too long; I give up"
      exit 1
    fi
  done
  echo -ne '*****                     (33%)\r'
  sleep 0.3
  echo -ne '*************             (66%)\r'
  sleep 0.3
  echo -ne '***********************   (100%)\r'
  sleep 0.3
  echo -ne '\n'
  set_docker_environment
  echo "Enjoy Docker"
  return 0
}

main "$@"

