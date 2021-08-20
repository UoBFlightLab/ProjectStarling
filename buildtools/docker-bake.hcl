variable "BAKE_VERSION" {
    default = "latest"
}

variable "BAKE_REGISTRY" {
    default = ""
}

variable "BAKE_RELEASENAME" {
    default = ""
}

variable "BAKE_CACHEFROM_REGISTRY" {
    default = ""
}

variable "BAKE_CACHETO_REGISTRY" {
    default = ""
}

variable "BAKE_CACHEFROM_NAME" {
    default = ""
}

variable "BAKE_CACHETO_NAME" {
    default = ""
}

/*
 * Groups for target ordering
 */
group "stage1" {
    targets = ["system", "simulator"]
}

group "stage2" {
    targets = ["simulator-px4", "starling-clover", "example_python_controller"]    
}

group "stage3" {
    targets = ["starling-sim-iris"]
}

/*
 * System targets
 */
group "system" {
    targets = ["starling-ui", "starling-controller-base", "starling-mavros"]
}

target "starling-ui" {
    context = "system/ui"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-ui:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-ui:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-ui:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-ui:${BAKE_CACHEFROM_NAME}" : "" ]
}

target "starling-controller-base" {
    context = "system/controller-base"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-controller-base:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-controller-base:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64", "linux/arm64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-controller-base:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-controller-base:${BAKE_CACHEFROM_NAME}" : "" ]
}

target "starling-mavros" {
    context = "system/mavros"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-mavros:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-mavros:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64", "linux/arm64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-mavros:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-mavros:${BAKE_CACHEFROM_NAME}" : "" ]
}


/* 
 * Simulator targets
 */
// Build this target before simulator-px4
group "simulator" {
    targets = [
        "starling-sim-base-core"
        ]
}

target "starling-sim-base-core" {
    context = "simulator/base/core"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-base-core:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-base-core:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-base-core:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-base-core:${BAKE_CACHEFROM_NAME}" : "" ]
}

group "simulator-px4" {
    targets = [
        "starling-sim-base-px4",
        "starling-sim-px4-sitl"
        ]
}

// This target depends on starling-sim-base-core
target "starling-sim-base-px4" {
    context = "simulator/base/px4"
    args = { 
        "VERSION": "${BAKE_VERSION}",
        "REGISTRY": "${BAKE_REGISTRY}"
        }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-base-px4:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-base-px4:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-base-px4:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-base-px4:${BAKE_CACHEFROM_NAME}" : "" ]
}

target "starling-sim-px4-sitl" {
    context = "simulator/base/px4"
    dockerfile = "sitl.Dockerfile"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-px4-sitl:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-px4-sitl:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-px4-sitl:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-px4-sitl:${BAKE_CACHEFROM_NAME}" : "" ]
}

/*
 * Controller targets
 */
// This target depends on starling-controller-base
target "example_python_controller" {
    context = "controllers/example_controller_python"
    args = { 
        "VERSION": "${BAKE_VERSION}",
        "REGISTRY": "${BAKE_REGISTRY}"
        }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/example_controller_python:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/example_controller_python:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64", "linux/arm64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/example_controller_python:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/example_controller_python:${BAKE_CACHEFROM_NAME}" : "" ]
}

/*
 * Vehicle targets
 */
// This target depends on starling-sim-base-px4
target "starling-sim-iris" {
    context = "simulator/vehicles/iris"
    args = { 
        "VERSION": "${BAKE_VERSION}",
        "REGISTRY": "${BAKE_REGISTRY}"
        }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-iris:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-iris:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-iris:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-iris:${BAKE_CACHEFROM_NAME}" : "" ]
}

// This target depends on starling-controller-base
target "starling-clover" {
    context = "system/drones/clover
    args = { 
        "VERSION": "${BAKE_VERSION}",
        "REGISTRY": "${BAKE_REGISTRY}"
        }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-clover:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-clover:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/arm64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-clover:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-clover:${BAKE_CACHEFROM_NAME}" : "" ]
}