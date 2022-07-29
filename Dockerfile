FROM ubuntu:20.04
WORKDIR  /data/workspace

# BASIC INSTALL
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get update 
RUN apt-get install	-yq software-properties-common apt-utils tzdata
RUN apt-get install	-yq curl wget 
RUN apt-get install	-yq git 
RUN apt-get install	-yq vim 
RUN apt-get install	-yq python3 nodejs npm python3-pip
RUN apt-get install -yq gdal-bin 
RUN apt-get install -yq zip unzip
RUN apt-get install -yq jq jo
RUN apt-get -yq upgrade

# UPDATING NODE.JS
RUN npm cache clean -f; \
	npm install -g n; \
	n stable

# CONFIGURING TIMEZONE
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/America select Sao_Paulo' | debconf-set-selections; \
    dpkg-reconfigure tzdata
RUN apt-get clean

# VIMRC FILE
RUN pwd
ADD ./conf/vim/vimrc /etc/vim/vimrc

# INSTALLING NODE-RED
RUN npm install --unsafe-perm node-red --location=global
RUN npm install pm2 --location=global
ADD ./conf/node-red/* /usr/local/lib/node_modules/node-red/node_modules/@node-red/editor-client/public/vendor/ace/

RUN pip3 install xlsx2csv

# GLOBAL NODE.JS LIBRARIES
RUN pwd
RUN npm install xml-js --location=global
RUN npm install minimist --location=global
RUN npm install json2csv --location=global

RUN apt-get install -yq moreutils

ADD ./cli-tools/ /usr/local/sbin/

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# START COMMAND
CMD npm install --prefix /data/node-red && \
	pm2 start "node-red -u /data/node-red" --name=node-red --no-daemon

