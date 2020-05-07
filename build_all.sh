#!/bin/sh
DEF_PATH=${1:-.}

buildimage() {
    singularity build --fakeroot $1.sif ${DEF_PATH}/$1.def
}

echo "Build base image"
#singularity build --fakeroot blmc_ei_base.sif ${DEF_PATH}/blmc_ei_base.def
buildimage blmc_ei_base

echo
echo "=================================================="
echo 
echo "Build base image with Pylon"
buildimage pylon

echo
echo "=================================================="
echo 
echo "Build BLMC_EI image"
buildimage blmc_ei

echo
echo "=================================================="
echo 
echo "Build submission image"
buildimage submission
