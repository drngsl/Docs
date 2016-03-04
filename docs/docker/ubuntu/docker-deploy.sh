#! /bin/bash

apt-get update
apt-get -y --force-yes install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

VERSION=14.04

if [ "$VERSION" = "12.04" ]; then
    #On Ubuntu Precise 12.04 (LTS)
    SOURCE_CONTENT="deb https://apt.dockerproject.org/repo ubuntu-precise main"
elif [ "$VERSION" = "14.04" ]; then
    #On Ubuntu Trusty 14.04 (LTS)
    SOURCE_CONTENT="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
elif [ "VERSION" = "15.10" ]; then
    #Ubuntu Wily 15.10
    SOURCE_CONTENT="deb https://apt.dockerproject.org/repo ubuntu-wily main"
else
    echo "This deploy script is not supported for you system version."
    echo "Please install Docker by yourself step by step."
fi

if [ ! -e "/etc/apt/sources.list.d" ]; then
    mkdir -p "/etc/apt/sources.list.d"
fi

echo $SOURCE_CONTENT > /etc/apt/sources.list.d/docker.list

apt-get update

apt-get purge lxc-docker

apt-cache policy docker-engine

sudo apt-get -y --force-yes install linux-image-extra-$(uname -r)
sudo apt-get -y --force-yes install linux-image-generic-lts-trusty
sudo apt-get -y --force-yes install docker-engine
sudo service docker start