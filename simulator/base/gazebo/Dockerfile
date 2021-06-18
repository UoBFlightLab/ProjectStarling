# Setup common base for simulator images
FROM ros:foxy-ros-base-focal

# Overwrite existing entrypoint script to allow additional sources from /ros.env and /ros.env.d
RUN touch /ros.env
RUN mkdir /ros.env.d
COPY ros_entrypoint.sh /

###
# Steps from gazebo:gzserver11 Dockerfile
###

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743

# setup sources.list
RUN . /etc/os-release \
    && echo "deb http://packages.osrfoundation.org/gazebo/$ID-stable `lsb_release -sc` main" > /etc/apt/sources.list.d/gazebo-latest.list

# install gazebo packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    gazebo11 \
    && rm -rf /var/lib/apt/lists/*

# setup environment
# Expose default gzserver port
EXPOSE 11345

###
# End of gazebo:gzserver11 steps
###

# Add gazebo environemnt setup to /ros.env
RUN echo "source /usr/share/gazebo/setup.sh" >> /ros.env

# Install gazebo_ros and xacro
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      ros-foxy-gazebo-ros \
      ros-foxy-xacro \
    && rm -rf /var/lib/apt/lists/*

# Install gzweb dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      build-essential \
      cmake \
      curl \
      git \
      imagemagick \
      libboost-dev \
      libjansson-dev \
      libtinyxml-dev \
      xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# Install node
# Use bash shell for this next bit...
SHELL [ "/usr/bin/bash", "-c" ]
RUN source /root/.nvm/nvm.sh && nvm install 10

# Fetch gzweb
ENV GZWEB_WS /root/gzweb
#RUN git clone -b gzweb_1.4.1 https://github.com/osrf/gzweb ${GZWEB_WS}
# Patched version
#RUN git clone -b gzweb_1.4.0-gazebo11 https://github.com/eurogroep/gzweb.git ${GZWEB_WS}
# Additionally patched version
RUN git clone -b gzweb_1.4.0-gazebo11 https://github.com/rob-clarke/gzweb.git ${GZWEB_WS}

# Build gzweb (default model generation)
RUN source /ros.env \
    && source /root/.nvm/nvm.sh \
    && cd ${GZWEB_WS} && npm run deploy --- -m

# Setup ports
# Main webserver port
EXPOSE 8080
# Websocket for gzweb data
EXPOSE 7681

# Add launch files
COPY gzweb.launch.xml /ros_ws/launch/
COPY gzweb_entrypoint.sh /

# Add URDF conversion tools
COPY tools /ros_ws/tools

# Add custom ROS DDS configuration (force UDP always) 
COPY fastrtps_profiles.xml /ros_ws/
ENV FASTRTPS_DEFAULT_PROFILES_FILE /ros_ws/fastrtps_profiles.xml

# Need to wait until models are installed before running the deploy step
CMD [ "gzweb_entrypoint.sh" ]
