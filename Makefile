TWEAK_NAME = PokemonGo_Patcher
PokemonGo_Patcher_OBJCC_FILES = Tweak.xm
PokemonGo_Patcher_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices
PokemonGo_Patcher_FRAMEWORKS = Foundation CoreLocation
PokemonGo_Patcher_PRIVATE_FRAMEWORKS = Foundation

ARCHS = armv7 armv7s arm64
TARGET = iphone:clang::5.0
include theos/makefiles/common.mk
include theos/makefiles/tweak.mk
LDFLAGS = -Wl,-segalign,0x4000
GO_EASY_ON_ME = 1

sync: stage
	rsync -e "ssh -p 2222" -z .theos/_/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/