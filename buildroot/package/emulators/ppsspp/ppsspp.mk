################################################################################
#
# PPSSPP
#
################################################################################
# Version: March 2, 2021
PPSSPP_VERSION = v1.11.3
PPSSPP_SITE = https://github.com/hrydgard/ppsspp.git
PPSSPP_SITE_METHOD=git
PPSSPP_GIT_SUBMODULES=YES
PPSSPP_LICENSE = GPLv2
PPSSPP_DEPENDENCIES = sdl2 libzip ffmpeg

PPSSPP_CONF_OPTS = \
	-DUSE_FFMPEG=ON -DUSE_SYSTEM_FFMPEG=OFF -DUSING_FBDEV=OFF -DUSE_WAYLAND_WSI=OFF \
	-DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME=Linux -DUSE_DISCORD=OFF \
	-DBUILD_SHARED_LIBS=OFF -DANDROID=OFF -DWIN32=OFF -DAPPLE=OFF \
	-DUNITTEST=OFF -DSIMULATOR=OFF -DARMV7=ON -DARM=ON -DUSING_EGL=OFF \
	-DUSING_GLES2=ON -DUSING_X11_VULKAN=OFF -DUSING_QT_UI=OFF -DHEADLESS=OFF 

PPSSPP_TARGET_CFLAGS = $(TARGET_CFLAGS)

PPSSPP_TARGET_BINARY = PPSSPPSDL

# make sure to select glvnd and depends on glew / glu because of X11 desktop GL
#ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_X86_ANY),y)
#	PPSSPP_CONF_OPTS += -DOpenGL_GL_PREFERENCE=GLVND
#	PPSSPP_DEPENDENCIES += libglew libglu
#endif

PPSSPP_CONF_OPTS += -DVULKAN=OFF
PPSSPP_TARGET_CFLAGS += -DEGL_NO_X11=1 -DMESA_EGL_NO_X11_HEADERS=1


PPSSPP_TARGET_CFLAGS += -fpermissive

PPSSPP_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-lmali -DCMAKE_SHARED_LINKER_FLAGS=-lmali


PPSSPP_CONF_OPTS += -DCMAKE_C_FLAGS="$(PPSSPP_TARGET_CFLAGS)" -DCMAKE_CXX_FLAGS="$(PPSSPP_TARGET_CFLAGS)"

define PPSSPP_UPDATE_INCLUDES
	sed -i 's/unknown/$(PPSSPP_VERSION)/g' $(@D)/git-version.cmake
	sed -i "s+/opt/vc+$(STAGING_DIR)/usr+g" $(@D)/CMakeLists.txt
endef

PPSSPP_PRE_CONFIGURE_HOOKS += PPSSPP_UPDATE_INCLUDES

define PPSSPP_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/$(PPSSPP_TARGET_BINARY) $(TARGET_DIR)/usr/bin/PPSSPP
	mkdir -p $(TARGET_DIR)/usr/share/ppsspp
	cp -R $(@D)/assets $(TARGET_DIR)/usr/share/ppsspp/PPSSPP
endef

$(eval $(cmake-package))
