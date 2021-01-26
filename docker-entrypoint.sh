#!/bin/sh

BASE="/dp/guiguts"

# If the settings file exists, but has zero size, then copy the default
# settings to it. We mount the settings file into the container so it can
# be persisted to the host filesystem. But we only want to overwrite if
# the file is currently empty.

SETTING_FILE="$BASE/setting.rc"
DEFAULT_SETTINGS="$BASE/default-settings.rc"

if [ -f $SETTING_FILE -a ! -s $SETTING_FILE ]; then
    echo "Empty setting.rc file found - installing default contents"
    cp $DEFAULT_SETTINGS $SETTING_FILE
fi

# If the header file exists, but has zero size, then copy the default
# header to it. We mount the header file into the container so it can
# be persisted to the host filesystem. But we only want to overwrite if
# the file is currently empty.

HEADER_FILE="$BASE/header.txt"
DEFAULT_HEADER="$BASE/headerdefault.txt"

if [ -f $HEADER_FILE -a ! -s $HEADER_FILE ]; then
    echo "Empty header.txt file found - installing default contents"
    cp $DEFAULT_HEADER $HEADER_FILE
fi

# Run Guiguts

exec perl $BASE/guiguts.pl

