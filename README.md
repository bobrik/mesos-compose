# Mesos in one command

This is docker compose config inspired by [blog post by Sebastien Goasguen]
(http://sebgoa.blogspot.com/2015/03/1-command-to-mesos-with-docker-compose.html).

It uses official images from mesosphere and host networking to enable
interactions with tasks over real network. It also enables docker containerizer.
No state is persisted between runs so feel free to start over if you
screwed cluster state or something.

## Versions

* Mesos 0.28.0
* Marathon 1.0.0-RC1
* Chronos 2.4.0 (optional)

Note that you need `docker-compose` 1.6.0 or newer:

* https://github.com/docker/compose

## Usage

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

## Mesos slave IP address

Mesos tasks have `HOST` env variable passed by Mesos. The value by default
is the output of `hostname -s` command. In many environments local hostname
resolves to 127.0.0.1. This leads to Mesos tasks listening on `127.0.0.1`.

To fix this issue, open `docker-compose.yml`, find `SLAVE_IP_GOES_HERE` and
replace it with the IP address you want your tasks to listen on.

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
