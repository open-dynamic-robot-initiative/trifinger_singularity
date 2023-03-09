sifs = trifinger_base.sif trifinger_base_pylon.sif trifinger_user.sif trifinger_robot.sif solo_robot.sif

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
	rm -f trifinger_user.def
	rm -f trifinger_robot.def
	rm -f solo_robot.def

.PHONY: clean_sif
clean_sif:
	rm -f $(sifs)


# Regarding the structure of this Makefile:
# There is a generic "make *.sif" target which simply builds the *.def file of
# the same name.  Images that have dependencies should resolve them in a target
# for the specific def file.

trifinger_base_pylon.def: trifinger_base.sif

trifinger_user.def: trifinger.def.template trifinger_base.sif build/trifinger
	sed -e "s/%BASE_IMAGE%/trifinger_base.sif/" \
		-e "s/%WS_DIR%/build\/trifinger\/workspace/" \
		-e "s/%CMAKE_ARGS%//" \
		trifinger.def.template > $@

trifinger_robot.def: trifinger.def.template trifinger_base_pylon.sif build/trifinger
	sed -e "s/%BASE_IMAGE%/trifinger_base_pylon.sif/" \
		-e "s/%WS_DIR%/build\/trifinger\/workspace/" \
		-e "s/%CMAKE_ARGS%/-DOS_VERSION=preempt-rt/" \
		trifinger.def.template > $@

solo_bolt_user.def: trifinger.def.template trifinger_base.sif build/solo_bolt
	sed -e "s/%BASE_IMAGE%/trifinger_base.sif/" \
		-e "s/%WS_DIR%/build\/solo_bolt\/workspace/" \
		-e "s/%CMAKE_ARGS%//" \
		trifinger.def.template > $@

solo_bolt_robot.def: trifinger.def.template trifinger_base.sif build/solo_bolt
	sed -e "s/%BASE_IMAGE%/trifinger_base.sif/" \
		-e "s/%WS_DIR%/build\/solo_bolt\/workspace/" \
		-e "s/%CMAKE_ARGS%/-DOS_VERSION=preempt-rt/" \
		trifinger.def.template > $@


# build arbitrary def file
%.sif: %.def
	apptainer build $@ $<
