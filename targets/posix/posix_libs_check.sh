#!/bin/bash

bold=`tput bold`
normal=`tput sgr0`

NEEDED_APPS="wget"

MACHINE_TYPE=`uname -m`

file=".packages_check_ok"

if [ -f "$file" ]
then
	rm $file
fi

for lib in ${NEEDED_LIBRARIES} ; do
    if ! dpkg -s ${lib} | grep Status &> /dev/null ; then
	echo
        echo -e "\e[1;31m${bold}Error${normal}:\e[0m Please install library ${bold}${lib}${normal}!"
	echo
        exit 1
    fi
done

for cmd in ${NEEDED_APPS} ; do
    if ! command -v ${cmd} &> /dev/null ; then
	echo
	echo -e "\e[1;31m${bold}Error${normal}:\e[0m Please install package with ${bold}${cmd}${normal}"
	echo
	exit 1
    fi
done

touch $file
