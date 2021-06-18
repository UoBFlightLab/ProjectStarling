# Perform multistage build to avoid a pile of ardupilot deps
FROM ardupilot/ardupilot-dev-chibios as ardupilot_builder

ARG VEHICLE=copter
ARG BRANCH=ArduCopter-stable

# Install PyGeodesy
RUN python -m pip install --no-cache-dir pymap3d

# Fetch ArduPilot
RUN git clone --recurse-submodules --depth 1 --shallow-submodules -j4 \
    -b ${BRANCH} https://github.com/ArduPilot/ardupilot /src/ardupilot

# Build the SITL
WORKDIR /src/ardupilot
RUN ./waf configure && ./waf ${VEHICLE}

WORKDIR /home/root
COPY entrypoint.sh \
     offset_location.py \
     lookup_parameter_files.py \
    /home/root/

# The VEHICLE environment variable should not be overridden as
#  the build will not exist for it
ENV AP_VEHICLE ${VEHICLE}
ENV AP_SYSID 1
ENV AP_SYSID_BASE 1
ENV AP_PARAM_PATH ""
ENV AP_PARAM_FILES ""
ENV AP_HOME 51.4235413,-2.6708488,50,250
ENV AP_OFFSET_X 0
ENV AP_OFFSET_Y 0

ENTRYPOINT [ "/home/root/entrypoint.sh" ]
