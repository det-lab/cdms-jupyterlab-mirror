## Create or clear Tutorials dir, copy examples and tutorials
if [ ! -d "$HOME/notebooks/Tutorials" ]; then
  mkdir -p $HOME/notebooks/Tutorials
elif [ -d "$HOME/notebooks/Tutorials" ]; then
  rm -rf $HOME/notebooks/Tutorials/*
fi

chmod -R 755 $HOME/notebooks/Tutorials

mkdir $HOME/notebooks/Tutorials/pyCAP 
ln -s /packages/pyCAP/examples/* $HOME/notebooks/Tutorials/pyCAP/

mkdir $HOME/notebooks/Tutorials/scdmsPyTools 
ln -s /packages/scdmsPyTools/demo/* $HOME/notebooks/Tutorials/scdmsPyTools/

mkdir $HOME/notebooks/Tutorials/Analysis
ln -s /packages/tutorials/tutorial1_ivcurves_tc.ipynb $HOME/notebooks/Tutorials/Analysis/'Tutorial 1 - IV Curves (TC).ipynb'
ln -s /packages/tutorials/animal_circuit.png $HOME/notebooks/Tutorials/Analysis/animal_circuit.png

mkdir $HOME/notebooks/Tutorials/Introduction 
ln -s /packages/tutorials/JupyterDemo-Jan01.ipynb $HOME/notebooks/Tutorials/Introduction/'Intro to JupyterLab'.ipynb
ln -s /packages/tutorials/2019-01-06_111527.jpg $HOME/notebooks/Tutorials/Introduction/
ln -s /packages/tutorials/AnimalDataIO.py $HOME/notebooks/Tutorials/Introduction/

chmod -R 555 $HOME/notebooks/Tutorials

## Customize bash env
ln -s /packages/cdmsbash/ $HOME
bash $HOME/cdmsbash/init.sh
