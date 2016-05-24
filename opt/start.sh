#!/bin/bash

# Configuration files
if [ ! -f /var/config/preamble.php ]; then
    cp /opt/phabricator/var/config/preamble.php /var/config/
fi

if [ ! -f /var/config/config.conf.php ]; then
    cp /opt/phabricator/var/config/config.conf.php /var/config/
fi

# Permissions
chown -R phd /var/repo
chown -R phd /var/config
chown -R www-data /var/storage

# Various (sendmail)
bash /opt/setup.sh

exec supervisord -c /opt/supervisord/supervisord.conf
