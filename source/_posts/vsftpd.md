---
title: vsftpd
date: 2018-07-15 16:33:53
tags:
---


### vsftpd服务器的移植    ---Writen By Pengsh
时间：2017年9月26日

##### 一、简介
>vsftpd即very secure FTP daemon（非常安全的FTP进程），是一个基于GPL发布的类UNIX类操作系统上运行的服务器的名字（是一种守护进程），可以运行在诸如Linux、BSD、Solaris、HP-UX以及Irix等系统上面。vsftpd支持很多其他传统的FTP服务器不支持的良好特性。使用 vsftpd 可以在 Linux/Unix 系统上搭建一个安全、高性能、稳定性好的轻量级FTP服务器。

##### 二、准备工作
- [x] vsftpd源码包    **vsftpd-3.0.2.tar.gz**  [下载入口](http://vsftpd.beasts.org/)
- [x]  **arm-linux-gcc** 交叉工具编译链  [下载入口](http://www.veryarm.com/cross-tools) 
- [x] linux平台（Ubuntu 12.04  32bit）
		PS:本人所使用的是arm-2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
		
##### 三、编译vsftpd源码

1、解压

	 # tar -xvf vsftpd-3.0.2.tar.gz  -C /home/zhangxu/
	 # cd /home/vsptfd-3.0.2

2、配置环境变量	

	#export  PATH = $PATH:/home/zhangxu/software/arm-2009q1/bin
 
 3、修改Makefile和vsf_findlibs.sh
 
	#vi Makefile
	 CC =  /home/zhangxu/software/arm-2009q1/bin/arm-none-linux-gnueabi-gcc
	 LIBS = './vsf_findlibs.sh' - lcrypt (参数- lcrypt ，否则编译提示找不到crypt)
	 #vi vsf_findlibs.sh
	 注释掉49-59行
4、编译
	
	# make  #编译，如果电脑是多核CPU，如四核，使用make -j4可提高编译速度
	
编译完成后，当前目录下会生成两个文件：vsftpd 和 vsftpd.conf，这两个文件是我们要用的。

##### 四、复制vsftpd 和vsftpd.conf文件到目标板

将生成的 vsftpd 复制到目标板 /usr/sbin 目录，vsftpd.conf 复制到目标板 /etc 目录，并修改vsftpd 为可执行，从PC上传到目标板方式任选，可以用**tftp**或者**挂载**的方式均可
	  
	  #chmod +x vsftpd
	  
##### 五、目标板FTP服务 配置

使用 vi 打开 vsftpd.conf 文件，并进行配置，如下配置可实现正常上传下载功能：

	anonymous_enable=NO         # 默认的 YES 改为 NO
	local_enable=YES            # 删除前面的#号注释符号
	write_enable=YES            # 删除前面的#号注释符号
	anon_upload_enable=NO       # 删除前面的#号注释符号，并将 YES 改为 NO
	anon_mkdir_write_enable=NO  # 删除前面的#号注释符号，并将 YES 改为 NO
	anon_other_write_enable=NO  # 删除前面的#号注释符号，并将 YES 改为 NO（这一项新版本中可能没有） 
	chroot_local_user=YES       # 删除前面的#号注释符号，改行表示把FTP用户都限制在根目录中
	allow_writeable_chroot=YES  # 添加本行到文件最后

再在目标版上使用命令行配置：

	# adduser nobody                    # vsftpd默认配置需要
	# mkdir /usr/share/empty            # vsftpd默认配置需要

创建一个本地用户，并设置密码：

	# adduser ftpadmin
	Changing password for ftpadmin
	New password: 
	Retype password: 
	Password for ftpadmin changed by root
	 

##### 六、开启vsftpd服务

配置完之后，在目标板上打开vsftpd，命令：

	#  vsftpd &   #注意，后面还有一个&
	
如果要让 vsftpd 开机启动，可以将该命令添加到 /etc/profile 或者 rc.local 文件最后。

##### 七、 客户端测试
 