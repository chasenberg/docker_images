Run docker container and install ownCloud
=======================================
1. Build the docker image and run the container
```
sudo docker build -t dockerfile . 
sudo docker run -it 
```
2. Run Docker container
```
sudo docker run -it -p 443:443 dockerfile
```
 * Find out the id of the running container:
```
sudo docker ps -a 
```
 * Attach to the running container:
```
sudo docker attach container_id 
```
**Remember that typing 'exit' in a running container will stop it. Instead press 'ctrl+p' and then 'ctrl+q'!**

3. Inside the container, run the command `bash setup/setup.sh` to execute the shell script that will guide you through the installation of the LAMP stack and ownCloud itself.
