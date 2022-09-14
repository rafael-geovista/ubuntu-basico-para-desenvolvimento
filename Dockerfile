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
RUN apt-get install -yq r-base
RUN apt-get update
RUN apt-get install -yq apache2
#RUN apt-get install -yq postgresql-12

#ADD ./cli-tools/ /usr/local/sbin/

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

############################################################ 
#                   Installing Jupyter
############################################################ 
RUN pwd
RUN pip3 install jupyterlab
RUN pip3 install notebook
# adding Vim Mode
#RUN mkdir -p $(jupyter --data-dir)/nbextensions ; \
#    cd $(jupyter --data-dir)/nbextensions ; \
#    git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding ; \
#    jupyter nbextension enable vim_binding/vim_binding 
# node.js kernel
RUN npm install -g ijavascript
RUN ijsinstall
# bash kernel
RUN pip3 install bash_kernel
RUN python3 -m bash_kernel.install
# adding postgresql kernel
RUN apt-get install -yq libpq-dev
RUN pip3 install psycopg2
RUN pip3 install postgres_kernel
# R kernel
RUN jupyter labextension install @techrah/text-shortcuts
# adding dark theme
RUN pip3 install jupyter-themer
RUN jupyter-themer -c mdn-like

############################################################ 
#                   Installing R Libraries
############################################################ 
ADD ./scripts/r-libraries.r /root/r-libraries.r.json
RUN Rscript "/root/r-libraries.r.json"
RUN apt-get install -yq r-cran-xml


############################################################ 
#                   Configuring Apache
############################################################ 
#.RUN pwd
#.ADD ./conf/apache2/main.conf /etc/apache2/sites-available
#.RUN a2enmod rewrite
#.RUN a2enmod proxy_http
#.RUN a2enmod proxy_wstunnel
#.RUN a2dissite 000-default.conf
#.RUN a2ensite main.conf

############################################################ 
#                   Start command
############################################################ 
ADD ./pm2.json /root/pm2.json
CMD npm install --prefix /data/node-red ; \
    source /etc/apache2/envvars; \
    service apache2 start ; \
    pm2 start "/root/pm2.json" --no-daemon
