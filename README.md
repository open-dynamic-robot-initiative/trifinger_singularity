# TriFinger Singularity Images

Singularity definition files related to the TriFinger project.


## Requirements

For building the base images only a recent version of
[Singularity](https://singularity.hpcng.org) and an internet connection is
required.

For building the images containing the TriFinger software (*trifinger_user* and
*trifinger_robot*) the following applications are required in addition:

- git
- [treep](https://pypi.org/project/treep/)

Further you will need a GitHub account with an SSH key set up, otherwise cloning
the repositories via `treep` will not work.


## General: Building Images

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
- *trifinger_user*:  The `ROBOT_FINGERS` project packages are installed in this
  image, so they don't need to be built manually.
- *trifinger_robot*:  Same as *trifinger_user* but with Pylon and using a
  "preempt_rt" build.  This image is for running the software on the actual
  robot.

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

Both images are based on the same definition template `trifinger.def.template`
and extend the base image by adding a pre-built `ROBOT_FINGERS` workspace.  This
is meant for users of the robot who want to run applications from the robot
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
