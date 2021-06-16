FROM uobflightlabstarling/starling-sim-clover2 as clover

FROM uobflightlabstarling/starling-sim-iris as iris

# Add a new FROM line for each new vehicle

FROM starling-sim-base-px4 as base
COPY --from=clover /ros_ws /ros_ws
COPY --from=iris /ros_ws /ros_ws
# Add a new COPY line for each new vehicle

COPY launch.xml /ros_ws/launch/

# Add any unique environment variables required for each new vehicle
ENV GAZEBO_MODEL_PATH /ros_ws/models:${GAZEBO_MODEL_PATH}
ENV PX4_SITL_PORT 4560
ENV PX4_INSTANCE 0

# Add any unique commands required for each new vehicle
RUN echo "source /ros_ws/install/setup.bash" >> /ros.env
RUN echo 'export PX4_SITL_PORT=$((PX4_SITL_PORT + PX4_INSTANCE))' >> /ros.env

WORKDIR /ros_ws

ENV GAZEBO_VEHICLE="gazebo"

CMD [ "/bin/bash", "-c", "ros2 launch launch/launch.xml ${GAZEBO_VEHICLE}:=true" ]