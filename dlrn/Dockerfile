FROM centos:latest

RUN yum install -y git createrepo python-virtualenv mock gcc redhat-rpm-config rpmdevtools httpd && \
    yum -y install epel-release && yum install -y python-pip && \
    yum clean all && yum -y autoremove

RUN adduser --shell /bin/bash --home /home/dlrn dlrn && \
    usermod -a -G mock dlrn && \
    newgrp mock && \
    newgrp dlrn

# Install dlrn
WORKDIR /home/dlrn

RUN git clone https://github.com/openstack-packages/DLRN.git && \
    git clone https://github.com/redhat-openstack/rdoinfo.git && \
    git clone https://github.com/openstack-packages/rdopkg.git && \
    pip install --upgrade pip setuptools && \
    pip install DLRN/ rdopkg/ && \
    chown -R dlrn:dlrn *

WORKDIR /home/dlrn/DLRN
USER dlrn

CMD ["/bin/bash"]
