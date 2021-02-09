# TriFinger Singularity Images

Singularity definition files related to the TriFinger project.

Maintainer:  Felix Widmaier (felix.widmaier@tue.mpg.de)

Bamboo Build: [MPI - IS - Robotics/BLMC_EI Singularity](https://atlas.is.localnet/bamboo/browse/MGC-BS)

Built images can be [downloaded here](https://code.is.localnet/series/23/33/)
(scroll to the bottom for the latest revision).


## General: Building Images

To build a specific image (let's say `foobar.sif`), simply call:

    make foobar.sif

Note that for some images, `treep` is used to clone the TriFinger packages.
This requires that a SSH key is set up for git and activated (e.g. via
`ssh-add`).


There are two different clean targets:

    make clean

deletes all intermediate build files like definition files that are based on
templates or the workspace directory with the source packages.  It does *not*
delete the built images (`*.sif`).

    make clean_sif

deletes all images built by this Makefile.


## Images in this Repository

This repository contains definition files for the following images.  They are
based on each other, so usually one image just extends the previous one with
additional functionality.

- *blmc_ei_base*:  All dependencies to build/run the ROBOT_FINGERS project.
- *pylon*:  Adds Pylon SDK to blmc_ei_base.
- *blmc_ei_user*:  The `ROBOT_FINGERS` project packages are installed in this
  image, so they don't need to be built manually.
- *blmc_ei_robot*:  Same as *blmc_ei_user* but with Pylon and using a
  "preempt_rt" build.  This image is for running the software on the actual
  robot.

Below follows a more detailed description of the separate images.


### Image "blmc_ei_base"

Build with:

    make blmc_ei_base.sif

This image, defined in `blmc_ei_base.def`, provides the environment to build and
run the code from the `ROBOT_FINGERS` treep project.

Inside the container is a file `/setup.bash` which needs to be sourced to set up
the environment for building/running the code.

So to build the workspace and run things with the container do

    cd path/to/your_workspace
    singularity shell --nv path/to/blmc_ei_base.sif
    . /setup.bash
    colcon build

    # source the workspace
    . install/local_setup.bash
    ros2 run <package_name> <executable_name>


### Image "pylon"

Build with:

    make pylon.sif

Adds the Pylon SDK to the base image.  Needed for building the camera drivers
for the TriFinger robots.

This is kept separate from the base image due to potential license issues with
Pylon.


### Images "blmc_ei_user"/"blmc_ei_robot"

Build with:

    make blmc_ei_user.sif
    make blmc_ei_robot.sif

Both images are based on the same definition template `blmc_ei.def.template` and
extend the base image by adding a pre-built `ROBOT_FINGERS` workspace.  This is
meant for users of the robot who want to run applications from the robot
packages or build their own applications depending on them but who do not need
to modify the core packages.

The "user" image is for running non-real-time code like the simulation or
applications using the robot frontend with multi-process time series.

The "robot" image includes Pylon and is built for the real-time system.  It can
be used to run the robot backend.

When building, the project source is cloned to the directory `./workspace` and
copied from there to the image.  Note that once cloned, the local workspace is
not updated automatically when rebuilding the image!  To make sure you have the
latest version of the code, run `make clean` first.

#### Requirements

At build time, the ROBOT_FINGERS project code is fetched using treep.  Therefore
you need to have treep installed locally.  Further, an SSH key with access to
all repositories as the be set up and activated.
