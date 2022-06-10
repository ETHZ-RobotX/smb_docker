# Using Docker for Simulation
{:.no_toc} 

Documentation of the SuperMegaBot (SMB) Docker for the ETHZ Robotic Summer School.

> To use the SMB Docker, basic knowledge of Docker is needed. Please check [the official website](https://docs.docker.com) to learn how to build, save, reconnect etc. 

{: .smb-mention }


* Table of contents
{:toc}


# Setting up the Docker

## Linux
1. Install the Docker by using [the official website](https://docs.docker.com/engine/install/ubuntu/)
2. Clone the repo into a directory in your host computer
3. Run the bash file to create the container
```bash
# Go the directory that you download the repo
cd <path/to/repo>

# Activate Container
create_container.bash
```
5. To exit the container type `exit` in the terminal

## Windows
1. Install Docker Desktop by using [the official website](https://docs.docker.com/desktop/windows/install/)
2. Install VcXsrv [here](https://sourceforge.net/projects/vcxsrv/)
3. Launch VcXsrv and put the settings as in the pictures
   ![setup 1](Images/setup_1.png)
   ![setup 2](Images/setup_2.png)
   ![setup 3](Images/setup_3.png)
4. Open the powershell and run
   ```bash
   # Get your ip address
   ipconfig

   # Run docker
   docker run -it --env="DISPLAY=<YOUR_IP_ADDR>:0.0" --volume=smb_volume:/home/catkin_ws/src --net=host --name smb_container ethzrobotx/smb_docker bash
   ```
5. To exit the container type `exit` in the terminal

## MacOS
1. Install docker `brew cask install docker`
2. Install XQuartz `brew cask install xquart`
3. Open XQuartz using `open -a XQuartz` and in the **Security** tab check **Allow connections from network clients**
4. Set IP with `IP=<YOUR_IP_ADDR>` and execute `xhost + $IP`
5. To start the container
   ```bash
   # Run docker
   docker run -it --env="DISPLAY=<YOUR_IP_ADDR>:0.0" --volume=/tmp/.X11-unix:/tmp/.X11-unix --volume=smb_volume:/home/catkin_ws/src --net=host --name smb_container ethzrobotx/smb_docker bash
   ```
6. To exit the container type `exit` in the terminal
# Setup Visual Studio Code

1. Open Visual Studio Code and install the **Remote - Containers** extension.
2. Click on the extension on the sidebar and connect to the previously created container.
3. When the new window opens install the **C/C++** and **Python** extension from Microsoft inside the container. This is needed in order to get autocompletion.

# Reconnecting the Docker Container

```bash
# Start the Docker Container
sudo docker container start smb_container

# Attach the Docker Container
sudo docker container attach smb_container
```

# How to use simulation the Docker

If you want to launch several sessions connected to the same container from multiple terminals: 

```bash
# Launch new session to the same container
docker exec -it smb_container bash
```

If you want to run the simulation you can follow the [how to run SMB software](https://ethz-robotx.github.io/SuperMegaBot/core-software/HowToRunSoftware.html).

> You can run launch_gazebo_gui:=false if you do not need to see the simulation environment. Yet, you can recognize the obstacles in the Rviz visualization tool thanks to the modeled sensor behavior.