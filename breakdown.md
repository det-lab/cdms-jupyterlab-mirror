### Now let's break each of them down

Most of the shell scripts starts with  
```
#!/bin/bash
export DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
```

Which defines a variable for the directory of the script being called.
ex:  
```
$ echo $DIR
/home/loki/Downloads/cdms-jupyterlab/
```
This just lets everything find everything else more easily within the repository.

#### 1. build.sh

This is the most straightfoward script. It:  

1. Calls `scripts/clone-repos.sh` which locally clones CDMS repositories, to be copied into the image later
2. Specifies the Docker image and tag to be used in the build
3. Builds the image using `./Dockerfile` 
4. Pushes it to Docker Hub

Not much really needs change here over time, but whenever we're ready to release a new version of the image to the SLAC JupyterLab, we just need to change `export IMAGE_VER='x.y'` to reflect the new version number before building.

#### 2. scripts/clone.sh

This one is set up a bit funky, I admit, but the goal is to make it as easy as possible to add/remove cdms packages we want in the image, and to conveniently `git pull` them whenever a new master commit is ready.
  
As far as what it actually does: 

1. Creates a directory `.../cdms-jupyterlab/cdms_repos` locally to clone everything 

2. Defines a variable `$CDMSGIT` to abbreviate the git links

3. Creates a list of repositories to loop through

```
repos=( 
    "CompInfrastructure/cdmsbash"
    "Analysis/python_colorschemes" 
    "Ana lysis/tutorials" 
    "Analysis/pyCAP" 
    "Analysis/scdmsPyTools_TF" 
)
```
These will get tacked on to the end of `$CDMSGIT` in a loop which: 
  - Checks if the directory already exists
    - Clones if it doesn't
    - Git pulls if it does  
    
Note - The format here is based on GitLab's allowing of "folders," have a peek [here](gitlab.com/supercdms) to get a sense of what I mean by that if you're not already familiar.  

There are also a couple repositories that aren't in GitLab, or that don't work when trying to `git clone --recursive`, so I had to set up manual loops for each of those. Eventually though, the hope is **all** our repositories will be together somewhere like GitHub or GitLab. (GitBlit is ok but everyone kinda hates it and it doesn't offer great outside integration for things like CI/CD)

#### 3. kernels/py3-ROOT

This is half of how we'll define the environment for Jupyter notebooks within the image.  
I'm not really sure why this exists in the framework, since all it really does is define a `display_name` and then calls a `launch.bash` in line 5. But it does!  
So basically this just gets copied as is to the direectory where the Jupyter notebook kernels live within the image.  
Now, the base image - `slaclab/slac-jupyterlab` - uses Red Hat SCL (Software CoLlections) Python, so that means we need to:  
`COPY kernels/py3-ROOT /opt/rh/rh-python36/root/usr/share/jupyter/kernels/python3/kernel.json` (Dockerfile line 152)

#### 3.5 hooks/launch.bash

This is the other, more interesting half of Jupyter notebook configuration.  

```
#!/bin/bash
PYTHON_VER=$1
CONFIG_FILE=$2
if [ -e ${HOME}/notebooks/.user_setups ]; then
    source ${HOME}/notebooks/.user_setups
fi
source $ROOTSYS/bin/thisroot.sh
exec python${PYTHON_VER} -m ipykernel -f ${CONFIG_FILE}
```

It gets a couple things from that `kernel.json`, but notice that line `source $ROOTSYS/bin/thisroot.sh`? That's what allows the notebook to know where ROOT is and use it properly. ROOT should be the only case where something like this needs to be done, but other bash commands can be issued there before the notebook kernel is actually started. 
