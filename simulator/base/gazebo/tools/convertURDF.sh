#!/bin/bash

tmpfile=$(mktemp /tmp/check-gazebo-xacro.urdf.XXXXXX)

xacro "$@" > $tmpfile

if [ $? -ne 0 ]; then
  # Print to stderr to keep stdout "clean"
  >&2 echo "Xacro processing failed"
  rm "$tmpfile"
  exit 1
fi

# Convert input to SDF and print to stdout
gz sdf -p "$tmpfile"

rm "$tmpfile"