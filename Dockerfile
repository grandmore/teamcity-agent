#clone from sjoerdmulder with additional tools

FROM sjoerdmulder/java8

# This will use the 1.3.2 release
RUN wget -O /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-1.3.2
RUN chmod +x /usr/local/bin/docker
ADD 10_wrapdocker.sh /etc/my_init.d/10_wrapdocker.sh
RUN groupadd docker

RUN apt-get update
RUN apt-get install -y unzip iptables lxc build-essential fontconfig

ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
ENV AGENT_DIR  /opt/buildAgent

# Check install and environment
ADD 00_checkinstall.sh /etc/my_init.d/00_checkinstall.sh

RUN adduser --disabled-password --gecos "" teamcity
RUN sed -i -e "s/%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/" /etc/sudoers
RUN usermod -a -G docker,sudo teamcity
RUN mkdir -p /data

EXPOSE 9090

VOLUME /var/lib/docker
#VOLUME /data
VOLUME ["/home-teamcity-agent"]

# Install ruby and node.js build repositories
RUN apt-add-repository ppa:chris-lea/node.js
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update

# Install node.js environment and eatmydata
RUN apt-get install -y nodejs git eatmydata
RUN npm install -g bower grunt-cli

# Install ruby environment
RUN apt-get install -y ruby2.1 ruby2.1-dev ruby ruby-switch build-essential
RUN ruby-switch --set ruby2.1
RUN gem install rake bundler compass --no-ri --no-rdoc

# install zip
RUN eatmydata -- apt-get install -yq zip

# install php5
RUN eatmydata -- apt-get install -yq php5
RUN eatmydata -- apt-get install -yq php5-curl

# install Phpunit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

# install Phing
RUN wget http://www.phing.info/get/phing-latest.phar
RUN chmod +x phing-latest.phar
RUN mv phing-latest.phar /usr/local/bin/phing-latest.phar

#add symbolic link
RUN mkdir /usr/local/phing-symbolic
RUN mkdir /usr/local/phing-symbolic/bin
RUN ln -s /usr/local/bin/phing-latest.phar /usr/local/phing-symbolic/bin/ant

# install Apache Ant
RUN eatmydata -- apt-get install -yq ant

#add foreach etc for apaceh ant
RUN wget http://mirrors.ibiblio.org/pub/mirrors/maven2/ant-contrib/ant-contrib/1.0b3/ant-contrib-1.0b3.jar


#install mercurial 3.2.x
RUN eatmydata -- apt-get install -yq python-dev python3-dev python3-setuptools python-docutils python3-docutils
RUN wget http://mercurial.selenic.com/release/mercurial-3.2.4.tar.gz
RUN cd /; tar -zxf mercurial-3.2.4.tar.gz
RUN cd mercurial-3.2.4; make build PYTHON=python; make install;

#install ssh client
RUN eatmydata -- apt-get install -yq ssh-askpass-gnome ssh-askpass

ADD service /etc/service
