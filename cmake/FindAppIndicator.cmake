include(PkgConfigWithFallback)
find_pkg_config_with_fallback(AppIndicator
    PKG_CONFIG_NAME appindicator3-0.1
    LIB_NAMES appindicator3-0.1
    INCLUDE_NAMES indicator.h
    INCLUDE_DIR_SUFFIXES libindicator
    DEPENDS Gtk
)
