#!/bin/sh
#
# This script will scan for Free-to-Air Digital TV broadcasts in your area.
# Testing was done in Kampala, Uganda
#
# NOTE: For this script to work, you need to first install w_scan utility 
# i.e. In Fedora/Red Hat/CentOS:  yum -vy install w_scan

# Copyright (C) 2011 Joseph Zikusooka.
#
# Contact me at: joseph AT zikusooka.com


HOME_DIR=$HOME
W_SCAN_CMD=`which w_scan`
DVB_TYPE=t #(DVB-T)

APP_NUMBER=$1
COUNTRY_CODE=$2

# If empty set to default
if [ "x$APP_NUMBER" = "x" ];
then
clear
echo "Usage: ./`basename $0` [Program_used_to_play_TV e.g. 1] [COUNTRY]

1. Xine

2. Kaffeine

3. Mplayer

"
exit 1
fi


if [ "x$COUNTRY_CODE" = "x" ];
then
COUNTRY_CODE=UG
fi



case $APP_NUMBER in
1|'')
# Xine
CHANNELS_FILE_FORMAT=X
APP_CONFIG_DIR=$HOME_DIR/.xine
;;
2)
# Kaffeine
CHANNELS_FILE_FORMAT=k
APP_CONFIG_DIR=$HOME_DIR/.kaffeine
;;
3)
# Mplayer
CHANNELS_FILE_FORMAT=M
APP_CONFIG_DIR=$HOME_DIR/.mplayer
;;
*)
# Others
CHANNELS_FILE_FORMAT="o 6"
APP_CONFIG_DIR=$HOME_DIR
;;
esac

# Set Channels filename
CHANNELS_FILE=$APP_CONFIG_DIR/channels.conf

echo $COUNTRY_CODE



#################
#  MAIN SCRIPT  #
#################
# Create App config directory if it does not exist
[ -d $APP_CONFIG_DIR ] || mkdir -p $APP_CONFIG_DIR

# Backup existing file
[ ! -e $CHANNELS_FILE ] || mv -v $CHANNELS_FILE $CHANNELS_FILE.`date +%Y%m%d`

# Scan
#w_scan -f $DVB_TYPE -c $COUNTRY_CODE -$CHANNELS_FILE_FORMAT -E0 > $CHANNELS_FILE
w_scan -f $DVB_TYPE -c $COUNTRY_CODE -$CHANNELS_FILE_FORMAT -E 1 -O 1 > $CHANNELS_FILE

# Location of channels.conf file
clear
echo "Your channels.conf file is located at:
$CHANNELS_FILE
"
