## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src 

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
