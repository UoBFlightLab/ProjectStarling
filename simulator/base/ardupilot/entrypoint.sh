#!/bin/bash

if [ $# -ne 0 ]; then
    exec "$@"
fi

# If AP_SYSID is "ordinal", then set AP_SYSID id to take AP_SYSID_BASE + ORDINAL from StatefulSet hostname
# Hostname is of the form '<stateful set name>-<ordinal>'
if [ "$AP_SYSID" == "ordinal" ]; then
    ORDINAL="${HOSTNAME##*-}"
    AP_SYSID=$((AP_SYSID_BASE + ORDINAL));
    if (($AP_SYSID > 0 && $AP_SYSID <= 255 )); then
        echo "AP_SYSID was 'ordinal' therefore set to $AP_SYSID (from base: $AP_SYSID_BASE and hostname: $HOSTNAME)"
        export AP_SYSID
    else
        echo "AP_SYSID was 'ordinal' but result ($AP_SYSID) was not valid (from base: $AP_SYSID_BASE and hostname: $HOSTNAME)"
        exit 1
    fi
elif [ "$AP_SYSID" == "ip" ]; then
    AP_SYSID=$(hostname -i | cut -d'.' -f4)
    echo "AP_SYSID was 'ip' therefore set to $AP_SYSID (from IP: $(hostname -i))"
    export AP_SYSID
elif (($AP_SYSID > 0 && $AP_SYSID <= 255 )); then
    echo "AP_SYSID setting as specified: $AP_SYSID"
    export AP_SYSID
else
    echo "AP_SYSID ($AP_SYSID) is invalid. Must either be set to 'ordinal', 'ip' or number between 1 and 255 inclusive"
    exit 1
fi
echo "AP_SYSID is set to $AP_SYSID"

# Create .parm file to set the SYSID
# This is appended onto the list of files used by the SITL
echo SYSID_THISMAV $AP_SYSID >> set_sysid.parm

if [ "${AP_VEHICLE}" = copter ]; then
    AP_MODEL=${AP_MODEL:-quad}
else
    AP_MODEL=${AP_MODEL:-plane}
fi

AP_PARAM_PATH=${AP_PARAM_PATH:-/src/ardupilot/Tools/autotest/default_params}

if [ "${AP_PARAM_FILES}" == "" ]; then
    # Param file not set, lookup defaults
    AP_PARAM_FILES=$(/home/root/lookup_parameter_files.py ${AP_VEHICLE} ${AP_MODEL} ${AP_PARAM_PATH}/../ )
fi

if [ ! -z "$AP_DISTRIBUTE" ]; then
    # Use SYSID to offset start position on 16x16 grid
    AP_OFFSET_X=$(( AP_SYSID / 16 ))
    AP_OFFSET_Y=$(( AP_SYSID % 16 ))
fi

exec /src/ardupilot/build/sitl/bin/ardu${AP_VEHICLE} \
    --model=${AP_MODEL} \
    --home=$(/home/root/offset_location.py ${AP_HOME} ${AP_OFFSET_X} ${AP_OFFSET_Y}) \
    --defaults=${AP_PARAM_FILES},$(pwd)/set_sysid.parm