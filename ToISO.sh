#!/bin/bash

if [ $# != 3 ] ; then
    echo "USAGE: $0 macos dmg_file out_dir"
    echo " e.g.: $0 Catalina ~/Downloads/Catalina.dmg ~/Downloads"
    exit 1;
fi

MACOS=$1
DMGFILE=$2
OUTDIR=$3

#check
case "${MACOS}" in
    Catalina)
    ;;
    Mojave)
    ;;
    "High Sierra")
    ;;
    Sierra)
    ;;
    "El Capitan")
    ;;
    Yosemite)
    ;;
    *)
    echo "ERROR!!! THIS MACOS IS NOT SUPPORT!!!"
    exit 1;
esac

if [ ! -e "${DMGFILE}" ]
then
    echo "ERROR!!! "${DMGFILE}" NOT FOUND!!!"
    exit 1;
fi

if [ ! -d "${OUTDIR}" ]
then
    echo "ERROR!!! "${OUTDIR}" NOT FOUND!!!"
    exit 1;
fi

#convert
hdiutil create -o "/tmp/${MACOS}" -size 9000m -layout SPUD -fs HFS+J
TMPFILE="/tmp/${MACOS}.dmg"
hdiutil attach "${TMPFILE}" -noverify -mountpoint "/Volumes/${MACOS}"

hdiutil attach "${DMGFILE}" -mountpoint /Volumes/os
APP=`ls -1 /Volumes/os | grep \.app | grep Install`


case "${MACOS}" in
    Sierra)
    sudo "/Volumes/os/${APP}/Contents/Resources/createinstallmedia"  --volume "/Volumes/${MACOS}" --applicationpath "/Volumes/os/${APP}" --nointeraction
    ;;
    "El Capitan")
    sudo "/Volumes/os/${APP}/Contents/Resources/createinstallmedia"  --volume "/Volumes/${MACOS}" --applicationpath "/Volumes/os/${APP}" --nointeraction
    ;;
    Yosemite)
    sudo "/Volumes/os/${APP}/Contents/Resources/createinstallmedia"  --volume "/Volumes/${MACOS}" --applicationpath "/Volumes/os/${APP}" --nointeraction
    ;;
    *)
    sudo "/Volumes/os/${APP}/Contents/Resources/createinstallmedia"  --volume "/Volumes/${MACOS}" --nointeraction
    ;;
esac

INSTVOL=`ls -1 /Volumes | grep Install | grep "${MACOS}"`
hdiutil detach "/Volumes/${INSTVOL}"
hdiutil detach /Volumes/os

hdiutil convert "${TMPFILE}" -format UDTO -o "${OUTDIR}/${MACOS}.cdr"
mv "${OUTDIR}/${MACOS}.cdr" "${OUTDIR}/${MACOS}.iso"

#clean
rm "${TMPFILE}"
