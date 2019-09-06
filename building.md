### Building an image

Alright, now we know what all the files do, let's look at how we use them to build an image. 

To actually build the image, just open a terminal and call:  
`cdms-jupyterlab $ bash build.sh`
or  
`/any/directory $ bash /path/to/cdms-jupyterlab/build.sh` 

And that's it!! From here, the script will:  

1. Source  `scripts/clone-repos` to clone or pull CDMS repos locally in `../cdms-jupyterlab/cdms-repos/`

2. Call the Docker daemon to build an image based on `./Dockerfile`, tagging it with the version number from `build.sh`, and 

3. Push it to `supercdms/cdms-jupyterlab:$IMG_VER`

#### Image Tags / Versions

The only thing we should really change in `./build.sh` is the $IMG_VER tag when it's time to update that. The problem is we don't currently have full control over which spawner options appear in jupyter.slac.stanford.edu. That's something Yee at SLAC manages, so what I do in the meantime is manage a [gist](https://gist.github.com/glass-ships/f861df8d3dd732feccac6f04c5eeca7f) in YAML format, which specifies the images we'd like to show up as CDMS options when people log in. Any time the image seems like it's in a good spot to release one stable version and start developing another, I update the gist and let Yee know to pull it on his end in order to update those options. 

Hopefully this is something we'll eventually get easier control of, but in the mean time, most of my changes are to the same 'beta' version, rather than iterating the version number with every new build (as would probably be the normal case). 
So for example, just keep building and making changes to '1.7b' until it seems really stable, and any changes you might start making are a little bigger (like upgrading ROOT, or maybe Yee has a new base image to pull from). At that point you might push it to `1.7`, merge the `cdms-jupyterlab` repository to the master branch, and start working in develop on `1.8b`. 

### Cool! What about fixing or making changes to an image? [Leeeeeeeeet's find out!](changing.md)