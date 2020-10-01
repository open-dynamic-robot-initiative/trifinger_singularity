.PHONY: all
all: base pylon.sif blmc_ei.sif

.PHONY: base
base: blmc_ei_base.sif

pylon.sif: pylon.def blmc_ei_base.sif
	singularity build --fakeroot $@ pylon.def

blmc_ei.sif: blmc_ei.def blmc_ei_base.sif
	singularity build --fakeroot $@ blmc_ei.def

# build arbitrary def file
%.sif: %.def
	singularity build --fakeroot $@ $<
