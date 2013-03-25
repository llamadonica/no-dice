dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(no_dice, 0.1)

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

LT_INIT


dnl Check for vala
AM_PROG_VALAC([0.10.0])

dnl Checking for ImageMagick
AC_ARG_VAR(CONVERT_PROG)

dnl Checking whether build is for MingW
AS_CASE([$host],
       [*-*-mingw32], [mingw=true],
       [mingw=false]
     )

if test x$mingw = xtrue; then
  if test -z "$CONVERT_PROG"; then
    AC_PATH_PROG(CONVERT_PROG,convert)
  fi
fi
     
AM_CONDITIONAL([MINGW_BUILD], [test x$mingw = xtrue])
     
PKG_CHECK_MODULES(NO_DICE, [gtk+-3.0 ])

AS_CASE([$host],
       [*-*-mingw32], [AC_CONFIG_FILES([ 
			dll/Makefile
			installer/no-dice.nsi
			installer/Makefile])]
     )

AC_OUTPUT([
Makefile
src/Makefile
src/no_dice.desktop

])
