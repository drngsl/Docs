## Centos7.2安装MariaDB

`原文： https://www.jianshu.com/p/a0c4147d4925`

### 1.检查是否已经具有MariaDB相关安装，并删除已有安装

```bash
[root@hadoop01 home]# rpm -qa|grep mariadb  #查询已安装包
mariadb-libs-5.5.52-1.el7.x86_64
```

```bash
[root@hadoop01 home]# rpm -e --nodeps mariadb-*   # 移除已安装包
错误：未安装软件包 mariadb-* 
```

```bash
[root@hadoop01 home]# yum remove mysql mysql-server mysql-libs compat-mysql51   # 删除Mysql服务
已加载插件：fastestmirror, langpacks
参数 mysql 没有匹配
参数 mysql-server 没有匹配
参数 compat-mysql51 没有匹配
正在解决依赖关系
--> 正在检查事务
---> 软件包 mariadb-libs.x86_64.1.5.5.52-1.el7 将被 删除
--> 正在处理依赖关系 libmysqlclient.so.18()(64bit)，它被软件包 2:postfix-2.10.1-6.el7.x86_64 需要
--> 正在处理依赖关系 libmysqlclient.so.18(libmysqlclient_18)(64bit)，它被软件包 2:postfix-2.10.1-6.el7.x86_64 需要
--> 正在检查事务
---> 软件包 postfix.x86_64.2.2.10.1-6.el7 将被 删除
  > 解决依赖关系完成
▽ase/7/x86_64                                                                                                                                                                                                        | 3.6 kB  00:00:00     
extras/7/x86_64                                                                                                                                                                                                      | 3.4 kB  00:00:00     
updates/7/x86_64                                                                                                                                                                                                     | 3.4 kB  00:00:00     

依赖关系解决

============================================================================================================================================================================================================================================
 Package                                                    架构                                                 版本                                                         源                                                       大小
============================================================================================================================================================================================================================================
正在删除:
 mariadb-libs                                               x86_64                                               1:5.5.52-1.el7                                               @anaconda                                               4.4 M
为依赖而移除:
 postfix                                                    x86_64                                               2:2.10.1-6.el7                                               @anaconda                                                12 M

事务概要
============================================================================================================================================================================================================================================
移除  1 软件包 (+1 依赖软件包)

安装大小：17 M
是否继续？[y/N]：y
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  正在删除    : 2:postfix-2.10.1-6.el7.x86_64                                                                                                                                                                                           1/2 
  正在删除    : 1:mariadb-libs-5.5.52-1.el7.x86_64                                                                                                                                                                                      2/2 
  验证中      : 2:postfix-2.10.1-6.el7.x86_64                                                                                                                                                                                           1/2 
  验证中      : 1:mariadb-libs-5.5.52-1.el7.x86_64                                                                                                                                                                                      2/2 

删除:
  mariadb-libs.x86_64 1:5.5.52-1.el7                                                                                                                                                                                                        

作为依赖被删除:
  postfix.x86_64 2:2.10.1-6.el7                                                                                                                                                                                                             

完毕！
```

### 2.增加MariaDB的仓库源

```bash
[root@hadoop01 home]#vi /etc/yum.repos.d/MariaDB.repo   增加MariaDB的数据库镜像信息
# MariaDB 10.2 CentOS repository list - created 2017-12-26 06:46 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```

