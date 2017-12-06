#!/bin/ksh
#create nginx configuration file
MyIP=`ifconfig | grep "broadcast"| head -n1 | cut -d " " -f2`
echo $MyIP

sed -i "s/proxy_pass http:\/\/myip\/api\/login;/proxy_pass http:\/\/"$myip":9010\/api\/login;/g" conf/default.conf

DOCKER_SERVICE_NAME='contentserver'

printf ".... 3.1 list all running containers\n"
docker container ls
printf ".... 3.2  stop and removal of current content server...\n"
docker rm $(docker stop $(docker ps -a -q --filter ancestor=$DOCKER_SERVICE_NAME --format="{{.ID}}"))
printf ".... 4.1 list all images before delete\n"
docker images
printf ".... 4.2 remove docker image for $DOCKER_SERVICE_NAME...\n"
docker rmi $DOCKER_SERVICE_NAME
printf ".... 4.3 list all images after delete\n"
docker images
printf ".... 4.4 build content server image again...\n"
docker build -t $DOCKER_SERVICE_NAME .



printf "32769:80 -> 80:80"
printf ".... 5 start content server...\n"
docker run -d -p 80:80 $DOCKER_SERVICE_NAME

printf ".... 6 show running server info...\n"
docker container ls
