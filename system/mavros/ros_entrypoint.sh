#!/bin/bash
set -e

# unsetting ROS_DISTRO to silence ROS_DISTRO override warning
unset ROS_DISTRO
# setup ros1 environment
source "/opt/ros/$ROS1_DISTRO/setup.bash"

# unsetting ROS_DISTRO to silence ROS_DISTRO override warning
unset ROS_DISTRO
# setup ros2 environment
source "/opt/ros/$ROS2_DISTRO/setup.bash"

# Source the from-source ros1_bridge workspace
source "/bridge_ws/install/setup.bash"

# Source any extra nodes inside mavros container
source "/ros_ws/install/setup.bash"

# Source the mavros_setup for any user defined edits to the environment
source "/ros_ws/mavros_setup.sh"

exec "$@"
