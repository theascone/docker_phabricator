FROM debian:jessie

MAINTAINER Addis Dittebrandt <addis.dittebrandt@gmail.com>

RUN apt-get update

RUN useradd -u 10000 -d / phd
RUN useradd -u 10001 -d / vcs
RUN useradd -u 10002 -d / www-data

RUN mkdir -p /var/repo
RUN chown -R phd /var/repo

RUN mkdir -p /var/storage
RUN chown -R www-data /var/storage

VOLUME /var/repo /var/storage
