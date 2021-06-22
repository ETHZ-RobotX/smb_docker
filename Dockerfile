# syntax=docker/dockerfile:1.0.0-experimental
FROM ros:noetic-robot

# Preliminary dependencies
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
RUN apt update 
RUN apt install -y apt-utils nano wget python3-catkin-tools python3-osrf-pycommon git python3-pip python3-vcstool python3-rosdep 

RUN rosdep update

# Create and setup Catkin workspace
RUN mkdir -p home/catkin_ws/src && \
    cd home/catkin_ws && \
    catkin init && \
    catkin config --extend /opt/ros/noetic && \
    catkin config --merge-devel && \
    catkin config -DCMAKE_BUILD_TYPE=Release

RUN cd home/catkin_ws/src

# RUN vcs import --recursive --input https://raw.githubusercontent.com/ETHZ-RobotX/SuperMegaBot/master/smb.repos?token=AIDKBDUZ6H5XAIPHLIJWSFLA27EKY .
# 
# RUN rosdep install --from-paths . --ignore-src --os=ubuntu:focal -r -y
# 
# RUN apt-install -y ros-noetic-gazebo-plugins
#     
# 
# 
# # Build and source
# RUN cd home/catkin_ws/ && \
#     catkin build smb_gazebo
#     
# RUN echo "source /home/catkin_ws/devel/setup.bash" >> ~/.bashrc
# 
# # Quick fix for Gazebo (black screen issue - not finding models)
# RUN mkdir ~/.gazebo && mkdir ~/.gazebo/models && \
#     cd ~/.gazebo && git clone https://github.com/osrf/gazebo_models.git && \
#     mv gazebo_models/* models/ && rm -r gazebo_models

WORKDIR /home/catkin_ws
ENTRYPOINT [ "/ros_entrypoint.sh" ]
CMD ["bash"]
