#!/usr/bin/env python

# Offset a position/heading tuple by a body frame x and y (m)
# Usage:
#  offset_location.py LAT,LNG,ALT,HDG OFFSET_X OFFSET_Y
# e.g.
#  offset_location.py 51.4235413,-2.6708488,50,250 5 5

import os, math

import pymap3d.ned as pm

[lat,lng,alt,hdg] = [ float(x) for x in os.sys.argv[1].split(",") ]
offset_x = float(os.sys.argv[2])
offset_y = float(os.sys.argv[3])

offset_n = offset_x * math.cos(math.radians(hdg)) - offset_y * math.sin(math.radians(hdg))
offset_e = offset_x * math.sin(math.radians(hdg)) + offset_y * math.cos(math.radians(hdg))

[lat,lng,alt] = pm.ned2geodetic(offset_n,offset_e,0,lat,lng,alt)

print(f"{lat},{lng},{alt},{hdg}")
