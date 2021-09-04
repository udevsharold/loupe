ARCHS = arm64 arm64e

TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LoupePrefs

LoupePrefs_FILES = LoupeRootListController.m
LoupePrefs_FRAMEWORKS = UIKit
LoupePrefs_PRIVATE_FRAMEWORKS = Preferences
LoupePrefs_EXTRA_FRAMEWORKS = AltList
LoupePrefs_INSTALL_PATH = /Library/PreferenceBundles
LoupePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
