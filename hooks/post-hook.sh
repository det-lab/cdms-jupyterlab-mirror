## Create or clear Tutorials dir, copy examples and tutorials
chmod -R 755 $HOME/notebooks/Tutorials
rm -rf $HOME/notebooks/Tutorials
ln -s /opt/tutorials/Tutorials $HOME/notebooks/Tutorials

mkdir $HOME/notebooks/Tutorials/pyCAP 
ln -s /opt/pyCAP/examples/* $HOME/notebooks/Tutorials/pyCAP/

mkdir $HOME/notebooks/Tutorials/scdmsPyTools 
ln -s /opt/scdmsPyTools/demo/* $HOME/notebooks/Tutorials/scdmsPyTools/
chmod -R 555 $HOME/notebooks/Tutorials

## Customize bash env
rm $HOME/cdmsbash && ln -s /opt/CompInfrastructure/cdmsbash/ $HOME
echo ". cdmsbash/main" > $HOME/.bashrc
sed -i 's/\/packages/\opt/g' $HOME/.bashrc