文件信息请参考[https://downloads.mariadb.org/mariadb/repositories/#mirror=tuna] 设置具体需要安装的版本，本文下载MariaDB10.2稳定版。

### 3.安装MariaDB

```bash
[root@localhost ~]# yum -y install MariaDB-server MariaDB-client
已加载插件：fastestmirror, langpacks
mariadb                                                                                                                                                                                                              | 2.9 kB  00:00:00     
mariadb/primary_db                                                                                                                                                                                                   |  21 kB  00:00:01     
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * extras: mirrors.sohu.com
 * updates: mirrors.aliyun.com
正在解决依赖关系
--> 正在检查事务
---> 软件包 MariaDB-client.x86_64.0.10.2.11-1.el7.centos 将被 安装
--> 正在处理依赖关系 MariaDB-common，它被软件包 MariaDB-client-10.2.11-1.el7.centos.x86_64 需要
---> 软件包 MariaDB-server.x86_64.0.10.2.11-1.el7.centos 将被 安装
--> 正在处理依赖关系 perl(DBI)，它被软件包 MariaDB-server-10.2.11-1.el7.centos.x86_64 需要
--> 正在处理依赖关系 galera，它被软件包 MariaDB-server-10.2.11-1.el7.centos.x86_64 需要
--> 正在检查事务
---> 软件包 MariaDB-common.x86_64.0.10.2.11-1.el7.centos 将被 安装
--> 正在处理依赖关系 MariaDB-compat，它被软件包 MariaDB-common-10.2.11-1.el7.centos.x86_64 需要
---> 软件包 galera.x86_64.0.25.3.22-1.rhel7.el7.centos 将被 安装
--> 正在处理依赖关系 libboost_program_options.so.1.53.0()(64bit)，它被软件包 galera-25.3.22-1.rhel7.el7.centos.x86_64 需要
---> 软件包 perl-DBI.x86_64.0.1.627-4.el7 将被 安装
--> 正在处理依赖关系 perl(RPC::PlServer) >= 0.2001，它被软件包 perl-DBI-1.627-4.el7.x86_64 需要
--> 正在处理依赖关系 perl(RPC::PlClient) >= 0.2000，它被软件包 perl-DBI-1.627-4.el7.x86_64 需要
--> 正在检查事务
---> 软件包 MariaDB-compat.x86_64.0.10.2.11-1.el7.centos 将被 安装
---> 软件包 boost-program-options.x86_64.0.1.53.0-27.el7 将被 安装
---> 软件包 perl-PlRPC.noarch.0.0.2020-14.el7 将被 安装
--> 正在处理依赖关系 perl(Net::Daemon) >= 0.13，它被软件包 perl-PlRPC-0.2020-14.el7.noarch 需要
--> 正在处理依赖关系 perl(Net::Daemon::Test)，它被软件包 perl-PlRPC-0.2020-14.el7.noarch 需要
--> 正在处理依赖关系 perl(Net::Daemon::Log)，它被软件包 perl-PlRPC-0.2020-14.el7.noarch 需要
--> 正在处理依赖关系 perl(Compress::Zlib)，它被软件包 perl-PlRPC-0.2020-14.el7.noarch 需要
--> 正在检查事务
---> 软件包 perl-IO-Compress.noarch.0.2.061-2.el7 将被 安装
--> 正在处理依赖关系 perl(Compress::Raw::Zlib) >= 2.061，它被软件包 perl-IO-Compress-2.061-2.el7.noarch 需要
--> 正在处理依赖关系 perl(Compress::Raw::Bzip2) >= 2.061，它被软件包 perl-IO-Compress-2.061-2.el7.noarch 需要
---> 软件包 perl-Net-Daemon.noarch.0.0.48-5.el7 将被 安装
--> 正在检查事务
---> 软件包 perl-Compress-Raw-Bzip2.x86_64.0.2.061-3.el7 将被 安装
---> 软件包 perl-Compress-Raw-Zlib.x86_64.1.2.061-4.el7 将被 安装
--> 解决依赖关系完成

依赖关系解决

============================================================================================================================================================================================================================================
 Package                                                         架构                                           版本                                                                  源                                               大小
============================================================================================================================================================================================================================================
正在安装:
 MariaDB-client                                                  x86_64                                         10.2.11-1.el7.centos                                                  mariadb                                          48 M
 MariaDB-server                                                  x86_64                                         10.2.11-1.el7.centos                                                  mariadb                                         110 M
为依赖而安装:
 MariaDB-common                                                  x86_64                                         10.2.11-1.el7.centos                                                  mariadb                                         154 k
 MariaDB-compat                                                  x86_64                                         10.2.11-1.el7.centos                                                  mariadb                                         2.8 M
 boost-program-options                                           x86_64                                         1.53.0-27.el7                                                         base                                            156 k
 galera                                                          x86_64                                         25.3.22-1.rhel7.el7.centos                                            mariadb                                         8.0 M
 perl-Compress-Raw-Bzip2                                         x86_64                                         2.061-3.el7                                                           base                                             32 k
 perl-Compress-Raw-Zlib                                          x86_64                                         1:2.061-4.el7                                                         base                                             57 k
 perl-DBI                                                        x86_64                                         1.627-4.el7                                                           base                                            802 k
 perl-IO-Compress                                                noarch                                         2.061-2.el7                                                           base                                            260 k
 perl-Net-Daemon                                                 noarch                                         0.48-5.el7                                                            base                                             51 k
 perl-PlRPC                                                      noarch                                         0.2020-14.el7                                                         base                                             36 k

事务概要
============================================================================================================================================================================================================================================
```

等待下载完成,下载完成后会自动安装。

### 4.MariaDB服务管理

```bash
[root@hadoop01 home]# systemctl start mariadb               # 开启数据库服务
[root@hadoop01 home]# systemctl enable mariadb              # 开机自启动
[root@hadoop01 home]# systemctl restart mariadb             # 重启服务      
[root@hadoop01 home]# systemctl status mariadb              #查看数据库状态
[root@hadoop01 home]# systemctl stop mariadb.service        # 停止数据库服务
```

### 5.数据库登录

```bash
[root@hadoop01 home]# mysql -uroot
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.2.11-MariaDB MariaDB Server

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> 
```

### 6.设置数据库密码

```bash
[root@hadoop01 home]# mysql_secure_installation    #初始化密码

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none):    #输入当前密码，一般没设置直接回车
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] y           #是否设置root密码，输入y
New password:                            #输入新密码
Re-enter new password:             #重复密码   
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n]            #删除匿名用户  y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n]        #禁止root远程登录
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n]     #是否删除test数据库
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n]        #是否重新加载权限表
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

测试登录

```bash
[root@hadoop01 home]# mysql -uroot -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 22
Server version: 10.2.11-MariaDB MariaDB Server

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> 
```

### 7.配置MariaDB数据库字符集

```bash
[root@hadoop01 home]# cd /etc/my.cnf.d/
[root@hadoop01 my.cnf.d]# ls
enable_encryption.preset  mysql-clients.cnf  server.cnf
[root@hadoop01 my.cnf.d]# vim server.cnf 
```

(1).在server.cnf 文件在[mysqld]标签下增加以下信息：

```text
init_connect='SET collation_connection = utf8_unicode_ci' 
init_connect='SET NAMES utf8' 
character-set-server=utf8 
collation-server=utf8_unicode_ci 
skip-character-set-client-handshake
```

(2).在mysql-clients.cnf 文件[mysql]标签下增加如下信息：

```text
default-character-set=utf8
```

全部配置完成后重启数据库服务

```bash
[root@hadoop01 my.cnf.d]# systemctl restart mariadb
```

之后进入MariaDB查看字符集

```bash
[root@hadoop01 my.cnf.d]# systemctl restart mariadb
[root@hadoop01 my.cnf.d]# mysql -uroot -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 9
Server version: 10.2.11-MariaDB MariaDB Server

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show variables like "%character%";show variables like "%collation%";
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.00 sec)

