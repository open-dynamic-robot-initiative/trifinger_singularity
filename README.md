# TriFinger Apptainer/Singularity Images

Apptainer definition files related to the TriFinger project.


## Get Pre-Build Containers

You can pull pre-build containers directly with apptainer.  For example for the
latest `trifinger_user` container:

    apptainer pull oras://ghcr.io/open-dynamic-robot-initiative/trifinger_singularity/trifinger_user:latest

Simply adjust the name and tag at the end accordingly for the other containers.


## Build Containers Yourself

### Requirements

For building the base images only a recent version of Singularity or
[Apptainer](https://apptainer.org) and an internet connection is required.

For building the images containing the TriFinger software (*trifinger_user* and
*trifinger_robot*) the following applications are required in addition:

- git
- [treep](https://pypi.org/project/treep/)

Further you will need a GitHub account with an SSH key set up, otherwise cloning
the repositories via `treep` will not work.


### General: Building Images

To build a specific image (let's say `trifinger_base.sif`), simply call:

    make trifinger_base.sif

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

- *trifinger_base*:  All dependencies to build/run the ROBOT_FINGERS project.
- *trifinger_base_pylon*:  Adds Pylon SDK to trifinger_base.
- *trifinger_{user,robot}*:  The `ROBOT_FINGERS` project packages are installed
  in this image, so they don't need to be built manually.  The "user"-version
  uses a normal build, "robot" one for real-time systems.
- *solo_bolt_{user,robot}*:  Same as above but with the software packages for
  the Solo and Bolt robots.

Below follows a more detailed description of the separate images.


### Image "trifinger_base"

Build with:

    make trifinger_base.sif

This image, defined in `trifinger_base.def`, provides the environment to build and
run the code from the `ROBOT_FINGERS` treep project.

Inside the container is a file `/setup.bash` which needs to be sourced to set up
the environment for building/running the code.

So to build the workspace and run things with the container do

    cd path/to/your_workspace
    singularity shell --nv path/to/trifinger_base.sif
    . /setup.bash
    colcon build

    # source the workspace
    . install/local_setup.bash
    ros2 run <package_name> <executable_name>


### Image "trifinger_base_pylon"

Build with:

    make trifinger_base_pylon.sif

Adds the Pylon SDK to the base image.  This is needed for building the camera
drivers for the TriFinger robots.

The license of Pylon can be found in `/opt/pylon5/share/pylon/License.html`
inside this image.  You may only use it if you accept its license.


### Images "trifinger_user"/"trifinger_robot"

Build with:

    make trifinger_user.sif
    make trifinger_robot.sif

Both images are based on the same definition template `trifinger.def` but using
different build arguments.
They both extend the base image by adding a pre-built `ROBOT_FINGERS` workspace.
This is meant for users of the robot who want to run applications from the robot
packages or build their own applications depending on them but who do not need
to modify the core packages.

The "user" image uses a non-real-time build and is thus only suitable for
running the simulation or applications using the robot front end with
multi-process time series.

The "robot" image includes Pylon and is built for the real-time system.  It can
be used to run the robot backend but requires user permissions to launch
real-time threads.

When building, the project source is cloned to the directory `./build` and
copied from there to the image.  Note that once cloned, the local workspace is
not updated automatically when rebuilding the image!  To make sure you have the
latest version of the code, run `make clean` first.


### Images "solo_bolt_user"/"solo_bolt_robot"

Same as above but including the software packages for the Solo and Bolt robots
instead of the TriFinger.
