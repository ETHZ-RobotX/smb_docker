export DISPLAY=:0
xhost +
docker run -ti --rm --name smb \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix  \
    -v $(pwd)/bags:/home/bags smb
