## Create or clear Tutorials dir, copy examples and tutorials
if [ ! -d "$HOME/notebooks/Tutorials" ]; then
  mkdir -p $HOME/notebooks/Tutorials
elif [ -d "$HOME/notebooks/Tutorials" ]; then
  rm -rf $HOME/notebooks/Tutorials/*
fi

chmod -R 755 $HOME/notebooks/Tutorials

mkdir $HOME/notebooks/Tutorials/pyCAP 
ln -s /opt/pyCAP/examples/* $HOME/notebooks/Tutorials/pyCAP/

mkdir $HOME/notebooks/Tutorials/scdmsPyTools 
ln -s /opt/scdmsPyTools/demo/* $HOME/notebooks/Tutorials/scdmsPyTools/

mkdir $HOME/notebooks/Tutorials/Analysis
ln -s /opt/tutorials/tutorial1_ivcurves_tc.ipynb $HOME/notebooks/Tutorials/Analysis/'Tutorial 1 - IV Curves (TC).ipynb'
ln -s /opt/tutorials/animal_circuit.png $HOME/notebooks/Tutorials/Analysis/animal_circuit.png

mkdir $HOME/notebooks/Tutorials/Introduction 
ln -s /opt/tutorials/JupyterDemo-Jan01.ipynb $HOME/notebooks/Tutorials/Introduction/'Intro to JupyterLab'.ipynb
ln -s /opt/tutorials/2019-01-06_111527.jpg $HOME/notebooks/Tutorials/Introduction/
ln -s /opt/tutorials/AnimalDataIO.py $HOME/notebooks/Tutorials/Introduction/

chmod -R 555 $HOME/notebooks/Tutorials

## Customize bash env
rm $HOME/cdmsbash && ln -s /opt/cdmsbash/ $HOME
echo ". cdmsbash/main" > $HOME/.bashrc
sed -i 's/\/packages/\opt/g' $HOME/.bashrc
