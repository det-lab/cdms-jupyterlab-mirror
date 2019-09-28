################################################################################
####     Dockerfile for creation of SuperCDMS JupyterLab analysis image     ####   
####     See ./README.md for details                                        ####
################################################################################

FROM slaclab/slac-jupyterlab:20190712.2
USER root

ENV CMAKEVER=3.15.2
ENV BOOSTVER=1.70.0
ENV BOOST_PATH=/opt/boost1.70
ENV ROOTVER=6.18.00
ENV ROOTSYS=/opt/root6.18
 
RUN yum -y install sudo && sudo yum -y upgrade

### Boost and ROOT

# ROOT and Boost dependencies
RUN sudo yum install -y gcc-gfortran openssl-devel pcre-devel \
	mesa-libGL-devel mesa-libGLU-devel glew-devel ftgl-devel mysql-devel \
	fftw-devel cfitsio-devel graphviz-devel gsl-static\
	avahi-compat-libdns_sd-devel libldap-dev python-devel \
	libxml2-devel libXpm-devel libXft-devel gcc-c++ 

# Install cmake v >=3.9 (required to build ROOT 6)
RUN wget --quiet https://github.com/Kitware/CMake/releases/download/v$CMAKEVER/cmake-$CMAKEVER.tar.gz -O /tmp/cmake.tar.gz && \
	tar -zxf /tmp/cmake.tar.gz --directory=/tmp  && cd /tmp/cmake-$CMAKEVER/ && \
	./bootstrap && \
	make -j 4  && sudo make install && \
	rm -r /tmp/cmake* 

# Build boost >=1.65 (required by scdmsPyTools, version not packaged in centos)
RUN sudo ln -s /opt/rh/rh-python36/root/usr/include/python3.6m /opt/rh/rh-python36/root/usr/include/python3.6
RUN source scl_source enable rh-python36 && \
	wget --quiet https://dl.bintray.com/boostorg/release/$BOOSTVER/source/boost_$(echo $BOOSTVER|tr . _).tar.gz -O /tmp/boost.tar.gz && \
	tar -zxf /tmp/boost.tar.gz --directory=/tmp && \
	cd /tmp/boost_$(echo $BOOSTVER|tr . _)/ && \
	./bootstrap.sh && \
	./b2 install --prefix=$BOOST_PATH -j 4 && \
	rm -r /tmp/boost*

# Create softlink for boost shared objects (for compatibility)
RUN ln -s $BOOST_PATH/lib/libboost_numpy36.so $BOOST_PATH/lib/libboost_numpy.so && \
        ln -s $BOOST_PATH/lib/libboost_python36.so $BOOST_PATH/lib/libboost_python.so

# Build ROOT 
RUN wget --quiet https://root.cern.ch/download/root_v$ROOTVER.source.tar.gz -O /tmp/rootsource.tar.gz && \
	tar -zxf /tmp/rootsource.tar.gz --directory=/tmp
RUN source scl_source enable rh-python36 && \
	mkdir -p /tmp/root-$ROOTVER/rootbuild && cd /tmp/root-$ROOTVER/rootbuild && \
	cmake -j 4 \
	-Dxml:BOOL=ON \
	-Dvdt:BOOL=OFF \
	-Dbuiltin_fftw3:BOOL=ON \
	-Dfitsio:BOOL=OFF \
	-Dfftw:BOOL=ON \
	-Dxrootd:BOOL=OFF \
	-DCMAKE_INSTALL_PREFIX:PATH=$ROOTSYS \
	-Dpython3=ON \
	-Dpython=ON \
	-DPYTHON_EXECUTABLE:PATH=/opt/rh/rh-python36/root/usr/bin/python \
	-DPYTHON_INCLUDE_DIR:PATH=/opt/rh/rh-python36/root/usr/include/python3.6m \
	-DPYTHON_LIBRARY:PATH=/opt/rh/rh-python36/root/usr/lib64/libpython3.6m.so \
	..  
RUN source /tmp/root-$ROOTVER/rootbuild/bin/thisroot.sh && \
	cd /tmp/root-$ROOTVER/rootbuild && \
	cmake --build . --target install -- -j4
RUN rm -r /tmp/rootsource.tar.gz /tmp/root-$ROOTVER

### Extra packages and CDMS dependencies ###

## Additional repositories
RUN cd /etc/yum.repos.d/ && sudo wget --quiet https://download.opensuse.org/repositories/shells:fish:release:3/RHEL_7/shells:fish:release:3.repo

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

## Install additional Python packages
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
	conda create -n cdms && conda activate cdms && \ 
	conda config --add channels conda-forge && \
	#conda install conda && \
	. $ROOTSYS/bin/rootenv.sh && \
	conda install jupyter jupyterlab metakernel \
	        h5py iminuit tensorflow pydot keras \
	        dask[complete] \
	        xlrd xlwt openpyxl \ 
		root && \
	#conda install -c conda-forge root && \
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
ENV SHELL=/opt/anaconda3/bin/fish

## Create ROOT-enabled and code-developing notebook options 
COPY hooks/launch.bash /opt/slac/jupyterlab/launch.bash
COPY kernels/py3-ROOT /opt/rh/rh-python36/root/usr/share/jupyter/kernels/python3/kernel.json
COPY hooks/launch2.bash /opt/slac/jupyterlab/launch2.bash
COPY kernels/cdms-conda /usr/local/share/jupyter/kernels/cdms-conda/kernel.json
#/opt/anaconda3/envs/cdms/share/jupyter/kernels/python3/kernel.json
RUN rm -rf /usr/local/share/jupyter/kernels/slac_stack
