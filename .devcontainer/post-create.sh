#!/bin/bash
set -e

ROOT=$(dirname "$(dirname "$(readlink -f $0)")")

# Setup aliases
echo "alias wssetup='source ${ROOT}/devel/setup.bash'" >> ~/.bashrc
echo "alias wssetup='source ${ROOT}/devel/setup.zsh'" >> ~/.zshrc

# make folder `src` if not exists
if [ ! -d "${ROOT}/src" ]; then
    mkdir -p "${ROOT}/src"
fi

# Clone the repository
vcs import --input "${SMB_RAW_REPO_URL}/smb.repos" --recursive --skip-existing "${ROOT}/src"

# setup catkin workspace
catkin init --workspace "${ROOT}" 
catkin config --workspace "${ROOT}" --extend /opt/ros/noetic -DCMAKE_BUILD_TYPE=Release
