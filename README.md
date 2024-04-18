# Using Docker for Simulation

> To use the SMB Docker, basic knowledge of Docker is needed. Please check [the official website](https://docs.docker.com) to learn how to build, save, reconnect etc.

## Get started
### TL;DR
**Method 1**: [Open a GitHub repos in an isolated container volume](https://code.visualstudio.com/docs/devcontainers/containers#_quick-start-open-a-git-repository-or-github-pr-in-an-isolated-container-volume). You can do it by clicking [![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/ETHZ-RobotX/smb_docker/tree/feature/wip_devcontainer)

**Method 2**: [Open an existing folder in a dev container](https://code.visualstudio.com/docs/devcontainers/containers#_quick-start-open-an-existing-folder-in-a-container)

#### Clone repo & checkout branch & open in VScode

```bash
git clone git@github.com:ETHZ-RobotX/smb_docker.git smb_docker

cd smb_docker

git checkout feature/wip_devcontainer 

code .
```
#### Reopen workspace in dev container

Run the `Dev Containers: Reopen in Container` command from the Command Palette (`F1`) or quick actions Status bar item (the blue button at the bottom-left corner of VScode).

![quick action bar](images/quick_action_icon.png)




## Setting up Docker

### Linux
1. Install Docker by following [the official website](https://docs.docker.com/engine/install/)
2. Clone the [repo](https://github.com/ETHZ-RobotX/smb_docker/) into a directory on your host computer
3. Run the bash file to create the container

```bash
# Go the directory where you downloaded the repo to
cd <path/to/repo>

# Activate Container
./create_container.bash
```

This will automatically setup your system to later run the docker and download the pre-compiled image from dockerhub. Once downloaded, the script starts a container called `smb_container` that can be used to run the SMB software (see [reconnecting to the docker container](#reconnecting-to-the-docker-container)).


### Windows
1. Install Docker Desktop by using [the official website](https://docs.docker.com/desktop/windows/install/)
2. Install VcXsrv [here](https://sourceforge.net/projects/vcxsrv/)
3. Launch VcXsrv and put the settings as in the pictures
   ![setup 1](images/docker_setup_1.png)

   ![setup 2](images/docker_setup_2.png)

   ![setup 3](images/docker_setup_3.png)

4. Open the powershell and run

```bash
# Run docker
docker run -it --env="DISPLAY=host.docker.internal:0.0" --volume=smb_volume:/home/catkin_ws/src --net=host --name smb_container ethzrobotx/smb_docker bash
```

5. To exit the container type `exit` in the terminal

## Setup Visual Studio Code for use with Docker container

> Visual Studio Code is a powerful integrated development environment that even allows accessing code inside a Docker container.
> Usage of Visual Studio is not necessary.


1. Open Visual Studio Code and install the **dev - containers** extension.
2. Click on the extension on the bottom left corner and attach to the previously created container.
3. When the new window opens install the **C/C++** and **Python** extension from Microsoft inside the container. This is needed in order to get autocompletion.
4. The catkin workspace is located in /home/catkin_ws

## (Re-)connecting to the Docker container

Once you have setup the smb_container, you can create a terminal (bash shell) by running

```bash
docker exec -it smb_container bash
```

There is no need to run the script create_container.sh anymore. 

If you closed all running instances of bash in the `smb_container`, you might need to start it again by running

```bash
# start docker container
docker start smb_container

# create a terminal (bash) in the container:
docker exec -it smb_container bash
```

The latter command can be repeated multiple times to create several terminals in the same container.

## How to use the simulation in the Docker container

If you want to run the simulation you can follow the [how to run SMB software](https://ethz-robotx.github.io/SuperMegaBot/core-software/HowToRunSoftware.html) and run the commands given there in a terminal in the smb_container. I.e.

```bash
# create a terminal (bash) in the container:
docker exec -it smb_container bash
```

In the then so created terminal, run:

```bash
roslaunch smb_gazebo sim.launch
```
