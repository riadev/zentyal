#!/bin/sh


MYSQL_PASSWORD="YOUR_MYSQL_PASSWORD_HERE"
USERNAME=zentyal_username
PASSWORD=zentyal_password
ZENTYAL_VERSION=4.1

export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $MYSQL_PASSWORD'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD'
sudo debconf-set-selections <<< 'zentyal-core zentyal-core/port port 8443'
echo "deb http://archive.zentyal.org/zentyal $ZENTYAL_VERSION main" > /etc/apt/sources.list.d/zentyal.list
wget -q http://keys.zentyal.org/zentyal-$ZENTYAL_VERSION-archive.asc -O- | sudo apt-key add -
apt-get update
apt-get install zentyal --force-yes -y



#Setup Ubuntu Linux user with sudo so that you can use this user to LOGIN to Zentyal
sudo useradd $USERNAME -G sudo -m -s /bin/bash
echo $USERNAME":"$PASSWORD | chpasswd
touch /etc/sudoers.d/$USERNAME
tee /etc/sudoers.d/$USERNAME 1>/dev/null <<SUDOFILE
$USERNAME ALL=(ALL) NOPASSWD:ALL
SUDOFILE
chmod 0440 /etc/sudoers.d/$USERNAME
chown -R  $USERNAME:$USERNAME /home/$USERNAME
mkdir -p touch /home/$USERNAME/.ssh/
touch /home/$USERNAME/.ssh/authorized_keys
touch /home/$USERNAME/.ssh/config
tee /home/$USERNAME/.ssh/authorized_keys 1>/dev/null <<AUTHPUBKEY
#If you have RSA KEYs, you can place it here.
AUTHPUBKEY

chown -R $USERNAME:$USERNAME /home/$USERNAME/
chmod -R og-rw /home/$USERNAME/.ssh
