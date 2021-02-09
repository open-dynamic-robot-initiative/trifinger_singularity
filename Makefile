sifs = blmc_ei_base.sif pylon.sif blmc_ei_user.sif blmc_ei_robot.sif

.PHONY: all
all: sifs

# Regarding the structure of this Makefile:
# There is a generic "make *.sif" target which simply builds the *.def file of
# the same name.  Images that have dependencies should resolve them in a target
# for the specific def file.

pylon.def: blmc_ei_base.sif

blmc_ei_user.def: blmc_ei.def.template blmc_ei_base.sif
	sed -e "s/%BASE_IMAGE%/blmc_ei_base.sif/" \
		-e "s/%BUILD_OPTIONS%//" \
		blmc_ei.def.template > $@

blmc_ei_robot.def: blmc_ei.def.template pylon.sif
	sed -e "s/%BASE_IMAGE%/pylon.sif/" \
		-e "s/%BUILD_OPTIONS%/--cmake-args -DOS_VERSION=preempt-rt/" \
		blmc_ei.def.template > $@


# build arbitrary def file
%.sif: %.def
	singularity build --fakeroot $@ $<
