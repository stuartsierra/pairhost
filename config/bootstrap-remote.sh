#!/bin/sh

#### Ubuntu lucid bootstrap script

# Add multiverse repositories (for EC2 tools)
/usr/bin/sudo /usr/bin/perl -p -i -e 's/universe/universe multiverse/go' /etc/apt/sources.list

# Add repository for Sun JDK
/usr/bin/sudo /usr/bin/add-apt-repository "deb http://archive.canonical.com/ lucid partner"

# Update packages
/usr/bin/sudo /usr/bin/apt-get update

# Java
/usr/bin/sudo /usr/bin/apt-get install -y sun-java6-jdk ant maven2 maven-ant-helper libmaven2-core-java
### USER: accept JDK license

# Mail (to avoid installing exim later)
/usr/bin/sudo /usr/bin/apt-get install -y postfix
### USER: Configure mail host name to be "relevance-pairhost"

# source control
/usr/bin/sudo /usr/bin/apt-get install -y git-core git-svn subversion subversion-tools

# Ruby
/usr/bin/sudo /usr/bin/apt-get install -y ruby-full jruby rake
### Install latest Rubygems
### Install "bundler" gem

# Databases
/usr/bin/sudo /usr/bin/apt-get install -y mysql-server mysql-admin mysql-client postgresql postgresql-client libmysqlclient-dev
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

# Libraries
/usr/bin/sudo /usr/bin/apt-get install -y libxml2 libxml2-dev libxslt libxslt-dev

# Misc
/usr/bin/sudo /usr/bin/apt-get install -y cron python imagemagick zsh perl tmux doxygen

# EC2 tools
/usr/bin/sudo /usr/bin/apt-get install -y ec2-ami-tools ec2-api-tools
