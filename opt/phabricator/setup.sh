#!/bin/sh

function setVar() { 
  local conf_name="$1" local_name="$2" local_val="$3" link_name="$4" link_val="$5"  
  if [ -n "$local_val" ]; then
  /opt/phabricator/phabricator/bin/config set "$conf_name" "$local_val"
elif [ -n "$link_val"]; then
  # use link environment
  /opt/phabricator/phabricator/bin/config set "$conf_name" "$link_val"
else
  echo "Error: $local_name is not set and not found in link environment! ($link_name)" 1>&2
  exit(1)
fi
}

# Set mysql config
/opt/phabricator/phabricator/bin/config set mysql.host mysql
/opt/phabricator/phabricator/bin/config set mysql.port $MYSQL_PORT_3306_TCP_PORT
#setVar mysql.user "\$MYSQL_PORT" "$MYSQL_USER" "\$MYSQL_ENV_MYSQL_USER" "$MYSQL_ENV_MYSQL_USER"

setVar mysql.user "\$MYSQL_USER" "$MYSQL_USER" "\$MYSQL_ENV_MYSQL_USER" "$MYSQL_ENV_MYSQL_USER"
setVar mysql.pass "\$MYSQL_PASS" "$MYSQL_PASS" "\$MYSQL_ENV_MYSQL_PASS" "$MYSQL_ENV_MYSQL_PASS"

# Set phd and ssh user
/opt/phabricator/phabricator/bin/config set phd.user phd
/opt/phabricator/phabricator/bin/config set diffusion.ssh-user  vcs

# Set local storage path
/opt/phabricator/phabricator/bin/config set storage.local-disk.path /var/storage

# Upgrade storage
/opt/phabricator/phabricator/bin/storage --force upgrade
