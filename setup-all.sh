#!/bin/bash
set -e

#[ -z $1 ] && echo "No hex name has been given!" && exit 1
#[ -z $2 ] && echo "No hex architecture has been given!" && exit 1

echo "Enter the name of the hex:"
read NAME

echo "Enter the hex architecture [arm or intel|:"
read ARCH

RANGE=`echo 10.$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1)`
echo "Enter the network range or press enter to use $RANGE:"
read RANGE_ATTEMPT
[ "${RANGE_ATTEMPT}" != "" ] && RANGE="${RANGE_ATTEMPT}"

if [[ "$ARCH" != "intel" ]] && [[ "$ARCH" != "arm" ]]; 
then 
	echo "Hex architecture should be 'intel' or 'arm'" 
	exit 1
fi

function install() {
	sudo ANSIBLE_ERROR_ON_UNDEFINED_VARS=True ansible-playbook -i myhosts -c local setup.yml --extra-vars="name=${1} arch=${2} range=${3} role=${4} sequence=${5}"
}

echo "Installing hex $NAME with ip range $RANGE"


while true; do
	echo "Insert Storage and enter the node sequence or [CTRL-C] to quit:"
	read NODE_SEQUENCE

	if [ "$NODE_SEQUENCE" -eq "1" ]; 
	then
		install $NAME $ARCH $RANGE master $NODE_SEQUENCE
	else 
		install $NAME $ARCH $RANGE slave $NODE_SEQUENCE
	fi
done

echo "Done!"
echo "The Hex named $NAME received internal ip address range ${RANGE}"
