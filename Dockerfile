FROM osrf/ros:noetic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
    
    
RUN apt update
RUN apt install -y python3-catkin-tools python3-pip python3-vcstool git software-properties-common wget vim nano 

RUN add-apt-repository -y ppa:roehling/open3d  && \
    apt install -y libopen3d-dev


RUN rosdep update


RUN mkdir -p /home/catkin_ws/src && \
    cd home/catkin_ws && \
    catkin init && \
    catkin config --extend /opt/ros/noetic -DCMAKE_BUILD_TYPE=Release && \
    cd src && \
    vcs import --recursive --input https://raw.githubusercontent.com/ETHZ-RobotX/SuperMegaBot/master/smb.repos && \
    vcs import --recursive --input https://raw.githubusercontent.com/ETHZ-RobotX/SuperMegaBot/master/smb_hw.repos && \
    rosdep install --from-paths . --ignore-src --os=ubuntu:focal -r -y && \
    catkin build smb_gazebo smb_path_planner smb_slam

RUN mkdir /home/catkin_ws/src/.vscode   
ADD ./.vscode/* /home/catkin_ws/src/.vscode
WORKDIR /home/catkin_ws/src
