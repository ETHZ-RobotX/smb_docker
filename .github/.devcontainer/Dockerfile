# syntax=docker/dockerfile:1

###########################################################################
########### This is the devcontainer base image for SuperMegaBot(SMB)    ##
########### It is built and pushed to Github Container Registry by CI    ##
###########################################################################

ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    x11-apps \
    usbutils \
    && rm -rf /var/lib/apt/lists/*

ARG VNC_RESOLUTION
ENV VNC_RESOLUTION=$VNC_RESOLUTION

