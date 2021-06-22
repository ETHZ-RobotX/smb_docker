# SMB_docker

**Steps:**
* **Build docker iamge (~15mn):** `sudo docker build -f <path_to_Dockerfile> -t test_img .`
* **Build docker container:** `sudo docker run -p 8080:80 -it --name test_cont test_img `


*** In Docker *** 
cd home/catkin_ws/src and follow the installation guide