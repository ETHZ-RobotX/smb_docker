#!/bin/bash
set -e

entrypoint() {
    # Start the VNC server if X11 forwarding is not enabled
    echo -e "\n\n"
    if [ -z "$USE_X11_FORWARDING" ] || [ "$USE_X11_FORWARDING" -eq 0 ]; then 
        # Use VNC by default
        echo "Info: USE_X11_FORWARDING is not set. Use VNC to access GUI applications."
        echo "Info: Open \`localhost:5901\` in your VNC client to access the desktop."
        echo "Info: or open \`localhost:6080\` in your web browser to access the desktop."
        echo "Info: To use X11 forwarding, run \`docker compose -f compose-x11.yaml up\`."

        echo "Starting VNC server..."
        # change the resolution of the VNC server
        sudo sed -i "s@\(export VNC_RESOLUTION=\)\".*\"@\1\"$VNC_RESOLUTION\"@" /usr/local/share/desktop-init.sh
        # start the VNC server
        bash /usr/local/share/desktop-init.sh

        echo "VNC server started."
        echo "Keep this terminal running and run \`docker exec -it smb_container zsh\` in another terminal to enter the container."
    else
        # Use x11 forwarding
        echo "Info: USE_X11_FORWARDING is set. GUI applications will be displayed on the host."
        echo "Keep this terminal running and run \`docker exec -it smb_container_x11 zsh\` in another terminal to enter the container."
    fi

    # create a named pipe if it does not exist
    if [ ! -p /tmp/keep-container-running ]; then
        mkfifo /tmp/keep-container-running
    fi
    # read from named pipe to keep the container running
    read < /tmp/keep-container-running
}

# trap SIGTERM and exit the script; docker stop sends SIGTERM
trap "exit 0" SIGTERM

USERNAME=$(whoami)

echo "Post-create command started"
echo "WORKSPACE_DIR: ${WORKSPACE_DIR}"
echo "SMB_RAW_REPO_FILE_URL: ${SMB_RAW_REPO_FILE_URL}"
echo "USE_X11_FORWARDING: ${USE_X11_FORWARDING:-OFF}"
echo "DISPLAY: ${DISPLAY}"
echo "VNC_RESOLUTION: ${VNC_RESOLUTION}"
echo "USER: ${USERNAME}"

# Check if the container is initialized by checking if a checkpoint file exists
if [ -f "/.initialized" ]; then
    echo "Workspace is already initialized. Skipping post-create command."
    entrypoint
fi

echo "Initializing workspace..."

# check if the workspace directory belongs to the user
if [ -d "${WORKSPACE_DIR}" ]; then
    if [ "$(stat -c %U ${WORKSPACE_DIR})" != "${USERNAME}" ]; then
        echo "Changing ownership of workspace directory to ${USERNAME}"
        sudo chown -R ${USERNAME}:${USERNAME} ${WORKSPACE_DIR}
        echo "Ownership changed successfully."
    fi
fi

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
echo "alias build-limit=\"catkin build --jobs 8 --mem-limit 70%\"" >> ~/.bashrc
echo "alias build-limit=\"catkin build --jobs 8 --mem-limit 70%\"" >> ~/.zshrc

# Make folder `src` if not exists
if [ ! -d "${ROOT}/src" ]; then
    mkdir -p "${ROOT}/src"
fi

# Clone the repository
echo "Cloning the repository..."
vcs import --input "${SMB_RAW_REPO_FILE_URL}" --recursive --skip-existing "${ROOT}/src"

# Setup catkin workspace
catkin init --workspace "${ROOT}" &> /dev/null

# Configure the workspace
catkin config --workspace "${ROOT}" \
              --extend /opt/ros/noetic \
              --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# save checkpoint
sudo touch "/.initialized"

echo -e "\n\n"
echo "Workspace initialized successfully."

entrypoint
              