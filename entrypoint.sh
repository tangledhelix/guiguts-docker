#!/bin/sh

# Guiguts config
CFG="/dp/guiguts/setting.rc"
DEFAULT_CFG="/dp/guiguts-base-settings.rc"

# Guiguts header (HTML)
HEADER="/dp/guiguts/header.txt"
DEFAULT_HEADER="/dp/guiguts/headerdefault.txt"

# Check if the settings file is 0 bytes.
# If so, then copy the default config to initialize it.
if [ -f $CFG -a -w $CFG -a ! -s $CFG ]; then
    echo "Installing default guiguts config"
    cp $DEFAULT_CFG $CFG
fi
# Same for HTML header
if [ -f $HEADER -a -w $HEADER -a ! -s $HEADER ]; then
    echo "Installing default guiguts HTML header"
    cp $DEFAULT_HEADER $HEADER
fi

cd /dp/pp
perl /dp/guiguts/guiguts.pl

