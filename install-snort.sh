#!/bin/sh
# Install snort for ubuntu 18.04
CURDIR=$(pwd)

# Install essential packages
sudo apt install -y build-essential gcc libpcre3-dev zlib1g-dev libluajit-5.1-dev libpcap-dev openssl libssl-dev libnghttp2-dev libdumbnet-dev bison flex libdnet

# Get and unzip snort source code
mkdir -v $HOME/snort_src && cd $HOME/snort_src
wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz
wget https://www.snort.org/downloads/snort/snort-2.9.13.tar.gz
tar -xvzf daq-2.0.6.tar.gz
tar -xvzf snort-2.9.13.tar.gz
rm *\.tar\.gz

# Build snort from source
cd $HOME/snort_src/daq-2.0.6
./configure && make && sudo make install
cd $HOME/snort_src/snort-2.9.13
./configure --enable-sourcefire && make && sudo make install

sudo ldconfig
sudo ln -s /usr/local/bin/snort /usr/sbin/snort

# Make new usergroup for Snort
sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort

# Create configuration folders
sudo mkdir -pv /etc/snort/rules /var/log/snort /usr/local/lib/snort_dynamicrules

# Change permissions for new folders
sudo chmod -R 5775 /etc/snort /var/log/snort /usr/local/lib/snort_dynamicrules
sudo chown -R snort:snort /etc/snort /var/log/snort /usr/local/lib/snort_dynamicrules

# Create local Snort config files
sudo touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules /etc/snort/rules/local.rules
sudo cp $HOME/snort_src/snort-2.9.13/etc/*\.conf* /etc/snort
sudo cp $HOME/snort_src/snort-2.9.13/etc/*\.map /etc/snort

# Install community rules
wget https://www.snort.org/rules/community -O $HOME/snort_src/community.tar.gz
tar -xvf $HOME/snort_src/community.tar.gz -C $HOME/snort_src/ && rm $HOME/snort_src/*\.tar\.gz
sudo cp $HOME/snort_src/community-rules/* /etc/snort/rules

# remove references to run files not in community rules
sudo sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/' /etc/snort/snort.conf

cd $CURDIR
# Follow normal directions from here (remember to put local machine IP instead of server_public_ip/32
echo 'Assuming no errors, snort should now be installed. You should now be able to follow the guide starting at "Configuring the network and rule set"'
