#!/bin/sh

# Set mysql config
/opt/phabricator/phabricator/bin/config set mysql.host $MYSQL_HOST
/opt/phabricator/phabricator/bin/config set mysql.port $MYSQL_PORT

/opt/phabricator/phabricator/bin/config set mysql.user $MYSQL_USER
/opt/phabricator/phabricator/bin/config set mysql.pass $MYSQL_PASS

# Set phd and ssh user
/opt/phabricator/phabricator/bin/config set phd.user phd
/opt/phabricator/phabricator/bin/config set diffusion.ssh-user  vcs

# Set local storage path
/opt/phabricator/phabricator/bin/config set storage.local-disk.path /var/storage

# Upgrade storage
/opt/phabricator/phabricator/bin/storage --force upgrade
