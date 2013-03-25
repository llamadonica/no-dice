dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(no_dice, 0.1)

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC


LT_INIT


dnl Check for vala
AM_PROG_VALAC([0.10.0])

AS_CASE([$host],
       [*-*-mingw32], [mingw=true],
       [mingw=false]
     )
     
AM_CONDITIONAL([MINGW_BUILD], [test x$mingw = xtrue])
     
PKG_CHECK_MODULES(NO_DICE, [gtk+-3.0 ])

AS_CASE([$host],
       [*-*-mingw32], [AC_CONFIG_FILES([ 
			dll/Makefile
			installer/pomeranian.nsi
			installer/Makefile])]
     )

AC_OUTPUT([
Makefile
src/Makefile
src/no_dice.desktop

])
