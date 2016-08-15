BUNDLE_NAME = PokemonGo_Patcher
PokemonGo_Patcher_FILES = PokemonGo_Patcher.mm
SDKVERSION = 9.2
SYSROOT = $(THEOS)/sdks/iPhoneOS9.2.sdk
PokemonGo_Patcher_INSTALL_PATH = /Library/PreferenceBundles
PokemonGo_Patcher_FRAMEWORKS = UIKit Foundation
PokemonGo_Patcher_PRIVATE_FRAMEWORKS = Preferences
IP_ADDRESS=127.0.0.1
RSYNC_SETTINGS = -e "ssh -p 2222" -z
SSH_PORT = -p 2222
PokemonGo_Patcher_CFLAGS = -I$(SYSROOT)/usr/include/libxml2
PokemonGo_Patcher_LDFLAGS = -lxml2
PokemonGo_Patcher_LDFLAG += -Wl,-segalign,0x4000
export ARCHS = armv7 armv7s arm64
export TARGET = iphone:clang::8.0

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk


internal-stage ::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PokemonGo_Patcher.plist$(ECHO_END)
	rsync $(RSYNC_SETTINGS) .theos/_/Library/PreferenceBundles/PokemonGo_Patcher.bundle/* root@$(IP_ADDRESS):/Library/PreferenceBundles/PokemonGo_Patcher.bundle/

sync: stage
	rsync -e "ssh -p 2222" -z .theos/_/Library/PreferenceLoader/Preferences/PokemonGo_Patcher.plist root@$(IP_ADDRESS):/Library/PreferenceLoader/Preferences/PokemonGo_Patcher.plist
	ssh root@$(IP_ADDRESS) $(SSH_PORT) killall Preferences