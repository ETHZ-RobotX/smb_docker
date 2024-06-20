#!/bin/bash
set -e

print_instructions() {
    echo "Keep it terminal running and run \`docker exec -it smb_container zsh\` in another terminal to enter the container."
}

# Check if the container is initialized by checking if a checkpoint file exists
if [ -f "/.initialized" ]; then
    echo "Workspace is already initialized. Skipping post-create command."
    print_instructions
    sleep infinity
fi

echo "Initializing workspace..."

sudo chown -R ${USER}:${USER} ${WORKSPACE_DIR}

ROOT="${WORKSPACE_DIR}"

# Store command history in the workspace which is persistent across rebuilds
echo "export HISTFILE=${ROOT}/.zsh_history" >> ~/.zshrc

# Setup the ROS environment in shells
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc

# Setup fzf
echo "eval \"\$(fzf --bash)\"" >> ~/.bashrc
echo "source <(fzf --zsh)" >> ~/.zshrc

# Setup alias
echo "alias wssetup=\"source ${ROOT}/devel/setup.bash\"" >> ~/.bashrc
echo "alias wssetup=\"source ${ROOT}/devel/setup.zsh\"" >> ~/.zshrc

# Make folder `src` if not exists
if [ ! -d "${ROOT}/src" ]; then
    mkdir -p "${ROOT}/src"
fi

# Clone the repository
vcs import --input "${SMB_RAW_REPO_FILE_URL}" --recursive --skip-existing "${ROOT}/src"

# Setup catkin workspace
catkin init --workspace "${ROOT}" 

# Configure the workspace
catkin config --workspace "${ROOT}" \
              --extend /opt/ros/noetic \
              --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# save checkpoint
sudo touch "/.initialized"
echo -e "\n\n"
echo "Workspace initialized successfully."
print_instructions
sleep infinity
              