MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

all: clover2 ardupilot_ar iris

base:
	$(MAKE) -C base

clover2: base
	docker build -t starling-sim-clover2 $(MAKEFILE_DIR)/vehicles/clover2

iris: base
	docker build -t starling-sim-iris $(MAKEFILE_DIR)/vehicles/iris

.PHONY: all base ardupilot_ar clover2 iris
