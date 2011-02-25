#!/usr/bin/env bash

#### Ubuntu maverick bootstrap script

set -ev

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Create user accounts
if ( id pair &> /dev/null ); then
    echo "User 'pair' already exists."
else
    sudo useradd pair -G adm,dialout,cdrom,floppy,audio,dip,video,plugdev,admin
    sudo -u pair mkdir ~pair/src ~pair/open ~pair/distfiles
fi

if ( id nxuser &> /dev/null ); then
    echo "User 'nxuser' already exists."
else
    sudo useradd nxuser
fi

# Add multiverse repositories (for EC2 tools)
sudo perl -p -i -e 's/universe/universe multiverse/go' /etc/apt/sources.list

# Add repository for Sun JDK
sudo add-apt-repository "deb http://archive.canonical.com/ maverick partner"

# Update packages
sudo apt-get update

# Java
### USER INTERACTION: accept JDK license
sudo apt-get install -y sun-java6-jdk ant maven2 maven-ant-helper libmaven2-core-java

# Mail (to avoid installing exim later)
### USER INTERACTION: Select mail server type (no configuration)
sudo apt-get install -y postfix

# Databases
### USER INTERACTION: set empty password for MySQL root user (twice)
sudo apt-get install -y sqlite3 \
    mysql-server mysql-admin mysql-client libmysqlclient-dev \
    postgresql postgresql-client sqlite3 

# curl
sudo apt-get install -y curl

# source control
sudo apt-get install -y git-core git-svn subversion subversion-tools

# Misc development tools and native libraries
sudo apt-get install -y build-essential \
    autoconf \
    bison \
    libc6-dev \
    libreadline6 \
    libreadline6-dev \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    openssl \
    libssl-dev \
    zlib1g-dev

# Editors
sudo apt-get install -y vim emacs nano

# Web Servers
sudo apt-get install -y apache2
# These conflict with Apache: lighttpd nginx

# C# development:
sudo apt-get install -y mono-devel

# Desktop programs, including X, GNOME, Firefox, and OpenOffice
sudo apt-get install -y ubuntu-desktop

# VNC server
sudo apt-get install -y tightvncserver

# Libraries
sudo apt-get install -y 

# Misc
sudo apt-get install -y cron python imagemagick zsh perl tmux doxygen

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
sudo gem install --no-rdoc --no-ri bundler rake thor rspec cucumber capistrano homesick

# RVM
if [ ! -e ~pair/.rvm ]; then
    (
        cd /tmp
        wget http://rvm.beginrescueend.com/releases/rvm-install-head
        sudo -i -u pair bash rvm-install-head
        echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"' >> ~pair/.bashrc
    )
fi

# Login message
cat <<EOF /tmp/motd
    Welcome to the Pairhost Server.

    Private source code goes on an encrypted volume at ~/src
    To mount the encrypted source code volume, run the alias 'sourcecode'

    Copies of open-source code can be stored under ~/open

    Distribution files for various packages are in ~/distfiles

    To start the NX server, run the alias 'nx'

    To shut down this instance without destroying it, run 'sudo shutdown -h 0'
EOF

sudo mv /tmp/motd /etc/


# Bash aliases
cat <<EOF >> ~pair/.bashrc
alias nx="sudo /usr/NX/bin/nxserver --start"
alias sourcecode="truecrypt -t -k '' --protect-hidden=no \$HOME/sourcecode.tc \$HOME/src"
EOF


# Automatic shutdown 15 minutes after midnight, system time
cat <<EOF > /tmp/auto_shutdown_warning_message

    NOTICE!  This machine will shutdown automatically in 15 minutes.

    To prevent this, delete the file /var/auto_shutdown

EOF

sudo mv /tmp/auto_shutdown_warning_message /etc/

sudo crontab -u root - <<EOF
# min hr day mon week  command
  0   1  *   *   *     touch /var/auto_shutdown
  1   1  *   *   *     wall /etc/auto_shutdown_warning_message
 16   1  *   *   *     sh -c 'if [ -e /var/auto_shutdown ]; then /sbin/shutdown -h 0; fi'
EOF


# Truecrypt, http://www.truecrypt.org/
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

# Create truecrypt volume
if [ ! -e /home/pair/sourcecode.tc ]; then
    truecrypt -c sourcecode.tc --size=1073741824 \
        --volume-type=Normal --encryption=AES \
        --hash=RIPEMD-160
fi

# NX Free Edition for Linux, http://www.nomachine.com
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

