#!/bin/bash
export DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Script directory: $DIR
#####################################################

. scripts/clone-repos.sh

export DOCKER_IMG='supercdms/cdms-jupyterlab'
export IMAGE_VER='1.8b'

cd $DIR
if docker build --rm --tag $DOCKER_IMG:$IMAGE_VER -f Dockerfile . ; then
    docker push $DOCKER_IMG:$IMAGE_VER
else echo -e "\e[31mError\e[0m: Docker build failed!"
fi
