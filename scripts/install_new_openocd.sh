#!/bin/bash

LINK=`curl http://sourceforge.net/projects/openocd/files/latest/download | grep -o -e 'http://downloads.sourceforge.net/project/openocd/openocd/.\{1,200\}'`
cd tools
wget $LINK -O openocd.tar.bz2
if [ -d "openocd" ]; then
  rm -r -f openocd
fi
tar -xvf openocd.tar.bz2
rm openocd.tar.bz2
mv openocd* openocd
cd openocd
./configure
make
if [ ! -e "/etc/udev/rules.d/99-openocd.rules" ]; then
  echo "Copying udev rules for openocd. It requiers superuser privileges."
  sudo cp contrib/99-openocd.rules /etc/udev/rules.d/99-openocd.rules
  sudo udevadm control --reload-rules
fi
