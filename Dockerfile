FROM debian:jessie

MAINTAINER Addis Dittebrandt <addis.dittebrandt@gmail.com>

WORKDIR /

RUN apt-get update

RUN apt-get -y install \
    supervisor \
    lighttpd \
    php5-cli \
    php5-cgi \
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

RUN apt-get clean

ENV PHABRICATOR_DIR /opt/phabricator/
RUN mkdir $PHABRICATOR_DIR
WORKDIR $PHABRICATOR_DIR

RUN git clone https://github.com/phacility/libphutil.git
RUN git clone https://github.com/phacility/arcanist.git
RUN git clone https://github.com/phacility/phabricator.git

ENV SUPERVISORD_DIR /opt/supervisord/
RUN mkdir $SUPERVISORD_DIR
WORKDIR $SUPERVISORD_DIR

ADD supervisord.conf .

WORKDIR /

EXPOSE 80
EXPOSE 22280

CMD supervisord -c $SUPERVISORD_DIR
