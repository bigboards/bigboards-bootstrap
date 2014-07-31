#!/bin/sh
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:rquillo/ansible
sudo add-apt-repository -y "deb http://apt.bigboards.io/repo binary/"
sudo apt-get update
sudo apt-get -y --force-yes install ansible
sudo apt-get -y --force-yes install bigboards-updater