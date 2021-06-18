MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BAKE_SCRIPT:=$(MAKEFILE_DIR)/../../buildtools/docker-bake.hcl
BUILDX_HOST_PLATFORM:=$(shell docker buildx inspect default | sed -nE 's/^Platforms: ([^,]*),.*$$/\1/p')
BAKE:=cd ../.. && docker buildx bake --builder default --load --set *.platform=$(BUILDX_HOST_PLATFORM) -f $(BAKE_SCRIPT)

all: gazebo px4-gazebo px4-sitl ardupilot

ardupilot: arduplane arducopter

arduplane:
	$(BAKE) starling-sim-arduplane

arducopter:
	$(BAKE) starling-sim-arducopter

gazebo:
	$(BAKE) starling-sim-base-gazebo

px4-gazebo: gazebo
	$(BAKE) starling-sim-px4-gazebo

px4-sitl:
	$(BAKE) starling-sim-px4-sitl

.PHONY: all gazebo px4-gazebo px4-sitl arducopter ardupilot arduplane