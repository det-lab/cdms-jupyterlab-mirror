#!/bin/bash
export DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Script directory: $DIR
#####################################################

. scripts/clone-repos.sh

export DOCKER_IMG='supercdms/cdms-jupyterlab'
<<<<<<< HEAD
export IMAGE_VER='1.9b'
=======
export IMAGE_VER='1.8'
>>>>>>> 95b0f605196f0dddfc48c7eef3466c5003ac9629

cd $DIR

if docker build --rm --tag $DOCKER_IMG:$IMAGE_VER --tag $DOCKER_IMG:stable -f Dockerfile . ; then
  docker push $DOCKER_IMG

else echo -e "\e[31mError\e[0m: Docker build failed!"
  
fi
