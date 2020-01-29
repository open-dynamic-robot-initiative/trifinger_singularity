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