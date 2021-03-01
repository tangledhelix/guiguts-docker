#!/bin/bash

export X11_IP_ADDR=$(ifconfig en0 | awk '/inet / {print $2}')

pgrep Xquartz >/dev/null
if [ $? -ne 0 ]; then
    open -a XQuartz
    sleep 5
fi

docker-compose up
docker-compose down
