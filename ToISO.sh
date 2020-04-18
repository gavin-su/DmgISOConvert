#!/bin/bash

if [ $# != 2 ] ; then
    echo "USAGE: $0 macos dmg_path"
    echo " e.g.: $0 Catalina /tmp/Catalina.dmg"
    exit 1;
fi

MACOS=$1
DMGPATH=$2

hdiutil create -o /tmp/${MACOS} -size 9000m -layout SPUD -fs HFS+J

hdiutil attach ${DMGPATH} -noverify -mountpoint /Volumes/install_build

#sudo /Applications/Install\ macOS\ ${MACOS}.app/Contents/Resources/createinstallmedia --volume /Volumes/install_build
sudo /Volumes/install_build/Install\ macOS\ ${MACOS}.app/Contents/Resources/createinstallmedia --volume /Volumes/install_build

#hdiutil detach /Volumes/Install\ macOS\ ${MACOS}
hdiutil detach /Volumes/install_build

hdiutil convert ${DMGPATH} -format UDTO -o ~/Downloads/${MACOS}

mv ~/Downloads/${MACOS}.cdr ~/Downloads/${MACOS}.iso
