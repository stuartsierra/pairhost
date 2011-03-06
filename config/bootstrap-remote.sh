#!/usr/bin/env bash

#### Ubuntu lucid bootstrap script

set -ev

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Create user accounts
( id pair &> /dev/null ) ||
sudo useradd pair -m -s /bin/bash \
    -G sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev,admin

if [ ! -e ~pair/.ssh/id_rsa ]; then
    sudo -i -u pair ssh-keygen -f ~pair/.ssh/id_rsa -t rsa -C "pair@pairhost" -P \"\"
fi

# Add multiverse repositories (for EC2 tools)
sudo perl -p -i -e 's/universe/universe multiverse/go' /etc/apt/sources.list

# Add repository for Sun JDK
sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"

# Update packages
sudo apt-get update

# Java
### USER INTERACTION: accept JDK license
sudo apt-get install -y sun-java6-jdk

# Mail (to avoid installing exim later)
### USER INTERACTION: Select mail server type (no configuration)
sudo apt-get install -y postfix

# Databases
### USER INTERACTION: set empty password for MySQL root user (twice)
sudo apt-get install -y sqlite3 \
    mysql-server mysql-admin mysql-client libmysqlclient-dev \
    postgresql postgresql-client sqlite3 

# Truecrypt, http://www.truecrypt.org/
### USER INTERACTION: accept defaults for Truecrypt installation
if [ ! -e /usr/bin/truecrypt ]; then
    if (uname -a | grep -q -E 'x86_64|ia64'); then
    # 64-bit
        (
            cd /tmp
            wget http://www.truecrypt.org/download/truecrypt-7.0a-linux-console-x64.tar.gz
            tar xzf truecrypt-7.0a-linux-console-x64.tar.gz
            sudo ./truecrypt-7.0a-setup-console-x64
        )
    else
    # 32-bit
        (
            cd /tmp
            wget http://www.truecrypt.org/download/truecrypt-7.0a-linux-console-x86.tar.gz
            tar xzf truecrypt-7.0a-linux-console-x86.tar.gz
            sudo ./truecrypt-7.0a-setup-console-x86
        )
    fi
fi


### NO MORE USER INTERACTION REQUIRED AFTER THIS POINT

# "fuse" module for Truecrypt
sudo modprobe fuse
sudo sh -c 'echo fuse >> /etc/modules'

# Java utilities
sudo apt-get install -y ant maven2 maven-ant-helper libmaven2-core-java

# source control
sudo apt-get install -y git-core git-svn subversion subversion-tools

# Misc development tools and native libraries
sudo apt-get install -y \
    autoconf \
    bison \
    build-essential \
    cron \
    curl \
    doxygen \
    imagemagick \
    libc6-dev \
    libreadline6 \
    libreadline6-dev \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    mono-devel \
    openssl \
    perl \
    python \
    tmux \
    zlib1g-dev
    zsh \

# Editors
sudo apt-get install -y vim emacs nano

# Web Servers
sudo apt-get install -y apache2
# These conflict with Apache: lighttpd nginx

# Desktop programs, including X, GNOME, Firefox, and OpenOffice
sudo apt-get install -y ubuntu-desktop

# VNC server
sudo apt-get install -y tightvncserver

# EC2 tools
sudo apt-get install -y ec2-ami-tools ec2-api-tools

# Ruby
sudo apt-get install -y ruby-full

# Rubygems
if [ ! -e /usr/bin/gem ]; then
    (
        cd /tmp
        wget http://production.cf.rubygems.org/rubygems/rubygems-1.5.2.tgz
        tar xzf rubygems-1.5.2.tgz
        cd rubygems-1.5.2
        sudo ruby setup.rb
        cd /usr/bin
        sudo ln -s gem1.8 gem
    )
fi

# Popular system-wide gems
( gem list --local | grep -q bundler ) ||
sudo gem install --no-rdoc --no-ri \
    bundler rake rails \
    thor rspec cucumber capistrano homesick

# RVM
if [ ! -e ~pair/.rvm ]; then
    (
        cd /tmp
        wget http://rvm.beginrescueend.com/releases/rvm-install-head
        sudo -i -u pair bash /tmp/rvm-install-head
    )
fi

