# added by thisroot.sh
export ROOTSYS=/opt/root${ROOTVER:0:4}
export DYLD_LIBRARY_PATH=$ROOTSYS/lib
export JUPYTER_PATH=$ROOTSYS/etc/notebook
export LIBPATH=$ROOTSYS/lib
export ROOTSYS=$ROOTSYS
export SHLIB_PATH=$ROOTSYS/lib

# appended to by thisroot.sh
export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
export MANPATH=$ROOTSYS/man:$MANPATH
export PATH=$ROOTSYS/bin:$PATH
export PYTHONPATH=$ROOTSYS/lib:$PYTHONPATH
