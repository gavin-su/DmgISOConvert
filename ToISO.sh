#!/bin/bash

if [ $# != 3 ] ; then
    echo "USAGE: $0 macos dmg_file out_dir"
    echo " e.g.: $0 Catalina ~/Downloads/Catalina.dmg ~/Downloads"
    exit 1;
fi

MACOS=$1
DMGFILE=$2
OUTDIR=$3

hdiutil create -o /tmp/${MACOS} -size 9000m -volume ${MACOS} -layout SPUD -fs HFS+J
TMPFILE="/tmp/${MACOS}.dmg"
hdiutil attach ${TMPFILE} -noverify -mountpoint /Volumes/${MACOS}

hdiutil attach ${DMGFILE} -mountpoint /Volumes/os
APP=`ls -1 /Volumes/os | grep \.app`

#sudo /Volumes/os/${APP}/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume --applicationpath /Applications/Install\ OS\ X\ El\ Capitan.app
#sudo /Volumes/os/${APP}/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume --applicationpath /Applications/Install\ macOS\ Sierra.app
sudo /Volumes/os/${APP}/Contents/Resources/createinstallmedia --volume /Volumes/${MACOS} --nointeraction

hdiutil detach /Volumes/Install\ macOS\ ${MACOS}

hdiutil detach /Volumes/os

hdiutil convert ${TMPFILE} -format UDTO -o ${OUTDIR}/${MACOS}.cdr

mv ${OUTDIR}/${MACOS}.cdr ${OUTDIR}/${MACOS}.iso
rm ${TMPFILE}
