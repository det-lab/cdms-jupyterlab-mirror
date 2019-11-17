#!/bin/bash

### Install to scl python
source scl_source enable rh-python36
source $ROOTSYS/bin/thisroot.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BOOST_PATH/lib

# List of packages to be installed (follows GitLab dir. structure)
pkg=(
  "analysis_tools"
  "Analysis/python_colorschemes"
  "Analysis/pyCAP"
  "Analysis/scdmsPyTools"
  "DataHandling/Datacat"
)

# build BatTools ahead of time
cd /opt/Analysis/scdmsPyTools/scdmsPyTools/BatTools
make

# python install loop
for pkg in "${pkg[@]}"; do 
  cd /opt/$pkg
  python setup.py install
done  
