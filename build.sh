#!/bin/bash
export DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Script directory: $DIR
#####################################################

. scripts/clone-repos.sh

export DOCKER_IMG='supercdms/cdms-jupyterlab'
export IMAGE_VER='1.8b'

cd $DIR
docker build \
    --rm \
    --tag $DOCKER_IMG:$IMAGE_VER \
    -f Dockerfile .

docker push $DOCKER_IMG:$IMAGE_VER
