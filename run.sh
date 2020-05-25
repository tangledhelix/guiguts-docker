#!/bin/sh

BASE="${HOME}/dp"

IMAGE="tangledhelix/guiguts:latest"

# Guiguts settings
HOST_GGRC="${BASE}/guiguts/setting.rc"
CONTAINER_GGRC="/dp/guiguts/setting.rc"

# Guiguts header
HOST_HEADER="${BASE}/guiguts/header.txt"
CONTAINER_HEADER="/dp/guiguts/header.txt"

# Projects directory
HOST_PP="${BASE}/pp"
CONTAINER_PP="/dp/pp"

# Create an empty config file if one doesn't exist
if [ ! -f $HOST_GGRC ]; then
    echo "=> Guiguts settings not found - creating empty file"
    touch $HOST_GGRC
fi
# Create an empty header file if one doesn't exist
if [ ! -f $HOST_HEADER ]; then
    echo "=> Guiguts headers not found - creating empty file"
    touch $HOST_HEADER
fi

xhost + 127.0.0.1

echo "=> Starting container"
docker run --rm -d -e DISPLAY=host.docker.internal:0 \
    -v ${HOST_PP}:${CONTAINER_PP} \
    -v ${HOST_GGRC}:${CONTAINER_GGRC} \
    -v ${HOST_HEADER}:${CONTAINER_HEADER} \
    ${IMAGE}
echo "=> Container launched."

exit 0

