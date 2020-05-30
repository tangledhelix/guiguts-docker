#!/bin/sh

if [ ! -s /dp/guiguts/setting.rc ]; then
    cp /dp/guiguts/default-settings.rc /dp/guiguts/setting.rc
fi
if [ ! -s /dp/guiguts/header.txt ]; then
    cp /dp/guiguts/headerdefault.txt /dp/guiguts/header.txt
fi

exec perl /dp/guiguts/guiguts.pl

