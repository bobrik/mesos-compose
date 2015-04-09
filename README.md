# Mesos in one command

This is docker compose config inspired by [blog post by Sebastien Goasguen](http://sebgoa.blogspot.com/2015/03/1-command-to-mesos-with-docker-compose.html).

It uses official images from mesosphere and host networking to enable
interactions with tasks over real network. It also enables docker containerizer.

No state is persisted between runs so feel free to start over if you
screwed cluster state or something.

## Usage

Provided configuration should be usable out of the box with boot2docker
that runs on IP `192.168.59.103`. Change IP address in `docker-compose.yml`
if you have different network configuration. On ubuntu you also have to
change `/usr/local/bin/docker` to `/usr/bin/docker`.

```
docker-compose up
```

That's it, use the following URLs:

* http://192.168.59.103:5050/ for mesos master UI
* http://192.168.59.103:8000/ for marathon UI

## Caveats

With mesos 0.22 docker containers get stuch in `TASK_STAGING` state,
this bug would be fixed in 0.22.1 or when docker compose gets support
for host pid namespaces, whichever happens first.
