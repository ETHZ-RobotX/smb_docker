#!/bin/bash

# If not working, first do: sudo rm -rf /tmp/.docker.xauth
# It still not working, try running the script as root.

docker run -it \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --volume=smb_volume:/home/catkin_ws/src \
    --net=host \
    ethzrobotx:cv_notebook_light \
    bash

echo "Done."
