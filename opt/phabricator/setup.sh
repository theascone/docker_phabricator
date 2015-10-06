#!/bin/sh

# Set mysql config
/opt/phabricator/phabricator/bin/config set mysql.host mysql
/opt/phabricator/phabricator/bin/config set mysql.port $MYSQL_PORT_3306_TCP_PORT

if [ -n "$MYSQL_USER" ]; then
  /opt/phabricator/phabricator/bin/config set mysql.user $MYSQL_USER
elif [ -n "$MYSQL_ENV_MYSQL_USER"]; then
  # use link environment
  /opt/phabricator/phabricator/bin/config set mysql.user $MYSQL_ENV_MYSQL_USER
else
  echo "Error: \$MYSQL_USER is not set and not found in link environment! (\$MYSQL_ENV_MYSQL_USER)" 1>&2
  exit(1)
fi
if [ -n "$MYSQL_PASS" ]; then
  /opt/phabricator/phabricator/bin/config set mysql.pass $MYSQL_PASS
elif [ -n "$MYSQL_ENV_MYSQL_PASS"]; then
  # use link environment
  /opt/phabricator/phabricator/bin/config set mysql.pass $MYSQL_ENV_MYSQL_PASS
else
  echo "Error: \$MYSQL_PASS is not set and not found in link environment! (\$MYSQL_ENV_$MYSQL_PASS)" 1>&2
  exit(1)
fi

# Set phd and ssh user
/opt/phabricator/phabricator/bin/config set phd.user phd
/opt/phabricator/phabricator/bin/config set diffusion.ssh-user  vcs

# Set local storage path
/opt/phabricator/phabricator/bin/config set storage.local-disk.path /var/storage

# Upgrade storage
/opt/phabricator/phabricator/bin/storage --force upgrade
