# SuperCDMS JupyterLab

## Overview

SLAC maintains a number of JupyterLab images for various research projects.
This repository contains the code used to build an image for dark matter analysis by the SuperCDMS experiment.

**Dependencies:** 
- Docker CE Edge ([installation guide](https://docs.docker.com/install/linux/docker-ce/ubuntu/))

**Notes:**  
- Docker requires sudo acces, or that the user be added to the `Docker` group 
- SSH access to CDMS git repositories
- All cloning is done locally - SSH keys remain secure. 

## Usage

Documentation on the official SuperCDMS JupyterLab image is available to SLAC users via [Confluence](https://confluence.slac.stanford.edu/display/CDMS/How+to+get+started+with+analysis).

If you're interested in building your own Docker image for local use: 

- `./build.sh` provides an example script that you'll likely want to adjust to fit your needs.
- < add instructions for using jupyterlab > 

## Contributing

If you'd like to make changes to the CDMS JupyterLab analysis environment, you should contribute to the **develop branch of this repository**.

Detailed instructions can be found in the `docs` directory. 

[It's dangerous to go alone. Take this!](docs/main.md)
