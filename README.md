# Mesos in one command

This is docker compose config inspired by [blog post by Sebastien Goasguen]
(http://sebgoa.blogspot.com/2015/03/1-command-to-mesos-with-docker-compose.html).

It uses official images from mesosphere and host networking to enable
interactions with tasks over real network. It also enables docker containerizer.
No state is persisted between runs so feel free to start over if you
screwed cluster state or something.

## Versions

* Mesos 1.0.1
* Marathon 1.3.0
* Chronos 2.4.0 (optional)

Note that you need `docker-compose` 1.6.0 or newer:

* https://github.com/docker/compose

## Compatibility

This project should work out of the box with docker machine. It requires
host networking to work, so docker for mac won't work.

If you have docker built dynamically, which is the case on most distros,
you should download and bind-mount statically linked docker client:

```
curl -sL https://get.docker.com/builds/Linux/x86_64/docker-1.11.1.tgz | \
  tar xv --strip-components 1 -C /usr/local/bin
```

This downloads docker 1.11.1 and installs binaries into `/usr/local/bin`.

## Usage

You have to specify `DOCKER_IP` env variable in order to make Mesos work
properly. The default value is `127.0.0.1` and it should work if you have
Docker daemon running locally.

If you use `docker-machine` you can do the following, assuming `dev` is your
machine's name:

```
export DOCKER_IP=$(docker-machine ip dev)
```

Run your cluster in the background (equivalent to `docker-compose up -d`):

```
make start
```

That's it, use the following URLs:

* http://$DOCKER_IP:5050/ for Mesos master UI
* http://$DOCKER_IP:5051/ for the first Mesos slave UI
* http://$DOCKER_IP:5052/ for the second Mesos slave UI
* http://$DOCKER_IP:8080/ for Marathon UI
* http://$DOCKER_IP:8888/ for Chronos UI

If you want to run your cluster in foreground to see logs and be able to stop
it with Ctrl+C, use the following (equivalent to `docker-compose up`):

```
make run
```

To kill your cluster and wipe all state to start fresh:

```
make destroy
```

This is equivalent to issuing `docker-compose stop && docker-compose rm -f -v`.

## Task recovery

Since Mesos slaves run in containers and everything is killed when container
is stopped, there is no possibility to test task recovery. You might think
that docker container recovery is still possible, but you are wrong:

* https://issues.apache.org/jira/browse/MESOS-3573

## Optional services

In `docker-compose.yml` you can uncomment additional containers.

### Second mesos-slave

Uncomment `slave-two` section to get access to the second mesos-slave. Port
ranges of two mesos-slaves are separated so it shouldn't be an issue.

Note that both slaves share same memory so you might see OOM if you allocate
and use more memory than your docker host has.

### Chronos

Uncomment `chronos` section to get access to Chronos framework.

## Deploying on marathon

A sample app definition in YAML is included for your convenience in `apps` dir.
Use the following command to deploy it:

```
make APP=example deploy
```

Feel free to add your apps to `apps` and deploy them similarly.