+----------------------+-----------------+
| Variable_name        | Value           |
+----------------------+-----------------+
| collation_connection | utf8_unicode_ci |
| collation_database   | utf8_unicode_ci |
| collation_server     | utf8_unicode_ci |
+----------------------+-----------------+
3 rows in set (0.00 sec)

MariaDB [(none)]> 
```

字符集配置完成

### 8.创建用户、添加授权

(1).创建用户

```bash
MariaDB [(none)]> create user  hadoop@localhost identified by 'xxxx';  #请替换xx为密码
Query OK, 0 rows affected (0.01 sec)
```

(2).为用户进行操作授权

```bash
MariaDB [(none)]> grant all on *.* to hadoop@locahost identified by 'xxxx';  #请替换xx为密码
Query OK, 0 rows affected (0.00 sec)
```

(3).授权外网登录权限

```bash
MariaDB [(none)]> grant all privileges on *.* to hadoop@'%' identified by 'xxx'; #请替换xx为密码
Query OK, 0 rows affected (0.00 sec)
```

查询用户授权结果

```bash
MariaDB [mysql]> select host,user,password from user;
+-----------+--------+-------------------------------------------+
| host      | user   | password                                  |
+-----------+--------+-------------------------------------------+
| localhost | root   | *7D8990305DAAE2A688433D400E6559EBDF439529 |
| 127.0.0.1 | root   | *7D8990305DAAE2A688433D400E6559EBDF439529 |
| ::1       | root   | *7D8990305DAAE2A688433D400E6559EBDF439529 |
| locahost  | hadoop | *7D8990305DAAE2A688433D400E6559EBDF439529 |
| localhost | hadoop | *AB7E9F716159ED905A3E5DA78DA0DFD516C429E1 |
| %         | hadoop | *7D8990305DAAE2A688433D400E6559EBDF439529 |
+-----------+--------+-------------------------------------------+
6 rows in set (0.00 sec)
```
