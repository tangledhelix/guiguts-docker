#!/bin/sh

if [ ! -s /dp/guiguts/src/setting.rc ]; then
    cp /dp/guiguts/src/default-settings.rc /dp/guiguts/src/setting.rc
fi
if [ ! -s /dp/guiguts/src/header.txt ]; then
    cp /dp/guiguts/src/headerdefault.txt /dp/guiguts/src/header.txt
fi

exec perl /dp/guiguts/src/guiguts.pl

