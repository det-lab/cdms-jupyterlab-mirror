#!/usr/bin/env bash

##################################################################################
# This script clones relevant code from the SCDMS GitLab. 
# It is organized into loops based on the directory structure of the repository.
# To add a new repository, add it to the corresponding `repo` list, following the 
# structure of the already included examples. 
###################################################################################

### Make local directories for cloning repos
mkdir $DIR/cdms-repos
mkdir $DIR/cdms-repos/CompInfrastructure
mkdir $DIR/cdms-repos/Analysis
mkdir $DIR/cdms-repos/DataHandling


# Variable to shorten repo URLs
export CDMSGIT='git@gitlab.com:supercdms'

### Analysis code
repos=( 
  "Analysis/python_colorschemes" 
  "Analysis/tutorials" 
  "Analysis/pyCAP" 
  "Analysis/scdmsPyTools"
  "Analysis/scdmsPyTools_TF"
)
for repo in "${repos[@]}"; do
  if [ -d "$DIR/cdms-repos/$repo" ] && [ -d "$DIR/cdms-repos/$repo/.git" ]; then	
      cd $DIR/cdms-repos/$repo
      git pull
  elif [ ! -e "$DIR/cdms-repos/$repo" ]; then
    cd $DIR/cdms-repos/Analysis
  	git clone --recursive $CDMSGIT/$repo.git
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
   	git clone --recursive $CDMSGIT/$repo.git
  fi
done

### DataHandling code
repos=(
  "DataHandling/Datacat"
)
for repo in "${repos[@]}"; do
  if [ -d "$DIR/cdms-repos/$repo" ] && [ -d "$DIR/cdms-repos/$repo/.git" ]; then
    cd $DIR/cdms-repos/$repo
#    git pull
  elif [ ! -e "$DIR/cdms-repos/$repo" ]; then
    cd $DIR/cdms-repos/DataHandling
    git clone --recursive $CDMSGIT/$repo.git
  fi
done

### analysis_tools (not in gitlab)
if [ -d "$DIR/cdms-repos/analysis_tools" ] && [ -d "$DIR/cdms-repos/analysis_tools/.git" ]; then
    cd $DIR/cdms-repos/analysis_tools
    git pull    
elif [ ! -e "$DIR/cdms-repos/analysis_tools" ]; then
    cd $DIR/cdms-repos
    git clone josh@nero:/data/git/TF_Analysis/Northwestern/analysis_tools.git
fi
