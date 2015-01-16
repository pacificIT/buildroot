ifeq ($(BR2_PACKAGE_LIBBCM2835),y)
	include package/stak/platform/raspberrypi/libbcm2835/libbcm2835.mk
endif

ifeq ($(BR2_PACKAGE_ARMMEM),y)
	include package/stak/platform/raspberrypi/armmem/armmem.mk
endif

ifeq ($(BR2_PACKAGE_HOSTAPDRTL),y)
	include package/stak/platform/raspberrypi/hostapdrtl/hostapdrtl.mk
endif

ifeq ($(BR2_PACKAGE_BX),y)
	include package/stak/platform/raspberrypi/bx/bx.mk
endif

ifeq ($(BR2_PACKAGE_BGFX),y)
	include package/stak/platform/raspberrypi/bgfx/bgfx.mk
endif

ifeq ($(BR2_PACKAGE_OTTOSDK),y)
	include package/stak/ottosdk/ottosdk.mk
endif


ifeq ($(BR2_PACKAGE_RTL81XX),y)
	include package/stak/platform/rtl81xx/rtl81xx.mk
endif
