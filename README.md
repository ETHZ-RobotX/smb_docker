# Using Docker for the SuperMegaBot Software

## Installation
1. Install Docker by following [the official website](https://docs.docker.com/get-docker/)

2. (Required if you want to run GUI application with VNC) Install Real VNC Viewer by following [the official website](https://www.realvnc.com/en/connect/download/viewer)

3. Clone this repository to your local machine

## Running the Docker container

There are two ways to run the Docker container. Choosing which one to use depends on how you want to use the GUI application.

### Running the container with X11 forwarding enabled

> [!IMPORTANT]  
> It only works on Linux. If you are using Windows or Mac, please refer to the next section.

Run the following command to start the Docker container with X11 forwarding:

```bash
docker compose -f compose-x11.yaml up
```

If everything goes well, you should see instructions in the terminal on how to attach to the container. You should keep the `docker compose` running and open a new terminal to attach to the container with the following command:

```bash
docker exec -it smb_container_x11 zsh 
```

> [!NOTE]
> If you are using a different shell, you can replace `zsh` with `bash`, `tmux`, etc.

If you open a GUI application in the container, it should be displayed on your screen.

Once you are finished, you can stop the container by pressing `Ctrl+C` in the terminal where you ran `docker compose up`.

(Optional) You can remove the container by running the following command:

```bash
docker compose -f compose-x11.yaml down
```

### Running the container with VNC enabled
> [!NOTE]  
> This method works on all platforms.

Run the following command to start the Docker container with VNC:

```bash
docker compose up
```

You can attach to the container with the following command:

```bash
docker exec -it smb_container zsh
```

> [!NOTE]
> If you are using a different shell, you can replace `zsh` with `bash`, `tmux`, etc.

If you open a GUI application in the container, you can access it by connecting to `localhost:5901` with a VNC client. The password is `robotx`.

Once you are finished, you can stop the container by pressing `Ctrl+C` in the terminal where you ran `docker compose up`.

(Optional) You can remove the container by running the following command:

```bash
docker compose down
```

### Try a GUI application

The default catkin workspace is `/workspaces/rss_workspace`. 

You can try to run the smb gazebo simulation inside the container to see if the GUI application works. 

You can run the following command to start the simulation:

```bash
cd /workspaces/rss_workspace
catkin build smb_gazebo
source devel/setup.zsh
roslaunch smb_gazebo smb.launch
```

If everything goes well, you should see the Gazebo simulation running and the GUI in the respective VNC viewer or X11 forwarding.
