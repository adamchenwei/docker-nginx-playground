
#reset config file
printf ".... 1.0 reset conf file to default\n"
git checkout conf/default.conf

printf ".... 1.0.0 list all the files...\n"
ls -lA

#create nginx configuration file
printf ".... 1.0.1 get my ip address...\n"
myip=`ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
echo $myip

sed -i "s/proxy_pass http:\/\/myip:9010\/api\/login;/proxy_pass http:\/\/"$myip":9010\/api\/login;/g" conf/default.conf

DOCKER_SERVICE_NAME='contentserver'

printf ".... 1.1 list all running containers\n"
sudo docker container ls
printf ".... 1.2  stop and removal of current content server...\n"
sudo docker ps -q --filter ancestor="$DOCKER_SERVICE_NAME" | xargs -r sudo docker stop
sudo docker ps -q --filter ancestor="$DOCKER_SERVICE_NAME" | xargs -r sudo docker rm
sudo docker ps -q --filter ancestor="$DOCKER_SERVICE_NAME" --filter "status=exited" | xargs -r sudo docker rm
printf ".... 2.1 list all images before delete\n"
sudo docker images
printf ".... 2.2 remove docker image for $DOCKER_SERVICE_NAME...\n"
sudo docker rmi $DOCKER_SERVICE_NAME
printf ".... 2.3 list all images after delete\n"
sudo docker images
printf ".... 2.4 build content server image again...\n"
sudo docker build -t $DOCKER_SERVICE_NAME .



printf "32769:80 -> 80:80"
printf ".... 3 start content server...\n"
sudo docker run -d -p 80:80 $DOCKER_SERVICE_NAME

printf ".... 4 show running server info...\n"
sudo docker container ls
