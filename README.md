# SMB_docker

**Steps:**
* **Build docker container (~15mn):** `DOCKER_BUILDKIT=1 docker build --ssh default -t smb .`
* **Run docker container:** `bash run.sh`
* **Open new terminal window from running container:** `bash open_container_terminal.sh`

**State estimation:**
* **Terminal 1 (master):** `roscore`
* **Terminal 2 (confusor):** `rosrun smb_confusor smb_confusor`
* **Terminal 3 (rviz):** `rosrun rviz rviz -d src/smb_confusor/smb_estimator.rviz`
* **Terminal 4 (rosbag):** `rosparam set use_sim_time true && rosbag play ../bags/270619_smb_se_tutorial_slow_1.bag --clock`

**Path planning with Gazebo:**
* **Terminal 1:** `roslaunch smb_sim sim_path_planner.launch run_gazebo_gui:=true`
* **Terminal 2:** `roslaunch smb_navigation navigate2d_ompl.launch`

**Use container for code development:**
- Install VS Code on your host machine and add the "Remote - Container" extension.
- Go to the "Remote Explorer" tab, select "Containers" and open the `/home` folder in the container `/smb`.
- You can now use the IDE for development purpose inside the container.
- **IMPORTANT:** Only files inside the `code` folder will be saved when you close the container.

**Useful resources:**
* [Build secrets and SSH forwarding in Docker 18.09](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066)