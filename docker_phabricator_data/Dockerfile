FROM debian:jessie

MAINTAINER Addis Dittebrandt <addis.dittebrandt@gmail.com>

RUN apt-get update

RUN useradd -d / phd
RUN useradd -d / vcs

RUN mkdir -p /var/repo
RUN chown -R phd /var/repo

RUN mkdir -p /var/storage
RUN chown -R www-data /var/storage

VOLUME /var/repo /var/storage
