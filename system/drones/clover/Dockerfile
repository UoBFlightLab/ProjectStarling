ARG VERSION=latest
ARG REGISTRY
FROM ${REGISTRY}uobflightlabstarling/starling-controller-base:${VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libboost-system-dev \
        git \
        python3-pip \
        geographiclib-tools\
        libgeographic-dev\
        libgeographic19\
    && rm -rf /var/lib/apt/lists/*

## Install Raspberry Pi GPIO drivers
RUN pip3 install RPi.GPIO

ARG START_HERE=blah
## My own files for clover core libraries
RUN git clone --recursive https://github.com/UoBFlightLab/clover_ros2_pkgs.git \
        /ros_ws/src/clover_ros2_pkgs

WORKDIR /ros_ws

RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
    && . install/setup.sh \
    && bash src/mavros/mavros/scripts/install_geographiclib_datasets.sh \
    && ln -s /usr/share/cmake/geographiclib/FindGeographicLib.cmake /usr/share/cmake-3.16/Modules

RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
    && . install/setup.sh \
    && export CMAKE_PREFIX_PATH=$AMENT_PREFIX_PATH:$CMAKE_PREFIX_PATH \
    && cd /ros_ws \
    && colcon build --packages-select \
        # mavros_msgs \
        led_msgs \
        ws281x \
        vl53l1x \
        clover_ros2 \
    && rm -r build

COPY starling-clover.launch.xml .
COPY run.sh .

CMD ["./run.sh"]