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
    targets = ["simulator-px4", "simulator-ardupilot", "controllers"]
}

group "stage3" {
    targets = ["starling-sim-iris", "starling-sim-iris-ap"]
}

/*
 * System targets
 */
group "system" {
    targets = ["rosbridge-suite", "starling-controller-base", "starling-mavros", "starling-vicon", "mavp2p"]
}

target "rosbridge-suite" {
    context = "system/rosbridge-suite"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/rosbridge-suite:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/rosbridge-suite:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/rosbridge-suite:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/rosbridge-suite:${BAKE_CACHEFROM_NAME}" : "" ]
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

target "mavp2p" {
    context = "system/mavp2p"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/mavp2p:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/mavp2p:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64", "linux/arm64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/mavp2p:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/mavp2p:${BAKE_CACHEFROM_NAME}" : "" ]
}

target "starling-vicon" {
    context = "system/vicon"
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-vicon:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-vicon:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64", "linux/arm64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-vicon:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-vicon:${BAKE_CACHEFROM_NAME}" : "" ]
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

group "simulator-ardupilot" {
    targets = [
        "starling-sim-ardupilot-copter",
        "starling-sim-ardupilot-plane",
        "starling-sim-ardupilot-gazebo"
    ]
}

target "starling-sim-ardupilot-copter" {
    context = "simulator/base/ardupilot"
    dockerfile = "sitl.Dockerfile"
    args = {
        "VEHICLE": "copter",
        "BRANCH": "ArduCopter-stable"
    }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-copter:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-copter:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-copter:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-copter:${BAKE_CACHEFROM_NAME}" : "" ]
}

target "starling-sim-ardupilot-plane" {
    context = "simulator/base/ardupilot"
    dockerfile = "sitl.Dockerfile"
    args = {
        "VEHICLE": "plane",
        "BRANCH": "ArduPlane-stable"
    }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-plane:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-plane:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-plane:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-plane:${BAKE_CACHEFROM_NAME}" : "" ]
}

target "starling-sim-ardupilot-gazebo" {
    context = "simulator/base/ardupilot"
    args = {
        "VERSION": "${BAKE_VERSION}",
        "REGISTRY": "${BAKE_REGISTRY}"
    }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-gazebo:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-gazebo:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-gazebo:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-ardupilot-gazebo:${BAKE_CACHEFROM_NAME}" : "" ]
}

/*
 * Controller targets
 */
// Build this target before simulator-px4
group "controllers" {
    targets = [
        "example_python_controller",
        ]
}
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

// This target depends on starling-sim-base-ardupilot
target "starling-sim-iris-ap" {
    context = "simulator/vehicles/iris-ap"
    args = {
        "VERSION": "${BAKE_VERSION}",
        "REGISTRY": "${BAKE_REGISTRY}"
        }
    tags = [
        "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-iris-ap:${BAKE_VERSION}",
        notequal("",BAKE_RELEASENAME) ? "${BAKE_REGISTRY}uobflightlabstarling/starling-sim-iris-ap:${BAKE_RELEASENAME}": "",
        ]
    platforms = ["linux/amd64"]
    cache-to = [ notequal("",BAKE_CACHETO_NAME) ? "${BAKE_CACHETO_REGISTRY}uobflightlabstarling/starling-sim-iris-ap:${BAKE_CACHETO_NAME}" : "" ]
    cache-from = [ notequal("",BAKE_CACHEFROM_NAME) ? "${BAKE_CACHEFROM_REGISTRY}uobflightlabstarling/starling-sim-iris-ap:${BAKE_CACHEFROM_NAME}" : "" ]
}
