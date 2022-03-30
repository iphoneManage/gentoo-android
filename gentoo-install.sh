#!/bin/bash
pkg install proot
export GENTOO=/data/data/com.termux/gentoo
mkdir -p $GENTOO/data
curl -LO http://distfiles.gentoo.org/experimental/prefix/arm/prefix-stage3-arm64-20200704.tar.xz
proot --link2symlink tar -C $GENTOO/data -xf prefix-stage3-arm64-20200704.tar.xz

wget https://raw.githubusercontent.com/rushia727/gentoo-android/main/start-gentoo.sh
chmod +x start-gentoo.sh

unset LD_PRELOAD
export GENTOO=/data/data/com.termux/gentoo
export EPREFIX=/data/gentoo64

proot --link2symlink -r $GENTOO -0 -w / \
    -b /dev -b /proc -b /sys \
    $EPREFIX/bin/sh -c \
    "HOME=$EPREFIX/root $EPREFIX/startprefix"

export EPREFIX=/data/gentoo64
mkdir $EPREFIX/etc/portage/repos.conf
cat $EPREFIX/usr/share/portage/config/repos.conf > $EPREFIX/etc/portage/repos.conf/gentoo.conf
emerge-webrsync
emerge --ask --verbose --update --deep --newuse @world
