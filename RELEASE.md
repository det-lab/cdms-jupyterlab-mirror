# CDMS JupyterLab Version History 

### Version 1.7
- Software updates:
    - ROOT 6.18.00
    - Boost lib 1.70.0
    - Cmake 3.15.2
- Tweak Dockerfile to use more variables for easier future software updates
- Replace `/packages` with `/opt` for all installations (for compatibility with potential future updates)
- Minor updates to tutorial notebooks
- Source code updates:
    - create script to clone repos

### Version 1.6  
- Reduce launcher options to simplify interface
- Add custom colorized bash prompt with more information
- A number of useful UI tools added
    -  Google Drive integration
    - Dask dashboard
    - Git integration 
- Note: 
	ERROR: awkward-numba 0.10.3 has requirement awkward==0.10.3, but you'll have awkward 0.9.0 which is incompatible.

### Version 1.0
- Add python 3 kernel with ROOT support
- Update pip to v19
- Add python color schemes and animal data analysis tools by Lise Wills
- Addition of dask[complete], keras, tensorflow, and other potentially useful Python packages (see Dockerfile for a full list)
- Edit vimrc to allow for arrow-key navigation in terminal vi sessions
	
