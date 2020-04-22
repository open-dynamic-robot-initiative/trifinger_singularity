# blmc_ei_singularity

Singularity definition files related to the BLMC EI project.

## General: Building Images

To build a Singularity image from a given definition file, use the following
command (you may need to adjust the file names according to your needs):

    singularity build --fakeroot blmc_ei.sif blmc_ei.def

The `--fakeroot` option enables building without `sudo`.


## The BLMC_EI Image

This image, defined in `blmc_ei.def`, provides the environment to build and run
the code from the BLMC_EI treep project.

Build it normally using the above command.

Inside the container is a file `/setup.bash`.  It sets up the ROS environment
and defines a command `catbuild` which is basically an alias for `catkin build`
with flags set that are needed for building the BLMC_EI project.

So to build the workspace and run things with the container do

    cd path/to/your_workspace
    singularity shell --nv path/to/blmc_ei.sif
    . /setup.bash
    catbuild

    # source the workspace
    . devel/setup.bash
    rosrun your_package your_node


### Known Issues

#### OpenCV with Python 3

ROS brings it's own installation of `cv2` which gets added to `$PYTHONPATH` when
sourcing `/setup.bash`.  This leads to an error when importing `cv2` in a Python
3 script.  To work around this issue, don't source `/setup.bash` at all (it is
not needed for running things, only for building) or clear `$PYTHONPATH` using

    export PYTHONPATH=""


## The Challenge Image

### Building the Image

The challenge image (defined in challenge_image.def) extends the "blmc_ei" image
(see above) by adding a compiled version of the BLMC_EI project workspace.  With
this, users can build and run their own code using our libraries without having
to build them themselves.

Build Requirements:

- You already have an image called `blmc_ei.sif`, based on `blmc_ei.def` (see
  above).
- You have treep installed locally and access to all repositories of the BLMC_EI
  treep project.

To build the image run the following (assuming that both `blmc_ei.sif` and
`challenge_image.def` are in the current working directory).

    singularity build --fakeroot challenge.sif challenge_image.def


### Using the Image

Same as the original blmc_ei image, with the difference that all packages of the
BLMC_EI project are already installed inside.


### Apps

Apart from adding the BLMC_EI project code, this image defines two "apps"
`build` and `run` which are meant for usage by the automated submission system.

`build` assumes that the user workspace is bound at `/ws` and simply runs
`catbuild` there:

    singularity run --app build --B local/ws/path:/ws challenge.sif

`run` executes a script called `run` that is assumed to be bound at
`/ws/src/usercode`:

    singularity run --app run --B local/ws/path:/ws challenge.sif
