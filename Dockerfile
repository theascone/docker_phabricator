FROM debian:jessie

MAINTAINER Addis Dittebrandt <addis.dittebrandt@gmail.com>

RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get -y --no-install-recommends install \
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
    python-pygments \
    sendmail \
    && apt-get -y clean \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && sendmailconfig \
    && useradd -r -d / phd \
    && useradd -r -d / vcs \
    && mkdir -p /var/repo \
    && mkdir -p /var/config \
    && mkdir -p /var/storage \
    && ln -s /usr/lib/git-core/git-http-backend /usr/bin/

ADD opt/start.sh opt/setup.sh /opt/
RUN chmod +x /opt/start.sh /opt/setup.sh

RUN mkdir /opt/phabricator
WORKDIR /opt/phabricator

RUN git clone https://github.com/phacility/libphutil.git \
    && git clone https://github.com/phacility/arcanist.git \
    && git clone https://github.com/phacility/phabricator.git

ADD opt/phabricator/phabricator.sh \
    opt/phabricator/setup.sh \
    /opt/phabricator/

RUN mkdir -p /opt/phabricator/phabricator/conf/custom

ADD opt/phabricator/phabricator/conf/local/ENVIRONMENT /opt/phabricator/phabricator/conf/local/

RUN ln -s /var/config/preamble.php /opt/phabricator/phabricator/support/ \
    && ln -s /var/config/config.conf.php /opt/phabricator/phabricator/conf/custom/

WORKDIR /opt/phabricator/phabricator/support/aphlict/server/

RUN npm install ws \
    && mkdir -p /opt/phabricator/var/config

ADD opt/phabricator/var/config/preamble.php \
    opt/phabricator/var/config/config.conf.php \
    /opt/phabricator/var/config/

WORKDIR /opt/phabricator
RUN chown -R phd . \
    && mkdir -p /var/tmp/phd && chown -R phd:phd /var/tmp/phd \
    && touch /var/log/aphlict.log && chown phd:phd /var/log/aphlict.log

RUN mkdir /opt/supervisord
WORKDIR /opt/supervisord

ADD opt/supervisord/supervisord.conf /opt/supervisord/

WORKDIR /

RUN mkdir /var/run/lighttpd \
    && chown www-data:www-data /var/run/lighttpd \
    && chmod 0750 /var/run/lighttpd

ADD etc/lighttpd/conf-available/20-rewrite.conf \
    etc/lighttpd/conf-available/20-setenv.conf  \
    etc/lighttpd/conf-available/30-phabricator.conf \
    /etc/lighttpd/conf-available/

RUN lighttpd-enable-mod fastcgi \
    && lighttpd-enable-mod fastcgi-php \
    && lighttpd-enable-mod rewrite \
    && lighttpd-enable-mod setenv \
    && lighttpd-enable-mod phabricator

RUN sed -i "s/disable_functions/;disable_functions/g" /etc/php5/cgi/php.ini \
    && sed -i "s/post_max_size =.*/post_max_size = 32M/g" /etc/php5/cgi/php.ini \
    && sed -i "s/^\(;\?\)opcache\.validate_timestamps.*/opcache.validate_timestamps=0/g" /etc/php5/cgi/php.ini

RUN mkdir /var/run/sshd

ADD etc/sudoers.d/30-phabricator /etc/sudoers.d/

RUN sed -i "s/vcs\:\(\!\|\!\!\)/vcs\:NP/g" /etc/shadow

RUN mkdir /usr/libexec \
    && cp /opt/phabricator/phabricator/resources/sshd/phabricator-ssh-hook.sh /usr/libexec/ \
    && chown root  /usr/libexec/phabricator-ssh-hook.sh \
    && chmod 755   /usr/libexec/phabricator-ssh-hook.sh \
    && sed -i "s/^VCSUSER.*/VCSUSER=\"vcs\"/g" /usr/libexec/phabricator-ssh-hook.sh \
    && sed -i "s|^ROOT.*|ROOT=\"/opt/phabricator/phabricator\"|g" /usr/libexec/phabricator-ssh-hook.sh

RUN cp /opt/phabricator/phabricator/resources/sshd/sshd_config.phabricator.example /etc/ssh/sshd_config.phabricator \
    && sed -i "s|^AuthorizedKeysCommandUser\s.*|AuthorizedKeysCommandUser vcs|g" /etc/ssh/sshd_config.phabricator \
    && sed -i "s|^AllowUsers\s.*|AllowUsers vcs|g" /etc/ssh/sshd_config.phabricator

EXPOSE 22 80 22280

VOLUME /var/repo /var/config /var/storage

CMD ["/bin/sh", "/opt/start.sh"]
