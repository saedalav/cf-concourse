#!/usr/bin/env bash

# tool suite to be installed
# git
# vim
# make
# ruby
# pass store
# eclipse
# concourse fly
# cloud foundry cf
# cloud foundry uaac
# docker
# docker-compose 
# docker-machine
# VB guest addition

# version variables
DOCKER_VERSION=""
DOCKER_COMPOSE_VERSION="1.6.2"
DOCKER_MACHINE_VERSION="v0.12.2"
FLY_VERSION="v3.4.0"
RUBY_VERSION="2.4.0"
VB_GUEST_VERSION="5.1.26"

cur_dir=`pwd`
echo "***** Current Directory: $cur_dir"
mkdir -p $cur_dir/tmp

# install EPEL for CentOS 7
sudo yum install -y epel-release

sudo yum update -y
sudo yum install -y git
sudo yum install -y wget
sudo yum install -y vim
sudo yum install -y pass


# install dependencies

# install ruby
sudo yum groupinstall -y "Development Tools"
sudo yum install -y gdbm-devel libdb4-devel libffi-devel libyaml libyaml-devel ncurses-devel openssl-devel readline-devel tcl-devel
sudo yum install -y netstat kernel-devel make perl
sudo yum install -y patch readline readline-devel zlib zlib-devel
sudo yum install -y bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
sudo yum install -y rubygems ruby-devel gcc gcc-c++

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm requirements run
rvm install $RUBY_VERSION

#sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel maven

# notify yum docker repo
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# install docker
sudo yum install -y docker-engine

sudo systemctl start docker
sudo systemctl enable docker

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
chmod +x /tmp/docker-compose
sudo cp /tmp/docker-compose /usr/local/bin/docker-compose

# install docker-machine
curl -L https://github.com/docker/machine/releases/download/$DOCKER_MACHINE_VERSION/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine
chmod +x /tmp/docker-machine
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

echo "docker version: $(docker --version)" 
echo "docker compose version: $(docker-compose --version)"
echo "docker machine version: $(docker-machine --version)"

# install concourse fly
wget -O /home/vagrant/tmp/fly https://github.com/concourse/concourse/releases/download/$FLY_VERSION/fly_linux_amd64
chmod +x /home/vagrant/tmp/fly
sudo cp /home/vagrant/tmp/fly /usr/local/bin/fly
sudo rm -rf /home/vagrant/tmp/fly

# install cloud foundry cf
sudo wget -O /etc/yum.repos.d/cloudfoundry-cli.repo https://packages.cloudfoundry.org/fedora/cloudfoundry-cli.repo
sudo yum install -y cf-cli

# install cloud foundry uaac
gem install cf-uaac

# clean up tmp directory
rm -rf /home/vagrant/tmp

# install Virtualbox Guest Additions
sudo yum install l-y inux-headers-$(uname -r) build-essential dkms
wget http://download.virtualbox.org/virtualbox/$VB_GUEST_VERSION/VBoxGuestAdditions_$VB_GUEST_VERSION.iso
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro VBoxGuestAdditions_$VB_GUEST_VERSION.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
rm VBoxGuestAdditions_$VB_GUEST_VERSION.iso
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions