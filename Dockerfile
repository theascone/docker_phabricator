FROM \
    debian:jessie

MAINTAINER \
    Addis Dittebrandt <addis.dittebrandt@gmail.com>

RUN \
    apt-get update

RUN \
    apt-get -y install \
        supervisor \
        nginx \
        php5-cli \
        php5-fpm \
        php5 \
        php5-mysql \
        php5-curl \
        php5-json \
        php5-gd \
        php-apc \
        npm \
        nodejs \
        openssh-server \
        git \
        mercurial \
        subversion

RUN \
    apt-get clean

RUN \
    mkdir /opt/phabricator/

WORKDIR \
    /opt/phabricator/

RUN \
    git clone https://github.com/phacility/libphutil.git

RUN \
    git clone https://github.com/phacility/arcanist.git

RUN \
    git clone https://github.com/phacility/phabricator.git

ENV SUPERVISORD_CONF /opt/supervisord.conf
ADD \
    supervisord.conf $SUPERVISORD_CONF

EXPOSE \
    80
EXPOSE \
    22280

CMD supervisord -c $SUPERVISORD_CONF
