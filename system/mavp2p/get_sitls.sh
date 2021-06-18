#!/bin/bash -x

sleep 10;

SITL_IPS="$(getent hosts sitl | awk '{print $1}')"

MAVP2P_ARGS="$@"

for ip in $SITL_IPS; do 
    MAVP2P_ARGS="$MAVP2P_ARGS tcpc:$ip:5760"
done

exec mavp2p $MAVP2P_ARGS
