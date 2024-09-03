# Copyright 2024 Engicam
#
# SPDX-License-Identifier: BSD-3-Clause

# brcm-patchram-plus is a small utility to flash firmware for BT Broadcom cards

brcm_patchram_plus:
	@[ $(DESTARCH) != arm64 -o $(SOCFAMILY) != IMX ] && exit || \
	 $(call fbprint_b,"brcm_patchram_plus") && \
	 $(call repo-mngr,fetch,brcm_patchram_plus,apps/utils) && \
	 cd $(UTILSDIR)/brcm_patchram_plus && \
	 ./autogen.sh --prefix=/usr --host=aarch64-linux-gnu && \
	 $(MAKE) -j$(JOBS) && \
	 $(MAKE) install && \
	 $(call fbprint_d,"brcm_patchram_plus")
