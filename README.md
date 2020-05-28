
## About

This is a simple container-based guiguts setup. I developed it for Mac
users, but it could be used on Linux with some adjustments.

## Requirements

- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)
- [XQuartz](https://www.xquartz.org) (X11 server)

## Setup

In XQuartz preerences, go to the Security tab. Check the box next to "Allow
connections from network clients". Then restart XQuartz.

This is necessary because Docker will connect to the X11 server using the
localhost network interface rather than a unix socket file. But random
users still should not be able to connect to your X11 server.

By default, this Docker setup assumes you will use `~/dp/pp/` on your Mac
to store your DP projects. If that's not the case, you can change the path
in `docker-compose.yml`.

Lastly, allow connections to X11 from locahost. You migth want to put
this into your `.bash_profile`.

```
xhost +127.0.0.1
```

## Running guiguts

Easy:

```
docker-compose up -d
```

## Guiguts configuration

Docker will create a volume to store the Guiguts config file (setting.rc)
and the HTML header (header.txt). They should be saved between runs, even
though the Docker containers themselves are ephemeral.

Just update settings in the Guiguts preferences like you normally would,
and they should be saved properly.

If you want to update your HTML header, run guiguts and edit
`/dp/guiguts/header.txt`.

## Included tools

- Guiguts
- Aspell
- Jeebies
- Bookloupe
- DPCustomMono2 font

If you want to run a shell inside the container to poke around, you can
either use the "Open terminal" option in Guiguts Custom menu, which will
run an xterm, or you can run this command:

```
docker-compose exec guiguts bash
```

