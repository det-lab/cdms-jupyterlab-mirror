### So you're looking to help manage the CDMS Jupyter space...  

It can be a bit weird at first, so my hope with this document is to break down the git repository, and walk you through the steps in building a new image and making it accessible to the collaboration!

Go ahead and clone the repository anywhere you like:  
`$ git clone https://gitlab.com/supercdms/CompInfrastructure/cdms-jupyterlab.git`

### First, let's have a look through what all is there. 

- README, RELEASE, LICENSE - the usual stuff. 

- A **build.sh** script which does everything for us, just needs to be called from command line:  
  - `$ bash build.sh`  
  - The image version can be tweaked in here, it's the variable `$IMAGE_VER`  

- The main course is the **Dockerfile**, which is a series of instructions for the Docker daemon when it builds an image.  
  - This is where our packages get installed  

- **scripts/clone-repos.sh** locally clones CMDS repositories from GitLab, to be copied into the image later

- **scripts/rootenv.sh** is basically a boiled down version of ROOT's `thisroot.sh`, which can be sourced from any Python and should allow importing ROOT
  
- **hooks/post-hook.sh** 
  - Creates symlinks from `/opt` to `$HOME/Tutorials` so users have some reference material in their jupyter homespace 
    - also makes sure this directory is read only, to prevent breaking edits to the global version
  - Initializes the custom bash environment
  
- **hooks/launch.bash** and **kernels/py3-ROOT** work together to configure the jupyter notebook kernel   

### Alright, now let's break each of these down and see what they do in more detail. [Click here to continue](./breakdown.md)
