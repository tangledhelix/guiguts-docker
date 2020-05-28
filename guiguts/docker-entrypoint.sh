#!/bin/sh

if [ ! -f /dp/guiguts-persistent/setting.rc ]; then
    cp /dp/guiguts/default-settings.rc /dp/guiguts-persistent/setting.rc
fi
if [ ! -f /dp/guiguts-persistent/header.txt ]; then
    cp /dp/guiguts/headerdefault.txt /dp/guiguts-persistent/header.txt
fi

exec perl /dp/guiguts/guiguts.pl