# .bashrc for the "pair" user
cat <<'EOF' > /tmp/new_bashrc

# Local executables
PATH=$PATH:~/bin

# Pairhost aliases
alias nx="sudo /usr/NX/bin/nxserver --start"

# Ruby Version Manager (RVM)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
EOF

( grep nxserver -s ~pair/.bashrc ) ||
sudo sh -c 'cat /tmp/new_bashrc >> ~pair/.bashrc'

# Login message
cat <<'EOF' > /tmp/motd

    Welcome to the Pairhost Server.

    To start the NX server, run the alias 'nx'
    To use NX, you will need to set a password with 'sudo passwd <username>'

    To shut down this instance without destroying it, run 'sudo halt'

    This machine will shutdown automatically at 1:16am UTC;
    to prevent this, delete the file /var/auto_shutdown

EOF

sudo mv /tmp/motd /etc/


# Automatic shutdown at 1:16am, system time (UTC)
cat <<'EOF' > /tmp/auto_shutdown_warning_message

    NOTICE!  This machine will shut down automatically in 15 minutes.

    To prevent this, delete the file /var/auto_shutdown

EOF

sudo mv /tmp/auto_shutdown_warning_message /etc/

cat <<'EOF' > /tmp/auto_shutdown
If this file exists as /var/auto_shutdown then this machine will
shut down automatically at 1:16am system time (UTC).

To prevent automatic shutdown, rename or delete this file.
EOF
sudo mv /tmp/auto_shutdown /var/auto_shutdown

cat <<'EOF' > /tmp/auto_shutdown_crontab

# Auto-shutdown
# min hr day mon weekday user  command
  1   1  *   *   *       root  /bin/sh -c 'if [ -e /var/auto_shutdown ]; then /usr/bin/wall /etc/auto_shutdown_warning_message; fi'
 16   1  *   *   *       root  /bin/sh -c 'if [ -e /var/auto_shutdown ]; then /sbin/shutdown -h 0; fi'

EOF

sudo mv /tmp/auto_shutdown_crontab /etc/cron.d/auto_shutdown


# Dependencies for NX
sudo apt-get install -y libaudiofile0

# NX Free Edition for Linux, http://www.nomachine.com
if [ ! -d /usr/NX ]; then
    if (uname -a | grep -q -E 'x86_64|ia64'); then
    # 64-bit
        (
            cd /tmp
            wget http://64.34.161.181/download/3.4.0/Linux/nxclient_3.4.0-7_x86_64.deb
            wget http://64.34.161.181/download/3.4.0/Linux/nxnode_3.4.0-16_x86_64.deb
            wget http://64.34.161.181/download/3.4.0/Linux/FE/nxserver_3.4.0-17_x86_64.deb
            sudo dpkg -i nxclient_3.4.0-7_x86_64.deb 
            sudo dpkg -i nxnode_3.4.0-16_x86_64.deb 
            sudo dpkg -i nxserver_3.4.0-17_x86_64.deb        
        )
    else
    # 32-bit
        (
            cd /tmp
            wget http://64.34.161.181/download/3.4.0/Linux/nxclient_3.4.0-7_i386.deb
            wget http://64.34.161.181/download/3.4.0/Linux/nxnode_3.4.0-16_i386.deb
            wget http://64.34.161.181/download/3.4.0/Linux/FE/nxserver_3.4.0-17_i386.deb
            sudo dpkg -i nxclient_3.4.0-7_i386.deb 
            sudo dpkg -i nxnode_3.4.0-16_i386.deb 
            sudo dpkg -i nxserver_3.4.0-17_i386.deb
        )
    fi
fi

# Enable password-based SSH logins for NX
sudo perl -p -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/go' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart


# Enable password-less `sudo` for the users in the "sudo" group:
cat <<'EOF' > /tmp/new_sudoers

# Enable password-less sudo for all users in the "sudo" group
%sudo ALL=NOPASSWD: ALL

EOF
sudo sh -c 'cat /tmp/new_sudoers >> /etc/sudoers'


# Install a base set of Maven packages by downloading Jetty
mvn org.apache.maven.plugins:maven-dependency-plugin:2.2:get \
    -DrepoUrl=http://repo1.maven.org/maven2/ \
    -Dartifact=jetty:jetty:5.1.10
