
DOCKER_SERVICE_NAME='contentserver'

printf ".... 3.1 list all running containers\n"
docker container ls
printf ".... 3.2  stop and removal of current content server...\n"
docker ps -q --filter ancestor="$DOCKER_SERVICE_NAME" | xargs -r docker stop
docker ps -q --filter ancestor="$DOCKER_SERVICE_NAME" | xargs -r docker rm
docker ps -q --filter ancestor="$DOCKER_SERVICE_NAME" --filter "status=exited" | xargs -r docker rm
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