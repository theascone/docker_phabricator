FROM debian:jessie

MAINTAINER Addis Dittebrandt <addis.dittebrandt@gmail.com>

RUN apt-get update

RUN useradd -d / phd
RUN useradd -d / vcs

RUN mkdir -p /var/repo
RUN mkdir -p /var/config
RUN mkdir -p /var/storage

RUN apt-get -y install \
    sudo \
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
    nodejs-legacy \
    openssh-server \
    git \
    mercurial \
    subversion \
    python-pygments

RUN apt-get -y clean
RUN apt-get -y autoclean
RUN apt-get -y autoremove

RUN ln -s /usr/lib/git-core/git-http-backend /usr/bin/

ADD opt/start.sh /opt/
RUN chmod +x /opt/start.sh

RUN mkdir /opt/phabricator
WORKDIR /opt/phabricator

ADD opt/phabricator/phabricator.sh /opt/phabricator/
ADD opt/phabricator/setup.sh /opt/phabricator/

RUN git clone https://github.com/phacility/libphutil.git
RUN git clone https://github.com/phacility/arcanist.git
RUN git clone https://github.com/phacility/phabricator.git

RUN mkdir -p /opt/phabricator/phabricator/conf/custom

ADD opt/phabricator/phabricator/conf/local/ENVIRONMENT /opt/phabricator/phabricator/conf/local/

RUN ln -s /var/config/preamble.php /opt/phabricator/phabricator/support/
RUN ln -s /var/config/config.conf.php /opt/phabricator/phabricator/conf/custom/

WORKDIR /opt/phabricator/phabricator/support/aphlict/server/

RUN npm install ws

RUN mkdir -p /opt/phabricator/var/config
ADD opt/phabricator/var/config/preamble.php /opt/phabricator/var/config/
ADD opt/phabricator/var/config/config.conf.php /opt/phabricator/var/config/

WORKDIR /opt/phabricator
RUN chown -R phd .

RUN mkdir /opt/supervisord
WORKDIR /opt/supervisord

ADD opt/supervisord/supervisord.conf /opt/supervisord/

WORKDIR /

RUN mkdir /var/run/lighttpd
RUN chown www-data:www-data /var/run/lighttpd
RUN chmod 0750 /var/run/lighttpd

ADD etc/lighttpd/conf-available/20-rewrite.conf     /etc/lighttpd/conf-available/
ADD etc/lighttpd/conf-available/30-phabricator.conf /etc/lighttpd/conf-available/

RUN lighttpd-enable-mod fastcgi
RUN lighttpd-enable-mod fastcgi-php
RUN lighttpd-enable-mod rewrite
RUN lighttpd-enable-mod phabricator

RUN sed -i "s/disable_functions/;disable_functions/g" /etc/php5/cgi/php.ini
RUN sed -i "s/post_max_size =.*/post_max_size = 32M/g" /etc/php5/cgi/php.ini
RUN sed -i "s/^\(;\?\)opcache\.validate_timestamps.*/opcache.validate_timestamps=0/g" /etc/php5/cgi/php.ini

RUN mkdir /var/run/sshd

ADD etc/sudoers.d/30-phabricator /etc/sudoers.d/

RUN sed -i "s/vcs\:\(\!\|\!\!\)/vcs\:NP/g" /etc/shadow

RUN mkdir /usr/libexec
RUN cp /opt/phabricator/phabricator/resources/sshd/phabricator-ssh-hook.sh /usr/libexec/
RUN chown root  /usr/libexec/phabricator-ssh-hook.sh
RUN chmod 755   /usr/libexec/phabricator-ssh-hook.sh

RUN sed -i "s/^VCSUSER.*/VCSUSER=\"vcs\"/g" /usr/libexec/phabricator-ssh-hook.sh
RUN sed -i "s|^ROOT.*|ROOT=\"/opt/phabricator/phabricator\"|g" /usr/libexec/phabricator-ssh-hook.sh

RUN cp /opt/phabricator/phabricator/resources/sshd/sshd_config.phabricator.example /etc/ssh/sshd_config.phabricator

RUN sed -i "s|^AuthorizedKeysCommandUser\s.*|AuthorizedKeysCommandUser vcs|g" /etc/ssh/sshd_config.phabricator
RUN sed -i "s|^AllowUsers\s.*|AllowUsers vcs|g" /etc/ssh/sshd_config.phabricator

EXPOSE 22
EXPOSE 80
EXPOSE 22280

VOLUME /var/repo /var/config /var/storage

CMD ["/bin/sh", "/opt/start.sh"]
