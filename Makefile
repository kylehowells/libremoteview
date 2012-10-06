ARCHS=armv7

include /opt/theos/makefiles/common.mk

LIBRARY_NAME = LibRemoteView
LibRemoteView_FILES = LibRemoteView.mm
LibRemoteView_FRAMEWORKS = Foundation UIKit QuartzCore
LibRemoteView_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/library.mk
SUBPROJECTS += libremoteviewserver
SUBPROJECTS += remoteviewserver
SUBPROJECTS += remoteviewclient
include $(THEOS_MAKE_PATH)/aggregate.mk
