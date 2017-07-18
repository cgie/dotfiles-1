
### docker

```
$ docker
Usage: docker [OPTIONS] COMMAND [arg...]
       docker [ --help | -v | --version ]

A self-sufficient runtime for containers.

Options:

  --config=~/.docker              Location of client config files
  -D, --debug                     Enable debug mode
  -H, --host=[]                   Daemon socket(s) to connect to
  -h, --help                      Print usage
  -l, --log-level=info            Set the logging level
  --tls                           Use TLS; implied by --tlsverify
  --tlscacert=~/.docker/ca.pem    Trust certs signed only by this CA
  --tlscert=~/.docker/cert.pem    Path to TLS certificate file
  --tlskey=~/.docker/key.pem      Path to TLS key file
  --tlsverify                     Use TLS and verify the remote
  -v, --version                   Print version information and quit

Commands:
    attach    Attach to a running container
    build     Build an image from a Dockerfile
    commit    Create a new image from a container's changes
    cp        Copy files/folders between a container and the local filesystem
    create    Create a new container
    diff      Inspect changes on a container's filesystem
    events    Get real time events from the server
    exec      Run a command in a running container
    export    Export a container's filesystem as a tar archive
    history   Show the history of an image
    images    List images
    import    Import the contents from a tarball to create a filesystem image
    info      Display system-wide information
    inspect   Return low-level information on a container or image
    kill      Kill a running container
    load      Load an image from a tar archive or STDIN
    login     Register or log in to a Docker registry
    logout    Log out from a Docker registry
    logs      Fetch the logs of a container
    network   Manage Docker networks
    pause     Pause all processes within a container
    port      List port mappings or a specific mapping for the CONTAINER
    ps        List containers
    pull      Pull an image or a repository from a registry
    push      Push an image or a repository to a registry
    rename    Rename a container
    restart   Restart a container
    rm        Remove one or more containers
    rmi       Remove one or more images
    run       Run a command in a new container
    save      Save an image(s) to a tar archive
    search    Search the Docker Hub for images
    start     Start one or more stopped containers
    stats     Display a live stream of container(s) resource usage statistics
    stop      Stop a running container
    tag       Tag an image into a repository
    top       Display the running processes of a container
    unpause   Unpause all processes within a container
    update    Update resources of one or more containers
    version   Show the Docker version information
    volume    Manage Docker volumes
    wait      Block until a container stops, then print its exit code

Run 'docker COMMAND --help' for more information on a command.
```

### docker-compose

```
$ docker-compose
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f=<arg>...] [options] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE           Specify an alternate compose file (default: docker-compose.yml)
  -p, --project-name NAME   Specify an alternate project name (default: directory name)
  --verbose                 Show more output
  -v, --version             Print version and exit

Commands:
  build              Build or rebuild services
  config             Validate and view the compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  help               Get help on a command
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pulls service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information
```

### docker-machine

```
$ docker-machine
Usage: docker-machine [OPTIONS] COMMAND [arg...]

Create and manage machines running Docker.

Version: 0.6.0, build e27fb87

Author:
  Docker Machine Contributors - <https://github.com/docker/machine>

Options:
  --debug, -D           Enable debug mode
  -s, --storage-path "/Users/edoardo/.docker/machine" Configures storage path [$MACHINE_STORAGE_PATH]
  --tls-ca-cert           CA to verify remotes against [$MACHINE_TLS_CA_CERT]
  --tls-ca-key            Private key to generate certificates [$MACHINE_TLS_CA_KEY]
  --tls-client-cert           Client cert to use for TLS [$MACHINE_TLS_CLIENT_CERT]
  --tls-client-key          Private key used in client TLS auth [$MACHINE_TLS_CLIENT_KEY]
  --github-api-token          Token to use for requests to the Github API [$MACHINE_GITHUB_API_TOKEN]
  --native-ssh            Use the native (Go-based) SSH implementation. [$MACHINE_NATIVE_SSH]
  --bugsnag-api-token           BugSnag API token for crash reporting [$MACHINE_BUGSNAG_API_TOKEN]
  --help, -h            show help
  --version, -v           print the version

Commands:
  active    Print which machine is active
  config    Print the connection config for machine
  create    Create a machine
  env     Display the commands to set up the environment for the Docker client
  inspect   Inspect information about a machine
  ip      Get the IP address of a machine
  kill      Kill a machine
  ls      List machines
  provision   Re-provision existing machines
  regenerate-certs  Regenerate TLS Certificates for a machine
  restart   Restart a machine
  rm      Remove a machine
  ssh     Log into or run a command on a machine with SSH.
  scp     Copy files between machines
  start     Start a machine
  status    Get the status of a machine
  stop      Stop a machine
  upgrade   Upgrade a machine to the latest version of Docker
  url     Get the URL of a machine
  version   Show the Docker Machine version or a machine docker version
  help      Shows a list of commands or help for one command

Run 'docker-machine COMMAND --help' for more information on a command.
```

### docker-machine-driver-xhyve

```
$ docker-machine-driver-xhyve
This is a Docker Machine plugin binary.
Plugin binaries are not intended to be invoked directly.
Please use this plugin through the main 'docker-machine' binary.
(API version: 1)
```

### docker-machine start (default)

```
$ docker-machine start default
Starting "default"...
(default) Waiting for VM to come online...
(default) Waiting on a pseudo-terminal to be ready... done
(default) Hook up your terminal emulator to /dev/ttys004 in order to connect to your VM
Machine "default" was started.
Waiting for SSH to be available...
Detecting the provisioner...
Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.
```

```
$ docker-machine env
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.64.3:2376"
export DOCKER_CERT_PATH="/Users/edoardo/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env)

$ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.64.3:2376"
export DOCKER_CERT_PATH="/Users/edoardo/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env default)

$ eval "$(docker-machine env default)"
$ env | grep -i docker

$ docker-machine ls
NAME      ACTIVE   DRIVER   STATE     URL                       SWARM   DOCKER   ERRORS
default   *        xhyve    Running   tcp://192.168.64.3:2376           v1.9.1
```

### upgrade

```
08:55:02 $ docker-machine upgrade
Waiting for SSH to be available...
Detecting the provisioner...
Upgrading docker...
Stopping machine to do the upgrade...
(default) Stopping default ...
(default) "disk2" unmounted.
(default) "disk2" ejected.
Upgrading machine "default"...
Default Boot2Docker ISO is out-of-date, downloading the latest release...
Latest release for github.com/boot2docker/boot2docker is v1.10.1
Downloading /Users/edoardo/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v1.10.1/boot2docker.iso...
0%....10%....20%....30%....40%....50%....60%....70%....80%....90%....100%
Copying /Users/edoardo/.docker/machine/cache/boot2docker.iso to /Users/edoardo/.docker/machine/machines/default/boot2docker.iso...
Starting machine back up...
(default) Waiting for VM to come online...
(default) Waiting on a pseudo-terminal to be ready... done
(default) Hook up your terminal emulator to /dev/ttys007 in order to connect to your VM
Restarting docker...
```

### create default

```
docker-machine create --driver xhyve default
```

```
$ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.64.4:2376"
export DOCKER_CERT_PATH="/Users/edoardo/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env default)

$ eval $(docker-machine env default)

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
redis               latest              4f5f397d4b7c        35 hours ago        177.6 MB
mongo               latest              467eb21035a8        39 hours ago        309.7 MB
elasticsearch       latest              3ac9ed8ea311        42 hours ago        346.6 MB
memcached           latest              9dae08adefcb        2 days ago          132.3 MB
```

### Stupid connectTo script

```bash
$ cat sh.connecttodocker.sh
#!/bin/bash

source ~/.bashrc

set -o nounset
set -o errexit
set -o pipefail

SAFER_IFS=$'\n\t,'
IFS="$SAFER_IFS"

##
# Basic helpers
out() { echo "$(date +%Y%m%dT%H%M%SZ): $*"; }
err() { out "$*" 1>&2; }
vrb() { [ ! "$VERBOSE" ] || out "$@"; }
dbg() { [ ! "$DEBUG" ] || err "$@"; }

# docker-machine upgrade
docker-machine start default
eval "$(docker-machine env default)"
docker-machine ls
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
# docker-machine ssh default
docker ps -a
```

### Run mongo

```
13:57:17 $ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
✔ edoardo@eddies-apple-box.local ~/Downloads
13:58:23 $ docker run --name mmongo -d mongo
00a496ed924552541dda8c98f3ff4974fb721368287c5b733cfee1e5a1abdd4d
✔ edoardo@eddies-apple-box.local ~/Downloads
13:59:05 $ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
00a496ed9245        mongo               "/entrypoint.sh mongo"   3 seconds ago       Up 2 seconds        27017/tcp           mmongo
✔ edoardo@eddies-apple-box.local ~/Downloads
13:59:08 $ mongo
MongoDB shell version: 2.6.11
connecting to: test
2016-03-04T13:59:17.168+0100 warning: Failed to connect to 127.0.0.1:27017, reason: errno:61 Connection refused
2016-03-04T13:59:17.169+0100 Error: couldn't connect to server 127.0.0.1:27017 (127.0.0.1), connection attempt failed at src/mongo/shell/mongo.js:146
exception: connect failed
✘-1 edoardo@eddies-apple-box.local ~/Downloads
13:59:17 $ echo $DOCKER_HOST
tcp://192.168.64.4:2376
✔ edoardo@eddies-apple-box.local ~/Downloads
14:00:56 $ mongo 192.168.64.4:27017
MongoDB shell version: 2.6.11
connecting to: 192.168.64.4:27017/test
2016-03-04T14:01:12.205+0100 warning: Failed to connect to 192.168.64.4:27017, reason: errno:61 Connection refused
2016-03-04T14:01:12.206+0100 Error: couldn't connect to server 192.168.64.4:27017 (192.168.64.4), connection attempt failed at src/mongo/shell/mongo.js:148
exception: connect failed
✘-1 edoardo@eddies-apple-box.local ~/Downloads
14:01:12 $ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
00a496ed9245        mongo               "/entrypoint.sh mongo"   2 minutes ago       Up 2 minutes        27017/tcp           mmongo
✔ edoardo@eddies-apple-box.local ~/Downloads
14:01:29 $ docker-machine env
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.64.4:2376"
export DOCKER_CERT_PATH="/Users/edoardo/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env)
✔ edoardo@eddies-apple-box.local ~/Downloads
14:01:49 $ docker run -it --link mmongo:mongo --rm mongo sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/test"'
MongoDB shell version: 3.2.3
connecting to: 172.17.0.3:27017/test
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	http://docs.mongodb.org/
Questions? Try the support group
	http://groups.google.com/group/mongodb-user
Server has startup warnings:
2016-03-04T12:59:06.234+0000 I CONTROL  [initandlisten]
2016-03-04T12:59:06.234+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/enabled is 'always'.
2016-03-04T12:59:06.234+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2016-03-04T12:59:06.235+0000 I CONTROL  [initandlisten]
2016-03-04T12:59:06.235+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/defrag is 'always'.
2016-03-04T12:59:06.235+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2016-03-04T12:59:06.235+0000 I CONTROL  [initandlisten]
> show dbs
local  0.000GB
>
```

