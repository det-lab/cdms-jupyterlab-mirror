#!/bin/bash
PYTHON_VER=$1
CONFIG_FILE=$2
if [ -e ${HOME}/notebooks/.user_setups ]; then
    source ${HOME}/notebooks/.user_setups
fi
. /opt/anaconda3/etc/profile.d/conda.sh && conda activate cdms
exec python${PYTHON_VER} -m ipykernel -f ${CONFIG_FILE}
