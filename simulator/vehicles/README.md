# Gazebo and Vehicles

The Dockerfile in this directory builds a gazebo instance with access to all drone models. Current supported drone models are:
- [clover2](clover2/)
- [iris](iris/)

The dockerfile automatically launches `launch.xml` with environment variable `GAZEBO_VEHICLE` set to `gazebo`. The same docker image can then be used to launch vehicles by setting `GAZEBO_VEHICLE` to:
- `clover2` to spawn a clover
- `iris` to spawn an iris

For Example
```bash
docker run starling-sim # will run gazebo by default
docker run -e GAZEBO_VEHICLE=iris starling-sim
docker run -e GAZEBO_VEHICLE=clover2 -e PX4_INSTANCE=1 starling-sim
```

To spawn multiple, you will also need to set `PX4_INSTANCE` to a different number.

Within the container, these all run:
```bash
ros2 launch launch/launch.xml ${GAZEBO_VEHICLE}:=true
```

> Note: Originally, it was hoped that the launch file could simply take one argument of `vehicle` with the vehicle name to avoid having to enumerate all vehicles within the launch file. 
> Unfortunately due to issues with ros2 xml launch file's eval command this could not be achieved (see: https://github.com/ros2/launch/issues/469#issuecomment-785951620). 
> An attempt was also made at producing a Python launch file, but this was unsuccessful. 