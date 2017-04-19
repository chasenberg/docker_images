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
This will start the docker container while mapping the port `443` , which will be used for ssl-encryption later on, to the port `443` of your host machine. 
 * Find out the id of the running container:
```
sudo docker ps -a 
```
 * Attach to the running container:
```
sudo docker attach container_id 
```
**Remember that typing 'exit' in a running container will stop it. Instead press `ctrl+p` and then `ctrl+q`!**

3. Inside the container, run the command `bash setup/setup.sh` to execute the shell script that will guide you through the installation of the LAMP stack and ownCloud itself.

4. Now, ownCloud should be up and running on www.yourdomain.com/owncloud. In this step you will encrypt the connection using a self signed certificate. 
 * Install `letsencrypt`
 ```
 cd /opt/
 git clone https://github.com/letsencrypt/letsencrypt
 ```
 * Then, run the following commands:
 ```
 cd letsencrypt/
 ./letsencrypt-auto --help
 /etc/init.d/apache2 stop
 ./letsencrypt-auto certonly --rsa-key-size 4096 -d www.yourdomain.com
 ./letsencrypt-auto --apache
 ```
 At this point you should be able to reach your site by typing `https://www.yourdomain.com/owncloud` ! 
