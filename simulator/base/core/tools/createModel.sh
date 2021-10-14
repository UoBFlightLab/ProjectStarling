#!/bin/bash

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ $# -lt 2 ]; then
    echo "Usage: $0 output_dir [extra_dir [extra_dir...]] -- source.urdf.xacro [xacro_arg [xacro_arg...]]"
    exit 1
fi

OUTPUT_DIR=$1
shift

EXTRA_DIRS=
while [ ! $1 = "--" ]; do
    EXTRA_DIRS="$1 ${EXTRA_DIRS}"
    shift
    done;

shift
SOURCE_URDF=$1
shift
XACRO_ARGS="$@"

MODEL_NAME="$(basename ${SOURCE_URDF})"

# Make output folder
mkdir -p ${OUTPUT_DIR}

# Generate model.config file
cat > ${OUTPUT_DIR}/model.config <<-EOF
<?xml version="1.0"?>
<model>
  <name>${MODEL_NAME}</name>
  <version>1.0</version>
  <sdf version='1.4'>${MODEL_NAME}.sdf</sdf>

  <author>
   <name>Starling createModel.sh</name>
   <email>N/A</email>
  </author>

  <description>
    This file has been autogenerated from ${MODEL_NAME}
  </description>
</model>
EOF

# Generate SDF file
${SOURCE_DIR}/convertURDF.sh ${SOURCE_URDF} ${XACRO_ARGS} > ${OUTPUT_DIR}/${MODEL_NAME}.sdf

# Copy over extra dirs
for dir in ${EXTRA_DIRS}; do
    EXTRA_DIR_NAME=$(basename ${dir})
    cp -r ${dir} ${OUTPUT_DIR}/${EXTRA_DIR_NAME}
    done