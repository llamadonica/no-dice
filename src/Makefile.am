## Process this file with automake to produce Makefile.in

## Created by Anjuta


if MINGW_BUILD
MINGW_FLAG = -D MINGW_BUILD
MINGW_EXTRA_LDFLAG = -Wl,--export-all-symbols
else
MINGW_FLAG = 
MINGW_EXTRA_LDFLAG = -Wl,--export-dynamic
endif

uidir = $(pkgdatadir)/ui
ui_DATA = no_dice.ui

desktopdir = $(datadir)/applications
desktop_in_files = no_dice.desktop.in		
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

icondir = $(datadir)/pixmaps
icon_DATA = no_dice.svg

AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(NO_DICE_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = no_dice

no_dice_SOURCES = \
	no_dice.vala config.vapi

no_dice_VALAFLAGS =  \
	--pkg gtk+-3.0 \
	 $(MINGW_FLAG)

no_dice_LDFLAGS = \
	$(MINGW_EXTRA_LDFLAG)

no_dice_LDADD = $(NO_DICE_LIBS)

EXTRA_DIST = $(ui_DATA) $(icon_DATA) $(desktop_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

