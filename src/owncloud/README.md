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
3. Find out the id of the running container:
```
sudo docker ps -a 
```
    *Attach to the running container:
```
sudo docker attach container_id 
```
