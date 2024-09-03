# Copyright 2024 Engicam
#
# SPDX-License-Identifier: BSD-3-Clause

# Engicam test tools for CAN, Serial, mtd

engicam_test_tools:
	@[ $(DESTARCH) != arm64 -o $(SOCFAMILY) != IMX ] && exit || \
	 $(call fbprint_b,"engicam_test_tools") && \
	 $(call repo-mngr,fetch,engicam_test_tools,apps/utils) && \
	 cd $(UTILSDIR)/engicam_test_tools && \
	 export CC="$(CROSS_COMPILE)gcc --sysroot=$(RFSDIR)" && \
	 export LDFLAGS="-L$(RFSDIR)/usr/lib -L$(RFSDIR)/usr/lib/aarch64-linux-gnu" && \
	 $(MAKE) -j$(JOBS) -C recipes-core/cantest/cantest && \
	 install -m 0755 recipes-core/cantest/cantest/cantest $(DESTDIR)/usr/bin/cantest && \
	 $(MAKE) -j$(JOBS) -C recipes-core/serialtools/serialtools && \
	 install -m 0755 recipes-core/serialtools/serialtools/test_serial $(DESTDIR)/usr/bin/test_serial && \
	 install -m 0755 recipes-core/serialtools/serialtools/test_serial2 $(DESTDIR)/usr/bin/test_serial2 && \
	 install -m 0755 recipes-core/serialtools/serialtools/test_gps $(DESTDIR)/usr/bin/test_gps && \
	 $(call fbprint_d,"engicam_test_tools")
