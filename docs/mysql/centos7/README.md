CentOS7下安装mysql
==================

下载与安装
----------

# wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
# rpm -ivh mysql-community-release-el7-5.noarch.rpm
# yum install mysql-community-server


安装成功后重启mysql服务
-----------------------

# service mysqld restart


初次安装mysql，root账户没有密码
-------------------------------

# mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.40 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)

mysql>

设置密码
--------

mysql> set password for 'root'@'localhost'=password('password');
Query OK, 0 rows affected (0.00 sec)

mysql> exit
Bye

配置编码格式
------------

mysql> default-character-set =utf8
    -> 

设置允许远程连接
----------------

mysql> grant all privileges on *.* to root@'%'identified by 'password';
Query OK, 0 rows affected (0.00 sec)

mysql>


如果允许root账号远程连接要对系统数据库的root账户设置远程访问的密码，与本地的root访问密码并不冲突。
-------------------------------------------------------------------------------------------------

1 grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option; #123456为你需要设置的密码

