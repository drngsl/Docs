===============================
fuxi
===============================

Enable Docker container to use Cinder volume and Manila share

Fuxi focuses on enabling Docker container to use Cinder volume and Manila
share, thus Docker volume can reuse the advance features and numerous vendor
drivers in Cinder and Manila. With Fuxi, Cinder and Manila can be used as
the unified persistence storage provider for virtual machine, baremetal
and Docker container.

* Free software: Apache license
* Documentation: http://docs.openstack.org/developer/fuxi
* Source: http://git.openstack.org/cgit/openstack/fuxi
* Bugs: http://bugs.launchpad.net/Fuxi

Features
--------

* TODO


Prerequisites
-------------

* Maybe you need to install some of the following packages.

* And you need to install requirements.

::

    sudo pip install -r requirements.txt`


If fuxi-server run with a common user, it is expected to enable fuxi to execute some Linux command without password interact.

Installing Fuxi
---------------

::

    python setup.py install

Configuring Fuxi
----------------

After install Fuxi, there will generate a configuration file fuxi.conf in /etc/fuxi. Edit it according to you requiremnts.

* Default section

::

    my_ip = MY_IP # The IP of host that Fuxi deployed on
    volume_provider # The enable volume provider for Fuxi

* Keystone section

::

    region = Region
    auth_url = AUTH_URL
    admin_user = ADMIN_USER
    admin_password = ADMIN_PASSWORD
    admin_tenant_name = ADMIM_TENANT_NAME

* Cinder section

::

    volume_connector = osbrick # How to connect to Cinder volume
    protocol = iscsi # If volume_connector = osbirck, this is needed
    fstype = FSTYPE # Default filesystem type to format, if not provided from reques

Running Fuxi
------------

::

    fuxi-server --config-file /etc/fuxi/fuxi.conf



Testing Fuxi
------------

::

    $ docker volume create --driver fuxi --name tst_vol --opts size=1 --opts fstype=ext4
    $ docker volume ls

