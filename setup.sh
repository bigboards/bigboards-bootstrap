#!/bin/bash
[ -z $1 ] && echo "No role has been given!" && exit 1
[ -z $2 ] && echo "No sequence has been given!" && exit 1

sudo ANSIBLE_ERROR_ON_UNDEFINED_VARS=True ansible-playbook -i myhosts -c local setup.yml --extra-vars="role=${1} sequence=${2}"
