#!/usr/bin/env bash

### make local directory for cloning repos

if [ ! -e "$DIR/cdms_repos" ]; then mkdir $DIR/cdms_repos; fi

### Repositories in GitLab

export CDMSGIT='git@gitlab.com:supercdms'

repos=( 
    "CompInfrastructure/cdmsbash"
    "Analysis/python_colorschemes" 
    "Analysis/tutorials" 
    "Analysis/pyCAP" 
    "Analysis/scdmsPyTools_TF" 
)

for repo in "${repos[@]}"; do
    if [[ -d "$DIR/cdms_repos/$repo" ]]; then
        cd $DIR/cdms_repos/$repo 
        git pull
    elif [[ ! -e "$DIR/cdms_repos/$repo" ]]; then
        cd $DIR/cdms_repos/
        git clone $CDMSGIT/$repo
    fi
done

### Repositories that need to be cloned separately
# analysis_tools (not in gitlab)
if [ -d "$DIR/cdms_repos/analysis_tools" ] && [ -d "$DIR/cdms_repos/analysis_tools/.git" ]; then
    cd $DIR/cdms_repos/analysis_tools
    git pull
elif [ -d "$DIR/cdms_repos/analysis_tools" ] && [ ! "$(ls -A $DIR/cdms_repos/analysis_tools)" ]; then
    rm -r $DIR/cdms_repos/analysis_tools
    cd $DIR/cdms_repos
    git clone josh@nero:/data/git/TF_Analysis/Northwestern/analysis_tools.git
elif [ ! -d "$DIR/cdms_repos/analysis_tools" ] && [ ! -d "$DIR/cdms_repos/analysis_tools" ]; then
    cd $DIR/cdms_repos
    git clone josh@nero:/data/git/TF_Analysis/Northwester/analysis_tools.git
fi

# scdmsPyTools (--recursive doesn't work)
if [ -d "$DIR/cdms_repos/Analysis/scdmsPyTools" ] && [ -d "$DIR/cdms_repos/Analysis/scdmsPyTools/.git" ]; then
    cd $DIR/cdms_repos/Analysis/scdmsPyTools
    git pull
else
    cd $DIR/cdms_repos/Analysis
    rm -r scdmsPyTools
    git clone $CDMSGIT/Analysis/scdmsPyTools.git
    cd scdmsPyTools/scdmsPyTools/BatTools 
    rm -r BatCommon
    git clone $CDMSGIT/Reconstruction/BatCommon.git 
    cd BatCommon
    rm -r IOLibrary
    git clone $CDMSGIT/DAQ/IOLibrary.git 
    cd $DIR/cdms_repos/Analysis/scdmsPyTools
    git submodule update --init --recursive
fi

### Move back to top level dir
cd $DIR