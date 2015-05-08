FROM debian:jessie

MAINTAINER Addis Dittebrandt <addis.dittebrandt@gmail.com>

RUN apt-get update

RUN useradd -d / phd
RUN useradd -d / vcs

RUN mkdir -p /var/repo
RUN chown -R phd /var/repo

RUN mkdir -p /var/config
ADD var_config/preamble.php /var/config/
ADD var_config/config.conf.php /var/config/
RUN chown -R phd /var/config

RUN mkdir -p /var/storage
RUN chown -R www-data /var/storage

VOLUME /var/repo /var/config /var/storage
