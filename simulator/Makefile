MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

all: clover2 ardupilot_ar iris gazebo

base:
	$(MAKE) -C base

ardupilot_ar:
	$(MAKE) -C ardupilot_ar

clover2: base
	docker build -t starling-sim-clover2 $(MAKEFILE_DIR)/vehicles/clover2

iris: base
	docker build -t starling-sim-iris $(MAKEFILE_DIR)/vehicles/iris

gazebo: base
	docker build -t starling-sim $(MAKEFILE_DIR)/vehicles

.PHONY: all base gazebo ardupilot_ar clover2 iris
