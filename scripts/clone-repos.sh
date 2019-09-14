#!/usr/bin/env bash

### make local directory for cloning repos
if [ ! -e "$DIR/cdms-repos" ]; then 
    mkdir $DIR/cdms-repos
    mkdir $DIR/cdms-repos/CompInfrastructure
    mkdir $DIR/cdms-repos/Analysis
fi

export CDMSGIT='git@gitlab.com:supercdms'

### Analysis code
repos=( 
    "Analysis/python_colorschemes" 
    "Analysis/tutorials" 
    "Analysis/pyCAP" 
    "Analysis/scdmsPyTools_TF" 
)
for repo in "${repos[@]}"; do
    if [ -d "$DIR/cdms-repos/$repo" ] && [ -d "$DIR/cdms-repos/$repo/.git" ]; then	
        cd $DIR/cdms-repos/$repo
        git pull
    elif [ ! -e "$DIR/cdms-repos/$repo" ]; then
	cd $DIR/cdms-repos/Analysis
	git clone $CDMSGIT/$repo.git
    fi
done

### CompInfrastructure code
repos=(
    "CompInfrastructure/cdmsbash"
)
for repo in "${repos[@]}"; do
    if [ -d "$DIR/cdms-repos/$repo" ] && [ -d "$DIR/cdms-repos/$repo/.git" ]; then
        cd $DIR/cdms-repos/$repo
	git pull
    elif [ ! -e "$DIR/cdms-repos/$repo" ]; then
	cd $DIR/cdms-repos/CompInfrastructure
	git clone $CDMSGIT/$repo.git
    fi
done

### scdmsPyTools (recursive doesn't work)
if [ -d "$DIR/cdms-repos/Analysis/scdmsPyTools" ] && [ -d "$DIR/cdms-repos/Analysis/scdmsPyTools/.git" ]; then
    cd $DIR/cdms-repos/Analysis/scdmsPyTools
    git pull
elif [ ! -e "$DIR/cdms-repos/Analysis/scdmsPyTools" ]; then
    cd $DIR/cdms-repos/Analysis
    git clone $CDMSGIT/Analysis/scdmsPyTools.git
    cd scdmsPyTools/scdmsPyTools/BatTools
    rm -r BatCommon
    git clone $CDMSGIT/Reconstruction/BatCommon.git
    cd BatCommon
    rm -r IOLibrary
    git clone $CDMSGIT/DAQ/IOLibrary.git
    cd $DIR/cdms-repos/Analysis/scdmsPyTools
    git submodule update --init --recursive
fi

### analysis_tools (not in gitlab)
if [ -d "$DIR/cdms-repos/analysis_tools" ] && [ -d "$DIR/cdms-repos/analysis_tools/.git" ]; then
    cd $DIR/cdms-repos/analysis_tools
    git pull    
elif [ ! -e "$DIR/cdms-repos/analysis_tools" ]; then
    cd $DIR/cdms-repos
    git clone josh@nero:/data/git/TF_Analysis/Northwestern/analysis_tools.git
fi
