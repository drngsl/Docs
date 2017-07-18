#!/bin/bash

set -x

sudo yum install docker
sudo service docker start
sudo chkconfig docker on

config_docker_register() {
    sudo sed -i 's|other_args="|other_args="--registry-mirror=http://768e1313.m.daocloud.io |g'/etc/sysconfig/docker
    sudo sed-i"s|OPTIONS='|OPTIONS='--registry-mirror=http://768e1313.m.daocloud.io |g"
    sudo sed-i'N;s|\[Service\]\n|\[Service\]\nEnvironmentFile=-/etc/sysconfig/docker\n|g'/usr/lib/systemd/system/docker.service
    sudo sed-i's|fd://|fd:// $other_args |g'.service
    sudo systemctl daemon-reload
    sudo service docker restart
}

sudo docker pull centos:latest
