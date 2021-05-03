export ARCHS = arm64 arm64e
export DEBUG = 0
export FINALPACKAGE = 1

export PREFIX = $(THEOS)/toolchain/Xcode11.xctoolchain/usr/bin/

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Loupe

Loupe_FILES = $(wildcard *.xm) $(wildcard *.mm)
Loupe_CFLAGS = -fobjc-arc
Loupe_LIBRARIES = rocketbootstrap
Loupe_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += loupeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
