## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = no_dice.ui \
	applications-boardgames.svg


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
	--pkg gtk+-3.0

no_dice_LDFLAGS = \
	-Wl,--export-dynamic

no_dice_LDADD = $(NO_DICE_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

