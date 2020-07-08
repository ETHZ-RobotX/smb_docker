# SMB_docker

**Steps:**
* **Build docker container:** `DOCKER_BUILDKIT=1 docker build --ssh default -t smb .`
* **Run docker container:** `bash run.sh`
* **Open new terminal window from running container:** `bash open_container_terminal.sh`


**Useful resources:**
* [Build secrets and SSH forwarding in Docker 18.09](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066)

**TODO:**
* Test tutorial 1 [Partially done]
* Test remaining [tutorials](https://github.com/ethz-asl/eth_supermegabot/tree/master/tutorials)