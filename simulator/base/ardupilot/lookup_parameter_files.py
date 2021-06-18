#!/usr/bin/env python

# Get the parameter files used by a vehicle - model combination
# Usage:
#  lookup_parameter_files.py VEHICLE FRAME AUTOTEST_PATH
# e.g.:
#  lookup_parameter_files.py copter quad /src/ardupilot/Tools/autotest

import os

os.sys.path.append("/src/ardupilot/Tools/autotest")

import pysim.vehicleinfo as vehicleinfo

vinfo = vehicleinfo.VehicleInfo()

vehicle = os.sys.argv[1]
frame = os.sys.argv[2]
autotest_path = os.sys.argv[3]

if vehicle == "copter":
    vehicle = "ArduCopter"
elif vehicle == "plane":
    vehicle = "ArduPlane"

class Duck:
    def __init__(self):
        self.model = None
        self.build_target = None

opts = vinfo.options_for_frame(frame,vehicle,Duck())

if "default_params_filename" not in opts:
    exit(1)

paths = opts["default_params_filename"]

if not isinstance(paths, list):
    paths = [paths]

print(",".join([ autotest_path+file for file in paths]))
