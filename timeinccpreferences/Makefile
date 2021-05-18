TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TimeInCCPreferences

$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
TimeInCCPreferences_FILES = TICRootListController.m
TimeInCCPreferences_FRAMEWORKS = UIKit
TimeInCCPreferences_PRIVATE_FRAMEWORKS = Preferences
TimeInCCPreferences_INSTALL_PATH = /Library/PreferenceBundles
TimeInCCPreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
