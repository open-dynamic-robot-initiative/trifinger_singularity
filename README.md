# blmc_ei_singularity

Singularity definition files related to the BLMC EI project.

## Building Images

To build a Singularity image from a given definition file, use the following
command (you may need to adjust the file names according to your needs):

    singularity build --fakeroot blmc_ei.sif blmc_ei.def

The `--fakeroot` option enables building without `sudo`.

## sourcing
1. For pinocchio, 
    source /openrobots_setup.bash
    
2. For building the container (do not do this if you want to import stable_baselines),
    source /setup.bash
    
3. For importing the workspace packages,
    source workspace/devel/setup.bash

### Note:
 
- In order to be able to import cv2, first build the workspace by running the shell and sourcing 
/setup.bash. Then, restart the shell, and this time DON'T source /setup.bash. Just source 
the devel/setup.bash of the workspace. Good to go. This happens because sourcing the setup.bash of 
ros kinetic results in the cv2 file from python2.7 even when run from python3.

- To run stable_baselines, clone it in your home directory, and then export the PYTHONPATH to point at it when you run the container. So,
  
  ```
  git clone https://github.com/hill-a/stable-baselines
  singularity shell <....>
  export PYTHONPATH=/home/$USER/stable-baselines
  ```

  Good to go!