# syntax=docker/dockerfile:1.0.0-experimental
FROM ros:melodic

# Preliminary dependencies
RUN apt update && \
    apt install -y git wget python-catkin-tools doxygen vim x11vnc xvfb \
    ros-melodic-octomap ros-melodic-octomap-msgs \
    ros-melodic-octomap-ros ros-melodic-rosserial ros-melodic-joy \
    ros-melodic-ompl ros-melodic-costmap-2d \
    ros-melodic-gazebo-plugins ros-melodic-velodyne-gazebo-plugins \
    ros-melodic-hector-gazebo-plugins \
    libpcap0.8-dev libeigen3-dev libopencv-dev libboost-dev ros-melodic-cmake-modules libssh2-1-dev \
    libglpk-dev python-wstool net-tools \
    liblapack-dev libblas-dev autotools-dev dh-autoreconf \
    libboost-all-dev python-setuptools cppcheck default-jre libgtest-dev \
    libglew-dev clang-format-3.9 python-git pylint python-termcolor \
    "ros-melodic-camera-info-manager*" protobuf-compiler protobuf-c-compiler \
    libssh2-1-dev libatlas3-base libnlopt-dev \
    "ros-melodic-tf2-*" python-pip python-autopep8 libreadline-dev ifstat \
    ntpdate sysstat libv4l-0 ros-melodic-gps-common \
    ros-melodic-rqt-gui-cpp ros-melodic-rviz ros-melodic-rqt-gui \
    ros-melodic-cv-bridge ros-melodic-filters qttools5-dev ros-melodic-pcl-ros \
    ros-melodic-tf-conversions ros-melodic-xacro \
    ros-melodic-robot-state-publisher \
    ros-melodic-nav-core ros-melodic-navfn ros-melodic-move-base \
    ros-melodic-teb-local-planner ros-melodic-pointcloud-to-laserscan \
    ros-melodic-robot-self-filter ros-melodic-dwa-local-planner \
    ros-melodic-velodyne-description ros-melodic-grid-map-visualization \
    libceres-dev && \
    rm -rf /var/lib/apt/lists/*

# (OPTIONAL) Install ccache for faster rebuilds
RUN apt update && \
    apt install -y ccache && \
    ccache --max-size=10G && \
    rm -rf /var/lib/apt/lists/*
ENV PATH="/usr/lib/ccache:${PATH}"

# Create and setup Catkin workspace
RUN mkdir -p home/catkin_ws/src && \
    cd home/catkin_ws && \
    catkin init && \
    catkin config --extend /opt/ros/melodic && \
    catkin config --merge-devel && \
    catkin config -DCMAKE_BUILD_TYPE=Release

# Allow SSH forwarding
RUN apt update && apt install -y openssh-client && \
    mkdir -p -m 0600 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts

# Install repos
RUN --mount=type=ssh cd home/catkin_ws/src/ && \
    git clone git@github.com:ETHZ-RobotX/SMB_dev.git && \
    wstool init && \
    wstool merge SMB_dev/smb2_0.rosinstall && \
    wstool up -j8

# Build and source
RUN cd home/catkin_ws/ && \
    catkin build smb_sim smb_path_planner \
    elevation_mapping elevation_mapping_demos \
    smb_confusor
RUN echo "source /home/catkin_ws/devel/setup.bash" >> ~/.bashrc

# Quick fix for Gazebo (black screen issue - not finding models)
RUN mkdir ~/.gazebo && mkdir ~/.gazebo/models && \
    cd ~/.gazebo && git clone https://github.com/osrf/gazebo_models.git && \
    mv gazebo_models/* models/ && rm -r gazebo_models

WORKDIR /home/catkin_ws
ENTRYPOINT [ "/ros_entrypoint.sh" ]
CMD ["bash"]