DEBUG = 0
PACKAGE_VERSION = 0.0.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HomeButtonTimer
HomeButtonTimer_FILES = Switch.xm
HomeButtonTimer_LIBRARIES = flipswitch substrate
HomeButtonTimer_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk
