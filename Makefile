sifs = trifinger_base.sif trifinger_base_pylon.sif trifinger_user.sif trifinger_robot.sif solo_bolt_user.sif solo_bolt_robot.sif

USE_SUDO = 0

.PHONY: all
all: $(sifs)

build/trifinger:
	@echo "Clone workspace to './build/trifinger'"
	mkdir -p build/trifinger
	cd build/trifinger; \
		git clone https://github.com/machines-in-motion/treep_machines_in_motion.git; \
		treep --clone-https ROBOT_FINGERS

build/solo_bolt:
	@echo "Clone workspace to './build/solo_bolt'"
	mkdir -p build/solo_bolt
	cd build/solo_bolt; \
		git clone https://github.com/machines-in-motion/treep_machines_in_motion.git; \
		treep --clone-https ROBOT_INTERFACES_SOLO; \
		treep --clone-https ROBOT_INTERFACES_BOLT;

.PHONY: clean
clean:
	rm -rf build

.PHONY: clean_sif
clean-sif:
	rm -f $(sifs)


# Regarding the structure of this Makefile:
# There is a generic "make *.sif" target which simply builds the *.def file of
# the same name.  Images that have dependencies should resolve them in a target
# for the specific def file.

trifinger_base_pylon.def: trifinger_base.sif

# Images using the "trifinger.def" file are different as build-args need to be
# passed to them
trifinger_user.sif: trifinger.def trifinger_base.sif build/trifinger
	@echo "Build $@..."
	apptainer build \
		--build-arg BASE_IMAGE=trifinger_base.sif \
		--build-arg WS_DIR=build/trifinger/workspace \
		$@ trifinger.def

trifinger_robot.sif: trifinger.def trifinger_base_pylon.sif build/trifinger
	@echo "Build $@..."
	apptainer build \
		--build-arg BASE_IMAGE=trifinger_base_pylon.sif \
		--build-arg WS_DIR=build/trifinger/workspace \
		--build-arg REALTIME_BUILD=true \
		$@ trifinger.def

solo_bolt_user.sif: trifinger.def trifinger_base.sif build/solo_bolt
	@echo "Build $@..."
	apptainer build \
		--build-arg BASE_IMAGE=trifinger_base.sif \
		--build-arg WS_DIR=build/solo_bolt/workspace \
		$@ trifinger.def

solo_bolt_robot.sif: trifinger.def trifinger_base.sif build/solo_bolt
	@echo "Build $@..."
	apptainer build \
		--build-arg BASE_IMAGE=trifinger_base.sif \
		--build-arg WS_DIR=build/solo_bolt/workspace \
		--build-arg REALTIME_BUILD=true \
		$@ trifinger.def


# build arbitrary def file
%.sif: %.def
	@echo "Build $@..."
	apptainer build $@ $<
