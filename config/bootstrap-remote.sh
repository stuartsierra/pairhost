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
### USER interaction: accept JDK license

# Mail (to avoid installing exim later)
/usr/bin/sudo /usr/bin/apt-get install -y postfix
### USER interaction: Set mail host name

# source control
/usr/bin/sudo /usr/bin/apt-get install -y git-core git-svn subversion subversion-tools

# Necessary libs for RVM and Ruby
/usr/bin/sudo /usr/bin/apt-get install -y build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev
# Ruby
/usr/bin/sudo /usr/bin/apt-get install -y ruby-full jruby rake
### USER TODO: Install latest Rubygems
### USER TODO: Install "bundler" gem
### USER TODO: Install RVM

# Databases
/usr/bin/sudo /usr/bin/apt-get install -y mysql-server mysql-admin mysql-client postgresql postgresql-client libmysqlclient-dev
### USER interaction: set empty password for MySQL root user (twice)

# Editors
/usr/bin/sudo /usr/bin/apt-get install -y vim emacs nano

# Web Servers
/usr/bin/sudo /usr/bin/apt-get install -y apache2
# These conflict with Apache: lighttpd nginx

# C/C++ development:
/usr/bin/sudo /usr/bin/apt-get install -y build-essential

# C# development:
/usr/bin/sudo /usr/bin/apt-get install -y mono-devel

# Desktop programs, including X, GNOME, Firefox, and OpenOffice
/usr/bin/sudo /usr/bin/apt-get install -y ubuntu-desktop

# VNC server
/usr/bin/sudo /usr/bin/apt-get install -y tightvncserver

# Libraries
/usr/bin/sudo /usr/bin/apt-get install -y libxml2 libxml2-dev libxslt libxslt-dev

# Misc
/usr/bin/sudo /usr/bin/apt-get install -y cron python imagemagick zsh perl tmux doxygen

# EC2 tools
/usr/bin/sudo /usr/bin/apt-get install -y ec2-ami-tools ec2-api-tools

### USER TODO: Install truecrypt, http://www.truecrypt.org/
