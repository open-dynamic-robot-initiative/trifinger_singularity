.PHONY: all
all: base pylon.sif blmc_ei.sif submission.sif

.PHONY: base
base: blmc_ei_base.sif

pylon.sif: blmc_ei_base.sif
	singularity build --fakeroot $@ $<

blmc_ei.sif: blmc_ei_base.sif
	singularity build --fakeroot $@ $<

submission.sif: blmc_ei.sif
	singularity build --fakeroot $@ $<

# build arbitrary def file
%.sif: %.def
	singularity build --fakeroot $@ $<
