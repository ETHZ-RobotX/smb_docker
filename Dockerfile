FROM osrf/ros:noetic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
    
    
RUN apt update
RUN apt install -y python3-catkin-tools python3-pip python3-vcstool git software-properties-common wget vim nano curl

RUN rosdep update

RUN mkdir -p /home/catkin_ws/src && \
    cd home/catkin_ws && \
    catkin init && \
    catkin config --extend /opt/ros/noetic -DCMAKE_BUILD_TYPE=Release && \
    cd src && \
    vcs import --recursive --input https://raw.githubusercontent.com/ETHZ-RobotX/smb_dev/devel/smb.repos?token=GHSAT0AAAAAACBD7S6VIUUOPFPDHDX2YXFOZDQ36YQ . && \
    vcs import --recursive --input https://raw.githubusercontent.com/ETHZ-RobotX/smb_dev/devel/smb_hw.repos?token=GHSAT0AAAAAACBD7S6UBN7ZGK5H6HEEBTQSZDQ37WA . && \
    rosdep install --from-paths . --ignore-src --os=ubuntu:focal -r -y && \
    pip install --upgrade pip && \
    apt purge pip && \
    echo 'alias pip=/root/.local/bin/pip3' >> /home/.bash_aliases && \
    pip install --ignore-installed pyyaml
    
RUN pip install open3d==0.15.2
    
RUN apt install -y ca-certificates gpg wget

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt update

RUN rm /usr/share/keyrings/kitware-archive-keyring.gpg && \
    apt install -y kitware-archive-keyring cmake libgoogle-glog-dev libglfw3 libglfw3-dev ros-noetic-jsk-rviz-plugins liblua5.2-dev && \
    curl https://raw.githubusercontent.com/isl-org/Open3D/master/util/install_deps_ubuntu.sh | sudo bash -s -- assume-yes
    
RUN cd /home/catkin_ws && \
    catkin build smb_gazebo smb_path_planner smb_slam open3d_slam_ros

RUN mkdir /home/catkin_ws/src/.vscode   
ADD ./.vscode/* /home/catkin_ws/src/.vscode
WORKDIR /home/catkin_ws/src
