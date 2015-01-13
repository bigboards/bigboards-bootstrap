#!/bin/bash
set -e

[ -z $1 ] && echo "No sequence has been given!" && exit 1
[[ ! $1 =~ ^-?[0-9]+$ ]] && echo "Sequence must be an integer!" && exit 1

[[ $1 -eq 1 ]] && role="master"
[[ $1 -gt 1 ]] && role="slave"

[ -z $role ] && echo "No role was derived! Sequence must be an integer greater than 1" && exit 1
#echo $role

sudo ANSIBLE_ERROR_ON_UNDEFINED_VARS=True ansible-playbook -i myhosts -c local setup.yml --extra-vars="role=${role} sequence=${1}"
