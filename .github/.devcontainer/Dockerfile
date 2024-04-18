# syntax=docker/dockerfile:1

ARG OVERLAY_WS=/opt/ros/overlay_ws

# multi-stage build for caching
FROM osrf/ros:noetic-desktop-full AS cacher

ARG OVERLAY_WS
ARG SMB_RAW_REPO_URL=https://raw.githubusercontent.com/ETHZ-RobotX/SuperMegaBot/master

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
    python3-vcstool \
    git

WORKDIR ${OVERLAY_WS}/src
RUN vcs import --recursive --input ${SMB_RAW_REPO_URL}/smb.repos && \
    vcs import --recursive --input ${SMB_RAW_REPO_URL}/smb_hw.repos

WORKDIR /opt
RUN mkdir -p /tmp/opt && \
    find ./ -name "package.xml" | \
    xargs cp --parents -t /tmp/opt && \
    find ./ -name "requirements.txt" | \
    xargs cp --parents -t /tmp/opt || true && \
    find ./ -name "CATKIN_IGNORE" | \
    xargs cp --parents -t /tmp/opt || true

FROM osrf/ros:noetic-desktop-full AS builder

ARG DEBIAN_FRONTEND=noninteractive
LABEL org.opencontainers.image.source="https://github.com/ETHZ-RobotX/smb_docker"
LABEL org.opencontainers.image.description="Base development environment for the SuperMegaBot (SMB)"

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common 

RUN add-apt-repository -y ppa:roehling/open3d && apt-get update

RUN apt-get install -y --no-install-recommends \
    python3-catkin-tools \
    python3-pip \
    python3-vcstool \
    git \
    wget \
    vim \
    nano \
    libopen3d-dev

RUN rosdep update

# Install SMB dependencies
ARG OVERLAY_WS
WORKDIR $OVERLAY_WS
COPY --from=cacher /tmp/$OVERLAY_WS/src ./src
RUN rosdep install --from-paths src --ignore-src --os=ubuntu:focal -r -y

RUN mkdir -p /usr/share/yolo/models && \
    cd /usr/share/yolo/models && \
    wget https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5s6.pt https://github.com/ultralytics/yolov5/releases/download/v6.1/yolov5m6.pt

# RUN python3 -m pip install -r src/object_detection/requirements.txt

# # Build SMB packages
# COPY --from=cacher $OVERLAY_WS/src ./src
# RUN catkin init && \
#     catkin config --extend /opt/ros/noetic -DCMAKE_BUILD_TYPE=Release && \
#     catkin build --no-status \
#     smb_gazebo \
#     smb_path_planner \
#     smb_slam

# RUN catkin build --no-status object_detection

# # RUN catkin build --no-status smb_msf_graph

