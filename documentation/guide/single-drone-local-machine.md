# Single Drone Local Machine

Follow these instructions for quick and easy testing of controllers on a single drone on a single local machine. **Use in the following scenarios**:

1. Local development of single drone applications in simulation (gazebo)
2. Local development of offboard (drone control software on pc not on drone)
3. Local development of onboard (drone control software running on drone itself)
4. No requirement of imitating the real drone software/ communication architecture

**This is considered to be step 1 for the Starling development process.**
## Contents
[TOC]

## Starting the Drone and Simulator 

In the root directory, execute `make run` (or `docker-compose up`) in a terminal. This will start the following:

1. Gazebo simulation enviornment running 1 Iris quadcopter model 
2. A SITL (Software In The Loop) instance running the PX4 autopilot.
3. A Mavros node connected to the SITL instance 
4. A simple UI with a go and estop button. 

> **Note:** this might take a while on first run as downloads are required.

The User Interfaces are available in the following locations:

- Go to [`http://localhost:8080`](http://localhost:8080) in a browser to (hopefully) see the gazebo simulator.
- Go to [`http://localhost:3000/html/main.html`](http://localhost:3000/html/main.html) in a browser to see the starling user interface containing go/stop buttons.

> **Note:** All specified sites can be accessed from other machines by replacing `localhost` with your computer's IP address. (TODO: starling ui not yet functioning in this use case.)

> **Note:** Sometimes it might take a bit of time for the UIs to become available, give it a minute and refresh the page. With Gazebo you may accidentally be too zoomed in, or the grid may not show up. Use the mouse wheel to zoom in and out. The grid can be toggled on the left hand pane.  

## Offboard Control
There are two supported methods for offboard control of either the SITL or real drones.

1. Control drone directly via Mavlink, by Ground Control Station (GCS) or other Mavlink compatible method (e.g. Dronekit).
2. Control drone via ROS2 node

### 1. Connecting a Ground Control Station via Mavlink

If a mavros or sitl instance is running, there will be a GCS link on `udp://localhost:14553` (hopefully). This means that you can run a GCS such as QGroundControl or Mission Planner:

- Create a comms link to `localhost:14553` on UDP 
- The GCS should auto detect the drone(s) 
- You should be able to control and monitor any sitl drone through the standard mavlink interface. 

This is a quick an easy way to control the SITL instance via Mavlink.

### 2. Running Example ROS2 Offboard Controller node

An example offboard ROS2 controller can then be conncted to SITL by running the following in a separate terminal:

```bash
docker run -it --rm --network projectstarling_default uobflightlabstarling/example_controller_python
```
This will download and run the `example_controller_python` image from `uobflightlabstarling` on docker hub. `-it` opens an interactive terminal. `--rm` removes the container when completed. `--network` attaches the container to the default network created by `make run` or `docker-compose`. The default network name is `<foldername>_default`.

> **Note:** The controller may complain that it cannot find the drone. Double check that the name of the root folder matches the one passed to `--network`.

When run, the example will confirm in the terminal that it has connected and that it is waiting for mission start. To start the mission, press the green go button in the [starling user interface](http://localhost:3000/html/main.html) which will send a message over `/mission_start` topic. A confirmation message should appear in the terminal, and the drone will arm (drone propellors spinning up) and takeoff. It will fly in circles for 10 seconds before landing and disarming. 
## Onboard Control
{% include 'snippets/onboard-control.md' %}


## Controller Development on the Drone and Simulator 

## Troubleshooting/ FAQs