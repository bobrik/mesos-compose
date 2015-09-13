# Mesos in one command

This is docker compose config inspired by [blog post by Sebastien Goasguen]
(http://sebgoa.blogspot.com/2015/03/1-command-to-mesos-with-docker-compose.html).

It uses official images from mesosphere and host networking to enable
interactions with tasks over real network. It also enables docker containerizer.

No state is persisted between runs so feel free to start over if you
screwed cluster state or something.

## Usage

Provided configuration should be usable out of the box with boot2docker
that runs on IP `192.168.99.100`. Change IP address in `docker-compose.yml`
if you have different network configuration. On ubuntu you also have to
change `/usr/local/bin/docker` to `/usr/bin/docker`.

Run your cluster:

```
docker-compose up -d
```

That's it, use the following URLs:

* http://192.168.99.100:5050/ for mesos master UI
* http://192.168.99.100:8080/ for marathon UI
* http://192.168.99.100:8081/ for chronos UI

To kill your cluster with all the data:

```
docker-compose stop
docker-compose rm -f -v
```
