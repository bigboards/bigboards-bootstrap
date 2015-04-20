#!/bin/bash
set -e

[ -z $1 ] && echo "No hex name has been given!" && exit 1

NAME=$1
RANGE=`echo 10.$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1)`

function install() {
	sudo ANSIBLE_ERROR_ON_UNDEFINED_VARS=True ansible-playbook -i myhosts -c local setup.yml --extra-vars="name=${1} range=${2} role=${3} sequence=${4}"
}

echo "Installing hex $NAME with ip range $RANGE"

read -p "Insert Storage for node 1 and press ENTER."
install $NAME $RANGE master 1

read -p "Insert Storage for node 2 and press ENTER."
install $NAME $RANGE slave 2

read -p "Insert Storage for node 3 and press ENTER."
install $NAME $RANGE slave 3

read -p "Insert Storage for node 4 and press ENTER."
install $NAME $RANGE slave 4

read -p "Insert Storage for node 5 and press ENTER."
install $NAME $RANGE slave 5

read -p "Insert Storage for node 6 and press ENTER."
install $NAME $RANGE slave 6

echo "Done!"
echo "The Hex named $NAME received internal ip address range ${RANGE}"