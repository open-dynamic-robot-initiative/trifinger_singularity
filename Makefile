sifs = trifinger_base.sif trifinger_base_pylon.sif trifinger_user.sif trifinger_robot.sif

.PHONY: all
all: $(sifs)

workspace:
	@echo "Clone workspace to './workspace'"
	mkdir workspace
	cd workspace; \
		git clone git@github.com:machines-in-motion/treep_machines_in_motion.git --branch real_robot_challenge_2021; \
		treep --clone ROBOT_FINGERS

.PHONY: clean
clean:
	rm -rf workspace
	rm -f trifinger_user.def
	rm -f trifinger_robot.def

.PHONY: clean_sif
clean_sif:
	rm -f $(sifs)


# Regarding the structure of this Makefile:
# There is a generic "make *.sif" target which simply builds the *.def file of
# the same name.  Images that have dependencies should resolve them in a target
# for the specific def file.

trifinger_base_pylon.def: trifinger_base.sif

trifinger_user.def: trifinger.def.template trifinger_base.sif workspace
	sed -e "s/%BASE_IMAGE%/trifinger_base.sif/" \
		-e "s/%BUILD_OPTIONS%//" \
		trifinger.def.template > $@

trifinger_robot.def: trifinger.def.template trifinger_base_pylon.sif workspace
	sed -e "s/%BASE_IMAGE%/trifinger_base_pylon.sif/" \
		-e "s/%BUILD_OPTIONS%/--cmake-args -DOS_VERSION=preempt-rt/" \
		trifinger.def.template > $@


# build arbitrary def file
%.sif: %.def
	singularity build --fakeroot $@ $<
