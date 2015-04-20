#!/bin/bash
set -e

[ -z $1 ] && echo "No hex name has been given!" && exit 1
[ -z $1 ] && echo "No hex size has been given!" && exit 1

NAME=$1
SIZE=$2

RANGE=`echo 10.$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1)`

function install() {
	sudo ANSIBLE_ERROR_ON_UNDEFINED_VARS=True ansible-playbook -i myhosts -c local setup.yml --extra-vars="name=${1} range=${2} role=${3} sequence=${4}"
}

echo "Installing hex $NAME with $SIZE nodes and ip range $RANGE"

for i in $(seq 1 $SIZE); 
do 
	read -p "Insert Storage for node $i and press ENTER."

	if [ "$i" -eq "1" ]; 
	then
		install $NAME $RANGE master $i
	else 
		install $NAME $RANGE slave $i
	fi
done

echo "Done!"
echo "The Hex named $NAME received internal ip address range ${RANGE}"