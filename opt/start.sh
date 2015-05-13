if ! [ -b "/var/config/preamble.php" ]
then
    cp /opt/phabricator/var/config/preamble.php /var/config/
fi

if ! [ -b "/var/config/config.conf.php" ]
then
    cp /opt/phabricator/var/config/config.conf.php /var/config/
fi

chown -R phd /var/repo
chown -R phd /var/config
chown -R www-data /var/storage

exec supervisord -c /opt/supervisord/supervisord.conf
