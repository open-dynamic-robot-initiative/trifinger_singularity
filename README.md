# blmc_ei_singularity

Singularity definition files related to the BLMC EI project.

## General: Building Images

To build a Singularity image from a given definition file, use the following
command (you may need to adjust the file names according to your needs):

    singularity build --fakeroot blmc_ei_base.sif blmc_ei_base.def

The `--fakeroot` option enables building without `sudo`.


## Images in this Repository

This repository contains definition files for the following images.  They are
based on each other, so usually one image just extends the previous one with
additional functionality.

- *blmc_ei_base*:  All dependencies to build/run the BLMC_EI project.
- *blmc_ei*:  The BLMC_EI project packages are installed in this image, so they
  don't need to be built manually.
- *submission*:  Adds "apps" to build and run user code through the submission
  system.

You can either build them manually using the build command shown above or run
`build_all.sh` to build all of them at once.

Below follows a more detailed description of the separate images.


### Image "blmc_ei_base"

This image, defined in `blmc_ei_base.def`, provides the environment to build and
run the code from the BLMC_EI treep project.

Build it normally using the above command.

Inside the container is a file `/setup.bash`.  It sets up the ROS environment
and defines a command `catbuild` which is basically an alias for `catkin build`
with flags set that are needed for building the BLMC_EI project.

So to build the workspace and run things with the container do

    cd path/to/your_workspace
    singularity shell --nv path/to/blmc_ei_base.sif
    . /setup.bash
    catbuild

    # source the workspace
    . devel/setup.bash
    rosrun your_package your_node


#### Known Issues

##### OpenCV with Python 3

ROS brings it's own installation of `cv2` which gets added to `$PYTHONPATH` when
sourcing `/setup.bash`.  This leads to an error when importing `cv2` in a Python
3 script.  To work around this issue, don't source `/setup.bash` at all (it is
not needed for running things, only for building) or clear `$PYTHONPATH` using

    export PYTHONPATH=""


### Image "blmc_ei"

Extends blmc_ei_base, i.e. to build it you need to have `blmc_ei_base.sif` in
your current working directory.

Adds a compiled version of the BLMC_EI project workspace.  With this, users can
run executables of the project or build their own code that depends on it,
without having to build the BLMC_EI packages themselves.

It adds a "runscript" to execute commands with set up environment.  Example:

    ./blmc_ei.sif rosrun robot_fingers demo_fake_finger.py


#### Requirements

At build, the BLMC_EI project code is fetched using treep.  Therefore you need
to have treep installed locally and have access to all repositories of the
BLMC_EI treep project.


## Image "submission"

### Building the Image

Extends blmc_ei, i.e. to build it you need to have `blmc_ei.sif` in your current
working directory.

This image defines two "apps" `build` and `run` which are meant for usage by the
automated submission system.

`build` assumes that the user workspace is bound at `/ws` and simply runs
`catbuild` there:

    singularity run --app build --B local/ws/path:/ws challenge.sif

`run` executes a script called `run` that is assumed to be bound at
`/ws/src/usercode`:

    singularity run --app run --B local/ws/path:/ws challenge.sif
