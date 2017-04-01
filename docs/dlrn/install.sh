#!/usr/bin/env bash

set -x

sudo yum install git createrepo python-virtualenv mock gcc redhat-rpm-config rpmdevtools httpd

initUser() {
    adduser --shell /bin/bash --home /home/dlrn dlrn
    usermod -a -G mock dlrn
    newgrp mock
    newgrp dlrn
}

sudo systemctl start httpd

cd /home/dlrn
git clone https://github.com/openstack-packages/DLRN.git && cd DLRN && pip install -U -r requirements.txt && python setup.py install && cd ..
git clone https://github.com/redhat-openstack/rdoinfo.git
git clone https://github.com/openstack-packages/rdopkg && cd rdopkg && pip install -U -r requirements.txt && python setup.py install && cd ..

chown -R dlrn:dlrn DLRN
chown -R dlrn:dlrn rdoinfo
chown -R dlrn:dlrn rdopkg
