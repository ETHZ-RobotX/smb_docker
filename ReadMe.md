# Using Docker for Simulation
{:.no_toc} 

Documentation of the SuperMegaBot (SMB) Docker for the ETHZ Robotic Summer School.

> The docker image was tested on an Ubuntu PC with a Nvidia GPU. On other systems, the docker might not work as it is intended. In addition, the Docker image was written for only simulation purposes. In order to use the real robot, other settings for the image might be needed. 

> To use the SMB Docker, basic knowledge of Docker is needed. Please check [the official website](https://docs.docker.com) to learn how to build, save, reconnect etc. 

{: .smb-mention }


* Table of contents
{:toc}


# Setting up the Docker
1. Install the Docker by using [the official website](https://docs.docker.com/engine/install/ubuntu/)
2. Clone the repo into a directory in your host computer
3. Build the image

```bash
# Go the directory that you download the repo
cd <to_the_directory>

# Build the Image
sudo docker build -t smb_docker .
```

> Note that, by running the next command, you will delete the docker container shared directory, if you have already a docker container shared directory in the directory (that you will run the next command).

4. Run the bash file to activate container
```bash
# Activate Container
sudo ./run_image.bash
```


5. When the Docker terminal showed up, follow the [installation guide of SMB](https://ethz-robotx.github.io/SuperMegaBot/core-software/installation_core.html)

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

You can change the files inside catkin_ws in docker from the host pc. You should run the following terminal command every time you created a new file inside the catkin_ws in docker. You can access the files inside the catkin_ws in the docker from the *catkin_ws* directory inside the directory in that you run the bash file (Setting up the docker, step 4 ). 

```bash
# Give access right to the files from the host.
# Run it in the docker terminal 
chmod -R a+rwx /home/catkin_ws
```

If you want to run the simulation you can follow the [how to run SMB software](https://ethz-robotx.github.io/SuperMegaBot/core-software/HowToRunSoftware.html).

> You can run launch_gazebo_gui:=false if you do not need to see the simulation environment. Yet, you can recognize the obstacles in the Rviz visualization tool thanks to the modeled sensor behavior.