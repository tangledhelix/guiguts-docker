
## About

This is a simple container-based Guiguts setup. I developed it for Mac users,
but it could be used on Linux (may need some adjustments).

## Requirements

- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)
- [XQuartz](https://www.xquartz.org) (X11 server)

## Setup

In XQuartz preferences, go to the Security tab. Check the box next to "Allow
connections from network clients". Then restart XQuartz.

This is necessary because Docker will connect to the X11 server using the
localhost network interface rather than a unix socket file. But random users
(even on a LAN) still should not be able to connect to your X11 server.

By default, this Docker setup assumes you will use `~/dp/pp/` on your Mac to
store your DP projects. If that's not the case, you can change the local path
in `docker-compose.yml`.

Inside Guiguts, projects are in the `/dp/pp` directory.

Create a directory `~/.guiguts` on your Mac and touch `header.txt` and
`setting.rc` within it.

```
mkdir -p ~/.guiguts
touch ~/.guiguts/setting.rc ~/.guiguts/header.txt
```

(If you don't like that path, use another, but adjust the paths in
`docker-compose.yml` to match.)

Lastly, allow connections to X11 from locahost. You might want to put this into
your `.bash_profile`.

```
xhost +127.0.0.1
```

## Running guiguts

Easy:

```
cd {wherever docker-compose.yml is}
docker-compose up -d
```

The container will handle everything from there. When you quit Guiguts, the
container will stop running.

## Guiguts configuration

Docker will store the Guiguts config file (setting.rc) and the HTML header
(header.txt) on your Mac's filesystem, not within Docker. They should be saved
between runs, even though the Docker containers themselves are ephemeral.
They're stored in `~/.guiguts`.

Just update settings in the Guiguts preferences like you normally would, and
they should be saved properly.

## Included tools

- Guiguts
- Aspell
- Jeebies
- Bookloupe
- DPSansMono2 font
- Geeqie (image viewer)
- HTML Tidy
- Xterm (terminal)
- ebookmaker

If you want to run a shell inside the container to poke around, you can either
use the "Open terminal" option in Guiguts "Custom menu", which will launch an
xterm, or you can run this command to attach to the container and run a bash
shell:

```
docker-compose exec guiguts bash
```

You can see output from the container by viewing the Docker log:

```
docker-compose logs guiguts
```

