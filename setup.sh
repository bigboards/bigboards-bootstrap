#!/bin/bash

getopts "e:" EXTRA_ARGS
if [ "$OPTARG" != "" ]; then
  echo "Running with extra args: ${OPTARG}"
  sudo ANSIBLE_ERROR_ON_UNDEFINED_VARS=True ansible-playbook -i myhosts -c local -v -e "$OPTARG" prepare.yml
else
  sudo ANSIBLE_ERROR_ON_UNDEFINED_VARS=True ansible-playbook -i myhosts -c local -v prepare.yml
fi
