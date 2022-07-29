#DEBIAN_FRONTEND=noninteractive
#DEBCONF_NONINTERACTIVE_SEEN=true

sudo apt-get update && apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    tzdata

# CONFIGURING TIMEZONE
echo 'tzdata tzdata/Areas select America' | debconf-set-selections
echo 'tzdata tzdata/Zones/America select Sao_Paulo' | debconf-set-selections
dpkg-reconfigure tzdata

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

sudo apt-get install docker-ce docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER
