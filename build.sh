#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo Script directory: $DIR
#####################################################

. scripts/clone-repos.sh

cd $DIR
docker build \
    --rm \
    -t supercdms/cdms-jupyterlab:1.7b \
    -f Dockerfile .

docker push supercdms/cdms-jupyterlab:1.7b
