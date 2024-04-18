#!/bin/bash
set -e

ROOT=$(dirname "$(dirname "$(readlink -f $0)")")
# Clone the repository
vcs import --input "${SMB_RAW_REPO_URL}/smb.repos" --recursive --skip-existing "${ROOT}/src"

# setup catkin workspace
catkin init --workspace "${ROOT}/src" 
catkin config --workspace "${ROOT}/src" --extend /opt/ros/noetic -DCMAKE_BUILD_TYPE=Release
