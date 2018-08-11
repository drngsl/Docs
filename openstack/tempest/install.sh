#!/bin/bash

set -x

yum -y install epel-release
yum clean all && yum list && yum repolist all
yum install -y gcc git libxslt-devel openssl-devel libffi-devel python-devel python-pip python-virtualenv
pip install junitxml

git clone https://github.com/Hybrid-Cloud/tempest.git
cd tempest && python setup.py install
pip install -r requirements.txt

pip install tox
tox -egenconfig
cp etc/{tempest.conf.sample,tempest.conf}
