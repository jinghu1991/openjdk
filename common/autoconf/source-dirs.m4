#
# Copyright (c) 2011, 2016, Oracle and/or its affiliates. All rights reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Oracle designates this
# particular file as subject to the "Classpath" exception as provided
# by Oracle in the LICENSE file that accompanied this code.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
#
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
# or visit www.oracle.com if you need additional information or have any
# questions.
#

AC_DEFUN_ONCE([SRCDIRS_SETUP_TOPDIRS],
[
  # Where are the sources.
  LANGTOOLS_TOPDIR="$SRC_ROOT/langtools"
  CORBA_TOPDIR="$SRC_ROOT/corba"
  JAXP_TOPDIR="$SRC_ROOT/jaxp"
  JAXWS_TOPDIR="$SRC_ROOT/jaxws"
  HOTSPOT_TOPDIR="$SRC_ROOT/hotspot"
  NASHORN_TOPDIR="$SRC_ROOT/nashorn"
  JDK_TOPDIR="$SRC_ROOT/jdk"
  AC_SUBST(LANGTOOLS_TOPDIR)
  AC_SUBST(CORBA_TOPDIR)
  AC_SUBST(JAXP_TOPDIR)
  AC_SUBST(JAXWS_TOPDIR)
  AC_SUBST(HOTSPOT_TOPDIR)
  AC_SUBST(NASHORN_TOPDIR)
  AC_SUBST(JDK_TOPDIR)
])

AC_DEFUN_ONCE([SRCDIRS_SETUP_ALTERNATIVE_TOPDIRS],
[
  # This feature is no longer supported.

  BASIC_DEPRECATED_ARG_WITH(add-source-root)
  BASIC_DEPRECATED_ARG_WITH(override-source-root)
  BASIC_DEPRECATED_ARG_WITH(adds-and-overrides)
  BASIC_DEPRECATED_ARG_WITH(override-langtools)
  BASIC_DEPRECATED_ARG_WITH(override-corba)
  BASIC_DEPRECATED_ARG_WITH(override-jaxp)
  BASIC_DEPRECATED_ARG_WITH(override-jaxws)
  BASIC_DEPRECATED_ARG_WITH(override-hotspot)
  BASIC_DEPRECATED_ARG_WITH(override-nashorn)
  BASIC_DEPRECATED_ARG_WITH(override-jdk)
])

AC_DEFUN_ONCE([SRCDIRS_SETUP_OUTPUT_DIRS],
[
  BUILD_OUTPUT="$OUTPUT_ROOT"
  AC_SUBST(BUILD_OUTPUT)

  HOTSPOT_DIST="$OUTPUT_ROOT/hotspot/dist"
  BUILD_HOTSPOT=true
  AC_SUBST(HOTSPOT_DIST)
  AC_SUBST(BUILD_HOTSPOT)
  AC_ARG_WITH(import-hotspot, [AS_HELP_STRING([--with-import-hotspot],
  [import hotspot binaries from this jdk image or hotspot build dist dir instead of building from source])])
  if test "x$with_import_hotspot" != x; then
    CURDIR="$PWD"
    cd "$with_import_hotspot"
    HOTSPOT_DIST="`pwd`"
    cd "$CURDIR"
    if ! (test -d $HOTSPOT_DIST/lib && test -d $HOTSPOT_DIST/jre/lib); then
      AC_MSG_ERROR([You have to import hotspot from a full jdk image or hotspot build dist dir!])
    fi
    AC_MSG_CHECKING([if hotspot should be imported])
    AC_MSG_RESULT([yes from $HOTSPOT_DIST])
    BUILD_HOTSPOT=false
  fi

  JDK_OUTPUTDIR="$OUTPUT_ROOT/jdk"
])

################################################################################
# Define a mechanism for importing extra prebuilt modules
#

AC_DEFUN_ONCE([SRCDIRS_SETUP_IMPORT_MODULES],
[
  AC_ARG_WITH(import-modules, [AS_HELP_STRING([--with-import-modules],
      [import a set of prebuilt modules either as a zip file or an exploded directory])])

  if test "x$with_import_modules" != x \
      && test "x$with_import_modules" != "xno"; then
    if test -d "$with_import_modules"; then
      IMPORT_MODULES_TOPDIR="$with_import_modules"
      BASIC_FIXUP_PATH([IMPORT_MODULES_TOPDIR])
    elif test -e "$with_import_modules"; then
      IMPORT_MODULES_TOPDIR="$CONFIGURESUPPORT_OUTPUTDIR/import-modules"
      $RM -rf "$IMPORT_MODULES_TOPDIR"
      $MKDIR -p "$IMPORT_MODULES_TOPDIR"
      if ! $UNZIP -q "$with_import_modules" -d "$IMPORT_MODULES_TOPDIR"; then
        AC_MSG_ERROR([--with-import-modules="$with_import_modules" must point to a dir or a zip file])
      fi
    else
      AC_MSG_ERROR([--with-import-modules="$with_import_modules" must point to a dir or a zip file])
    fi
  fi

  if test -d "$IMPORT_MODULES_TOPDIR/modules"; then
    IMPORT_MODULES_CLASSES="$IMPORT_MODULES_TOPDIR/modules"
  fi
  if test -d "$IMPORT_MODULES_TOPDIR/modules_cmds"; then
    IMPORT_MODULES_CMDS="$IMPORT_MODULES_TOPDIR/modules_cmds"
  fi
  if test -d "$IMPORT_MODULES_TOPDIR/modules_libs"; then
    IMPORT_MODULES_LIBS="$IMPORT_MODULES_TOPDIR/modules_libs"
  fi
  if test -d "$IMPORT_MODULES_TOPDIR/modules_conf"; then
    IMPORT_MODULES_CONF="$IMPORT_MODULES_TOPDIR/modules_conf"
  fi
  if test -d "$IMPORT_MODULES_TOPDIR/modules_src"; then
    IMPORT_MODULES_SRC="$IMPORT_MODULES_TOPDIR/modules_src"
  fi
  if test -d "$IMPORT_MODULES_TOPDIR/make"; then
    IMPORT_MODULES_MAKE="$IMPORT_MODULES_TOPDIR/make"
  fi

  AC_SUBST(IMPORT_MODULES_CLASSES)
  AC_SUBST(IMPORT_MODULES_CMDS)
  AC_SUBST(IMPORT_MODULES_LIBS)
  AC_SUBST(IMPORT_MODULES_CONF)
  AC_SUBST(IMPORT_MODULES_SRC)
  AC_SUBST(IMPORT_MODULES_MAKE)
])
