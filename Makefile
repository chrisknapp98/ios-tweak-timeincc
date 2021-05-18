TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
FINALPACKAGE = 1

ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TimeInCC
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

TimeInCC_FILES = Tweak.xm
TimeInCC_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += timeinccpreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
