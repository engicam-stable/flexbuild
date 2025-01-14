# Copyright 2020-2024 NXP
#
# SPDX-License-Identifier: BSD-3-Clause


define imx_mkimage_target
    if [ ! -d $(BSPDIR)/imx_mkimage ]; then \
	$(call repo-mngr,fetch,imx_mkimage,bsp); \
    fi && \
    \
    if [ ! -d $(BSPDIR)/firmware-imx ]; then \
	cd $(BSPDIR) && wget -q $(repo_firmware_imx_bin_url) -O firmware_imx.bin && chmod +x firmware_imx.bin && \
	./firmware_imx.bin --auto-accept && mv firmware-imx* firmware-imx && rm -f firmware_imx.bin; \
    fi && \
    if [ ! -d $(BSPDIR)/imx-seco/firmware/seco ]; then \
	cd $(BSPDIR) && wget -q $(repo_seco_bin_url) -O imx-seco.bin && chmod +x imx-seco.bin && \
	./imx-seco.bin --auto-accept && mv `basename -s .bin $(repo_seco_bin_url)` imx-seco && rm -f imx-seco.bin; \
    fi && \
    if [ ! -d $(BSPDIR)/fw_ele ]; then \
	cd $(BSPDIR) && wget -q $(repo_fw_ele_bin_url) -O fw_ele.bin && chmod +x fw_ele.bin && \
	./fw_ele.bin --auto-accept && mv `basename -s .bin $(repo_fw_ele_bin_url)` fw_ele && rm -f fw_ele.bin; \
    fi && \
    if [ ! -d $(BSPDIR)/fw_upower ]; then \
	cd $(BSPDIR) && wget -q $(repo_fw_upower_bin_url) -O fw_upower.bin && chmod +x fw_upower.bin && \
	./fw_upower.bin --auto-accept && mv `basename -s .bin $(repo_fw_upower_bin_url)` fw_upower && rm -f fw_upower.bin; \
    fi && \
    if [ ! -f $(BSPDIR)/imx-scfw/mx8qx-mek-scfw-tcm.bin ]; then \
	wget -q $(repo_scfw_bin_url) -O imx-scfw.bin && chmod +x imx-scfw.bin && \
	./imx-scfw.bin --auto-accept && mv `basename -s .bin $(repo_scfw_bin_url)` imx-scfw && rm -f imx-scfw.bin; \
    fi && \
    if [ ! -d $(BSPDIR)/imx_mcore_demos ]; then \
	bld mcore_demo; \
    fi && \
    \
    if echo $1 | grep -qE ^imx8mp_ddr4_evk; then \
	SOC=iMX8MP; SOC_FAMILY=iMX8M; target=flash_ddr4_evk; \
    elif echo $1 | grep -qE ^imx8mp_evk; then \
	SOC=iMX8MP; SOC_FAMILY=iMX8M; target=flash_evk; \
    elif echo $1 | grep -qE ^imx8mp_icore; then \
	SOC=iMX8MP; SOC_FAMILY=iMX8M; dtbs=imx8mp-icore.dtb; target=flash_evk; \
    elif echo $1 | grep -qE ^imx8mm_ddr4_evk; then \
	SOC=iMX8MM; SOC_FAMILY=iMX8M; target=flash_ddr4_evk; \
    elif echo $1 | grep -qE ^imx8mm_evk; then \
	SOC=iMX8MM; SOC_FAMILY=iMX8M; target=flash_evk; \
    elif echo $1 | grep -qE ^imx8mn_ddr4_evk; then \
	SOC=iMX8MN; SOC_FAMILY=iMX8M; target=flash_ddr4_evk; \
    elif echo $1 | grep -qE ^imx8mn_evk; then \
	SOC=iMX8MN; SOC_FAMILY=iMX8M; target=flash_evk; \
    elif echo $1 | grep -qE ^imx8mq_ddr4_val; then \
	SOC=iMX8M; SOC_FAMILY=iMX8M; target=flash_ddr4_val; \
    elif echo $1 | grep -qE ^imx8mq_evk; then \
	SOC=iMX8M; SOC_FAMILY=iMX8M; target=flash_evk; \
    elif echo $1 | grep -qE ^imx8qm; then \
	SOC=iMX8QM; SOC_FAMILY=iMX8QM; target=flash_spl; \
	cp -f $(BSPDIR)/imx-scfw/mx8qm-mek-scfw-tcm.bin $(BSPDIR)/imx_mkimage/iMX8QM/scfw_tcm.bin; \
	cp -f $(BSPDIR)/imx-seco/firmware/seco/mx8qmb0-ahab-container.img $(BSPDIR)/imx_mkimage/iMX8QM; \
    elif echo $1 | grep -qE ^imx8qx; then \
	SOC=iMX8QX; SOC_FAMILY=iMX8QX; target=flash_spl; \
	cp -f $(BSPDIR)/imx-scfw/mx8qx-mek-scfw-tcm.bin $(BSPDIR)/imx_mkimage/iMX8QX/scfw_tcm.bin; \
	cp -f $(BSPDIR)/imx-seco/firmware/seco/mx8qx*-ahab-container.img $(BSPDIR)/imx_mkimage/iMX8QX; \
    elif echo $1 | grep -qE ^imx8ulp; then \
	SOC=iMX8ULP; SOC_FAMILY=iMX8ULP; target=flash_singleboot_m33; \
	cp $(BSPDIR)/fw_ele/mx8ulpa2-ahab-container.img $(BSPDIR)/imx_mkimage/iMX8ULP; \
	cp $(BSPDIR)/fw_upower/upower_a1.bin $(BSPDIR)/imx_mkimage/iMX8ULP/upower.bin; \
	cp $(BSPDIR)/imx_mcore_demos/imx8ulp-m33.bin $(BSPDIR)/imx_mkimage/iMX8ULP/m33_image.bin; \
    elif echo $1 | grep -qE ^imx93; then \
	SOC=iMX93; SOC_FAMILY=iMX93; target=flash_singleboot; \
	cp $(BSPDIR)/fw_ele/mx93a*-ahab-container.img $(BSPDIR)/imx_mkimage/iMX93; \
	cp $(BSPDIR)/fw_upower/upower_a*.bin $(BSPDIR)/imx_mkimage/iMX93/; \
	cp $(BSPDIR)/imx_mcore_demos/imx93-m33-demo/imx93-11x11-evk_m33_TCM_rpmsg_lite_str_echo_rtos.bin \
	   $(BSPDIR)/imx_mkimage/iMX93/m33_image.bin; \
    fi && \
    cp -f $(BSPDIR)/firmware-imx/firmware/ddr/synopsys/*.bin $(BSPDIR)/imx_mkimage/$$SOC_FAMILY; \
    \
    cd $(BSPDIR)/imx_mkimage && \
    $(MAKE) clean && $(MAKE) bin && \
    $(MAKE) SOC=iMX8M mkimage_imx8 && \
    if [ $(MACHINE) = imx8qmevk ];  then \
	$(MAKE) -C iMX8QM -f soc.mak imx8qm_dcd.cfg.tmp; \
    elif [ $(MACHINE) = imx8qxpmek ]; then \
	$(MAKE) -C iMX8QX REV=B0 -f soc.mak $$target; \
    elif [ $(MACHINE) = imx93evk ]; then \
	$(MAKE) SOC=iMX93 REV=A1 -C iMX93 -f soc.mak $$target; \
    fi && \
    \
    bl32=$(PKGDIR)/apps/security/optee_os/out/arm-plat-imx/core/tee_$$brd.bin && \
    if [ $(CONFIG_OPTEE) = y -a ! -f $$bl32 ]; then \
	bld optee_os -m $$brd -f $(CFGLISTYML); \
    fi && \
    [ $(MACHINE) = imx8ulpevk ] && plat=$${MACHINE:0:7} || plat=$${MACHINE:0:6} && \
    [ $(MACHINE) = imx93evk ] && plat=$${MACHINE:0:5} || true && \
    cp -t $(BSPDIR)/imx_mkimage/$$SOC_FAMILY \
	$(BSPDIR)/firmware-imx/firmware/hdmi/cadence/signed*_imx8m.bin \
	$$opdir/spl/u-boot-spl.bin $$opdir/u-boot.bin \
	$$opdir/arch/arm/dts/*$${plat}*.dtb \
	$$opdir/u-boot-nodtb.bin && \
    cp -f $$bl32 $(BSPDIR)/imx_mkimage/$$SOC_FAMILY/tee.bin && \
    cp -f $$opdir/tools/mkimage $(BSPDIR)/imx_mkimage/$$SOC_FAMILY/mkimage_uboot; \
    cp -f $(BSPDIR)/atf/build/$$plat/release/bl31.bin $(BSPDIR)/imx_mkimage/$$SOC_FAMILY/; \
    \
    $(MAKE) SOC=$$SOC $$REV_OPTION dtbs=$$dtbs $$target && \
    mkdir -p $(FBOUTDIR)/bsp/imx-mkimage/$$brd && \
    if [ $(MACHINE) = imx8mpevk -o $(MACHINE) = imx8mnevk -o $(MACHINE) = imx8mmevk -o \
	   $(MACHINE) = imx8mqevk ] && [ $$target = flash_ddr4_evk -o $$target = flash_ddr4_val ]; then \
	cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-ddr4.bin; \
    elif [ $(MACHINE) = imx8mpevk -o $(MACHINE) = imx8mpicore -o $(MACHINE) = imx8mnevk -o $(MACHINE) = imx8mmevk -o \
	   $(MACHINE) = imx8mqevk ] && [ $$target = flash_evk ]; then \
	cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-lpddr4.bin; \
    elif [ $(MACHINE) = imx8ulpevk -a $$target = flash_singleboot ]; then \
	cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-singleboot.bin; \
    elif [ $(MACHINE) = imx8ulpevk -a $$target = flash_singleboot_m33 ]; then \
	cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-singleboot-m33.bin; \
    elif [ $(MACHINE) = imx8ulpevk -a $$target = flash_dualboot ]; then \
	cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-dualboot.bin; \
    elif [ $(MACHINE) = imx8ulpevk -a $$target = flash_dualboot_m33 ]; then \
	cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-dualboot-m33.bin; \
    elif [ $(MACHINE) = imx93evk -a $$target = flash_singleboot ]; then \
	 cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-singleboot-a1.bin; \
    else \
	cp $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash.bin; \
    fi && \
    if [ $(MACHINE) = imx8qxpmek ]; then \
	mv $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-b0.bin; \
	$(MAKE) clean && $(MAKE) bin && \
	$(MAKE) SOC=iMX8QX mkimage_imx8 && \
	$(MAKE) SOC=iMX8QX REV=C0 -C iMX8QX -f soc.mak $$target && \
	mv $$SOC_FAMILY/flash.bin $(FBOUTDIR)/bsp/imx-mkimage/$$brd/flash-c0.bin; \
    fi
endef
