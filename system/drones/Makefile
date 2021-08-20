MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

all: clover

clover-local:
	docker build -t starling-clover ${MAKEFILE_DIR}/clover

clover: 
	docker buildx build --push --build-arg START_HERE=$(shell date +%s) --platform linux/arm64,linux/amd64 --tag uobflightlabstarling/starling-clover:latest $(MAKEFILE_DIR)/clover 

.PHONY: clover-local clover

