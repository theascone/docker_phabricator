FROM \
    debian:jessie

MAINTAINER \
    Addis Dittebrandt <addis.dittebrandt@gmail.com>

RUN \
    apt-get update

RUN \
    apt-get -y dist-upgrade

RUN \
    apt-get -y install \
        supervisor \
        nginx \
        php-cli \
        php-fpm \
        php5 \
        php5-mysql \
        php5-curl \
        php5-json \
        php5-gd \
        php-apc \
        openssh-server \
        git \
        mercurial \
        subversion

RUN \
    apt-get clean

WORKDIR \
    /opt/

RUN \
    git clone https://github.com/phacility/libphutil.git

RUN \
    git clone https://github.com/phacility/arcanist.git

RUN \
    git clone https://github.com/phacility/phabricator.git

EXPOSE \
    80
EXPOSE \
    22280
