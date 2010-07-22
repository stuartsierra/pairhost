#!/bin/sh

#### Ubuntu lucid bootstrap script

# source control
/usr/bin/sudo /usr/bin/apt-get install -y git-core git-svn subversion subversion-tools

# Java
/usr/bin/sudo /usr/bin/add-apt-repository "deb http://archive.canonical.com/ lucid partner"
/usr/bin/sudo /usr/bin/apt-get update
/usr/bin/sudo /usr/bin/apt-get install -y sun-java6-jdk ant maven2 maven-ant-helper libmaven2-core-java
### USER: accept JDK license

# Ruby
/usr/bin/sudo /usr/bin/apt-get install -y ruby-full jruby rake rubygems

# Databases
/usr/bin/sudo /usr/bin/apt-get install -y mysql-server mysql-admin mysql-client postgresql postgresql-client
### USER: set empty password for MySQL root user

# Editors
/usr/bin/sudo /usr/bin/apt-get install -y vim emacs nano

# Web Servers
/usr/bin/sudo /usr/bin/apt-get install -y apache2
# These conflict with Apache: lighttpd nginx

# C/C++ development:
/usr/bin/sudo /usr/bin/apt-get install -y build-essential

# C# development:
/usr/bin/sudo /usr/bin/apt-get install -y mono-devel

# X Windows
/usr/bin/sudo /usr/bin/apt-get install -y tightvncserver fluxbox firefox

# Misc
/usr/bin/sudo /usr/bin/apt-get install -y cron python imagemagick zsh perl tmux doxygen

# EC2 AMI tools
/usr/bin/sudo /usr/bin/apt-get install -y alien
/usr/bin/wget https://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.noarch.rpm
export RUBYLIB=/usr/lib/site_ruby:$RUBYLIB
/usr/bin/sudo /usr/bin/alien -i ec2-ami-tools.noarch.rpm
