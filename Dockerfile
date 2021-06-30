FROM osrf/ros:noetic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
    
    
RUN apt update
RUN apt install -y apt-utils nano wget python3-catkin-tools python3-osrf-pycommon git python3-pip python3-vcstools python3-rosdep 

RUN rosdep update


RUN mkdir -p home/catkin_ws/src && \
    cd home/catkin_ws && \
    catkin init && \
    catkin config --extend /opt/ros/noetic && \
    catkin config --merge-devel && \
    catkin config -DCMAKE_BUILD_TYPE=Release
    
RUN cd home/catkin_ws/src

WORKDIR /home/catkin_ws
