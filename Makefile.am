## Process this file with automake to produce Makefile.in
## Created by Anjuta

if MINGW_BUILD
DLLDIR = dll \
	installer
else
DLLDIR =
endif

SUBDIRS = src  \
	$(DLLDIR)

no_dicedocdir = ${prefix}/doc/no_dice
no_dicedoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(no_dicedoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(no_dicedocdir)
