################################################################################
####     Dockerfile for creation of SuperCDMS JupyterLab analysis image     ####   
####     See ./README.md for details                                        ####
################################################################################

FROM slaclab/slac-jupyterlab:20190712.2
USER root

RUN yum -y install sudo && sudo yum -y upgrade

## Install additional system packages
RUN sudo yum install -y \
	centos-release-scl git patch net-tools binutils \
	gcc libcurl-devel libX11-devel \
	blas-devel libarchive-devel fuse-sshfs jq graphviz dvipng \
	libXext-devel bazel http-parser nodejs perl-Digest-MD5 perl-ExtUtils-MakeMaker gettext \
	# LaTeX tools
	pandoc texlive texlive-collection-xetex texlive-ec texlive-upquote texlive-adjustbox \ 
	# Data formats
	hdf5-devel \ 
	# Compression tools
	bzip2 unzip lrzip zip zlib-devel \ 
	# Terminal utilities
	fish tree ack screen tmux vim-enhanced neovim nano pico emacs emacs-nox \  
	&& sudo yum clean all

## Install additional SCL Python packages
RUN source $ROOTSYS/bin/thisroot.sh && \
	source scl_source enable rh-python36 && \
	pip3 install --upgrade pip setuptools && \
	pip3 --no-cache-dir install \
		jupyter jupyterlab metakernel \
		memory-profiler \
		root_numpy root_pandas uproot \
		h5py tables \
		iminuit tensorflow pydot keras \
		awkward awkward-numba zmq \
		dask[complete] \
		xlrd xlwt openpyxl 

## Install Anaconda 3 and some packages
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh -O /opt/anaconda.sh && \
    /bin/bash /opt/anaconda.sh -b -p /opt/anaconda3 && \
    rm /opt/anaconda.sh
COPY scripts/rootenv.sh $ROOTSYS/bin/ 
RUN . /opt/anaconda3/etc/profile.d/conda.sh && \
	conda activate base && \ 
	. $ROOTSYS/bin/rootenv.sh && \
	conda install jupyter jupyterlab metakernel \
	        h5py iminuit tensorflow pydot keras \
	        dask[complete] \
	        xlrd xlwt openpyxl && \
	conda install -c conda-forge fish && \
	pip install --upgrade pip setuptools && \
	pip --no-cache-dir install memory-profiler tables \
		zmq root_pandas awkward awkward-numba uproot root_numpy

### CDMS packages ###

## Import CDMS packages
COPY cdms-repos/analysis_tools /opt/analysis_tools
COPY cdms-repos/Analysis/python_colorschemes /opt/python_colorschemes
COPY cdms-repos/Analysis/tutorials /opt/tutorials
COPY cdms-repos/Analysis/pyCAP /opt/pyCAP
COPY cdms-repos/Analysis/scdmsPyTools /opt/scdmsPyTools
COPY cdms-repos/Analysis/scdmsPyTools_TF /opt/scdmsPyTools_TF
COPY cdms-repos/CompInfrastructure/cdmsbash /opt/cdmsbash

WORKDIR /opt
RUN source scl_source enable rh-python36 && \
	source $ROOTSYS/bin/thisroot.sh && \
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BOOST_PATH/lib && \
	cd /opt/analysis_tools && python setup.py install && \
	cd /opt/python_colorschemes && python setup.py install && \
	cd /opt/pyCAP && python setup.py install && \
	cd /opt/scdmsPyTools/scdmsPyTools/BatTools && \
	make && cd ../.. && python setup.py install 

### Finalize environment ###

## Copy hook for Tutorials and custom bash env
COPY hooks/post-hook.sh /opt/slac/jupyterlab/post-hook.sh

## Create ROOT-enabled and code-developing notebook options 
COPY hooks/launch.bash /opt/slac/jupyterlab/launch.bash
COPY kernels/py3-ROOT /opt/rh/rh-python36/root/usr/share/jupyter/kernels/python3/kernel.json
RUN rm -rf /usr/local/share/jupyter/kernels/slac_stack
