include common/vars.mk

pkgs := $(notdir $(shell find "pkg/" -maxdepth 1 -type d))

.PHONY: apk deb rpm static
apk deb rpm static:
	$(MAKE) $(foreach pkg,$(pkgs),$@-$(pkg))

.PHONY: apk-%
apk-%:
	$(MAKE) -C pkg/$* pkg-apk

.PHONY: deb-%
deb-%:
	$(MAKE) -C pkg/$* pkg-deb

.PHONY: rpm-%
rpm-%:
	$(MAKE) -C pkg/$* pkg-rpm

.PHONY: static-%
static-%:
	$(MAKE) -C pkg/$* pkg-static

include common/packages.mk

GHA_MATRIX ?= minimal
ifeq ($(GHA_MATRIX),minimal)
	GHA_RELEASES := debian10 debian11 debian12 ubuntu1804 ubuntu2004 ubuntu2204 ubuntu2304 centos7 centos9 oraclelinux7 fedora37 fedora38 static
else ifeq ($(GHA_MATRIX),all)
	GHA_RELEASES := $(PKG_DEB_RELEASES) $(PKG_RPM_RELEASES) static
else
	GHA_RELEASES := $(GHA_MATRIX)
endif

.PHONY: gha-matrix
gha-matrix:
	@echo "$(GHA_RELEASES)" | jq -cR 'split(" ")'