## Expose services (mongo)

```bash
# terminal .1
$ docker run -p 27017:27017 --name mmongo mongo

# $ docker-machine ip default
# 192.168.64.4

# terminal .2
$ mongo --verbose 192.168.64.4:27017/test
```

## Create an Elasticsearch cluster

using an image with the KOPF plugin

```
# https://github.com/lmenezes/elasticsearch-kopf
$ ./elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf/v2.1.1
docker commit elasticsearch elasticsearchkopfed
```

```
docker run -d -p 9200:9200 -p 9300:9300 --name es0 elasticsearchkopfed elasticsearch -Des.node.name="spider"
docker run -d --name es1 --link es0 elasticsearchkopfed elasticsearch -Des.node.name="ant" -Des.discovery.zen.ping.unicast.hosts="es0"
docker run -d --name es2 --link es0 elasticsearchkopfed elasticsearch -Des.node.name="grasshopper" -Des.discovery.zen.ping.unicast.hosts="es0"
```

## Create development containers

- mongo
```
docker run -d --name mongo -p 27017:27017 mongo
```

- redis
```
docker run -d --name redis -p 6379:6379 redis
```

- cassandra
```
docker run -d --name cassandra -p 9042:9042 cassandra
```

- memcached
```
docker run -d --name memcached -p 11211:11211 memcached
```

- elasticsearch (cluster of 3 nodes, with Kopf)
```
docker run -d -p 9200:9200 -p 9300:9300 --name esTemp elasticsearch
$ docker exec -i -t esTemp /bin/bash
root@2836addc9d94:/usr/share/elasticsearch# ./bin/plugin install lmenezes/elasticsearch-kopf/v2.1.1
$ docker commit esTemp elasticsearchkopfed
sha256:c9277c3e731045895bebd3444edac3e39d4210511f4185b75d611334cabb5
$ docker stop esTemp && docker rm esTemp

docker run -d -p 9200:9200 -p 9300:9300 --name es0 elasticsearchkopfed elasticsearch -Des.node.name="spider"
docker run -d --name es1 --link es0 elasticsearchkopfed elasticsearch -Des.node.name="ant" -Des.discovery.zen.ping.unicast.hosts="es0"
docker run -d --name es2 --link es0 elasticsearchkopfed elasticsearch -Des.node.name="grasshopper" -Des.discovery.zen.ping.unicast.hosts="es0"
```

- postgresql (with dev user)
```
docker run -d --name postgres -p 5432:5432 postgres

$ docker exec -i -t postgres /bin/bash
root@7b47c4bbd748:/# su - postgres
$ bash
postgres@7b47c4bbd748:/$ createuser -s development
postgres@7b47c4bbd748:/$ psql
psql (9.5.2)
Type "help" for help.
postgres=# \password development
Enter new password:
Enter it again:
postgres=# \q
postgres@7b47c4bbd748:/$ exit
exit
$ exit
root@7b47c4bbd748:/# exit
exit
```

- mysql
```
$ docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$DB_PWD mysql
...
$ docker exec -i -t mysql /bin/bash
...
root@f8a5df300fa7:~# mysql -h localhost -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.18 MySQL Community Server (GPL)
...
mysql> select host, user from mysql.user ;
+-----------|-----------+
| host      | user      |
+-----------|-----------+
| %         | root      |
| localhost | mysql.sys |
| localhost | root      |
+-----------|-----------+
3 rows in set (0.00 sec)
```
