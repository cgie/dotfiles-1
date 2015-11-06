#!/bin/bash

# SafeInstall v0.3 - Slackware package builder
# by davide aka bash 2005
# http://neutronstar.cjb.net
#
# DESCRIPTION
#
# Compiling a linux software from source is easy: most of the times you

# just need to type:
#
# ./configure
# make
# su 
# make install
#
# The last command installs all the files in your system. Unfortunately,
# only a few program's authors add an uninstall rule to their Makefile,

# so removing the software isn't easy.
#
# SafeInstall takes the place of "make install", but instead of installing
# it builds a Slackware package, which can be installed with "installpkg"

# and removed with "removepkg". This way the system remains "clean".
#
# SafeInstall executes "make install" with normal user permissions,
# redirecting the installation to a temporary directory in the user's

# home, from which the package is built. Without root permissions, the
# "make install" can't mess up the system with files installed anywhere.
#
# SafeInstall needs root permission just for setting package files and

# directories permissions.
#
# Before creating the package you can manually modify the package content
# (e.g. removing locales, man pages, ...).
#
# The package will be saved in your home directory, and at the same time

# two files will be created:  "<packagename>.log" e "<packagename>.err",
# containing installation details.
#
# HISTORY
#
# 0.1 First public release.
# 0.2 Added "destdir" string grep into Makefile, for checking DESTDIR support.

# 0.3 Force "make DESTDIR= install" if requested.
#
# LICENCE
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by

# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of

# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

OUTDIR=$HOME
PKG="$HOME/tmppkg"

CURDIR=`pwd`
PKGNAME="`basename \"$CURDIR\"`"


echo
echo -- SafeInstall v0.3 - Slackware package builder
echo -- by davide aka bash 2005
echo -- http://neutronstar.cjb.net

echo
echo "-- Building package: $PKGNAME.tgz"

echo

rm -r $PKG > /dev/null 2>&1
echo "-- Creating temporary directory..."
if [ -d "$PKG" ]; then
    echo "Could not delete $PKG, please delete it manually."
    echo

    exit
else
    mkdir $PKG
fi

echo
TESTDESTDIR=`cat Makefile | grep --ignore-case destdir`
if [ "$TESTDESTDIR" == "" ]; then
    echo "-- Makefile DOESN'T seem to offer DESTDIR support."

    echo "-- Enter install command (e.g. \"make prefix=$PKG/usr install\")"
    echo "-- or just hit ENTER to run \"make DESTDIR=$PKG install\" anyway."
    echo "-- To quit now press CTRL-C."

    read -p "-- " MAKECMD
    if [ "$MAKECMD" == "" ]; then
	make DESTDIR=$PKG install > $OUTDIR/$PKGNAME.log 2>$OUTDIR/$PKGNAME.err
    else
	echo
	echo "-- Executing \"$MAKECMD\"..."

	$MAKECMD > $OUTDIR/$PKGNAME.log
    fi
else
    echo "-- Makefile seems to offer DESTDIR support."
    echo "-- Executing \"make DESTDIR=$PKG install\"..."
    make DESTDIR=$PKG install > $OUTDIR/$PKGNAME.log 2>$OUTDIR/$PKGNAME.err

fi

echo
echo "-- Stripping binaries..."
find $PKG | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null
find $PKG | xargs file | grep "shared object" | grep ELF | cut -f1 -d : | xargs strip --strip-unneeded 2> /dev/null

find $PKG | xargs file | grep "current ar archive" | cut -f 1 -d  : | xargs strip -g 2> /dev/null

echo
echo "-- Compressing manual and info pages..."
for DIR in `find $PKG -type d -name 'man?' -print`; do cd $DIR && gzip -9 *; done

for DIR in `find $PKG -type d -name 'info' -print`; do cd $DIR && gzip -9 *; done

cd $PKG
echo
echo "-- If needed, modify NOW \"$PKG\" directory content"
echo "-- (file and dir permissions will be set later on),"

echo -n "-- then hit ENTER to start creating package, or CTRL-C to quit."
read
echo
echo "-- Please insert root password for setting up correct permissions."
echo -n "-- "
su -c "chown -R root.root $PKG/* && \

find $PKG -type d -name bin -exec chown -R root.bin {} \; && \
/sbin/makepkg -l y -c n $OUTDIR/$PKGNAME.tgz > /dev/null 2>&1 && \
rm -r $PKG"

echo
echo "-- \"$OUTDIR/$PKGNAME.tgz\" successfully created."

echo "-- Install it with \"installpkg $PKGNAME.tgz\"."
echo "-- Check \"$PKGNAME.log\" and \"$PKGNAME.err\" for details."
echo