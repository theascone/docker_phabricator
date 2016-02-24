#!/bin/sh

function setVar() {
  /opt/phabricator/phabricator/bin/config set "$1" "$2"
}

function setVarENV() { 
  local conf_name="$1" local_name="$2" local_val="$3" link_name="$4" link_val="$5"  
  if [ -n "$local_val" ]; then
  setVar "$conf_name" "$local_val"
elif [ -n "$link_val" ]; then
  # use link environment
  setVar "$conf_name" "$link_val"
else
  echo "Error: $local_name is not set and not found in link environment! ($link_name)" 1>&2
  exit 1
fi
}

# Set mysql config
setVar mysql.host mysql
setVar mysql.port $MYSQL_PORT_3306_TCP_PORT

setVarENV mysql.user "\$MYSQL_USER" "$MYSQL_USER" "\$MYSQL_ENV_MYSQL_USER" "$MYSQL_ENV_MYSQL_USER"
setVarENV mysql.pass "\$MYSQL_PASS" "$MYSQL_PASS" "\$MYSQL_ENV_MYSQL_PASSWORD" "$MYSQL_ENV_MYSQL_PASSWORD"

# Set phd and ssh user
setVar phd.user phd
setVar diffusion.ssh-user  vcs

# Set local storage path
setVar storage.local-disk.path /var/storage

# Enable notifications
setVar notification.enabled true

# Set various options
setVar pygments.enabled true

if [ -z "$BASE_URI" ]; then
  c_hostname=$(hostname)
  BASE_URI="https://$c_hostname/"
fi
echo "Base uri: $BASE_URI"
setVar phabricator.base-uri "$BASE_URI"

if [ -z "$TZ" ]; then
  TZ="$TIMEZONE"
fi
if [ -z "$TZ" ]; then
  echo "TIMEZONE not set!"
else
  setVar phabricator.timezone "$TZ"
fi

# ignore not-so-important options
setVar config.ignore-issues '
{
  "mysql.ft_stopword_file": true,
  "security.security.alternate-file-domain": true
}'

# Upgrade storage
/opt/phabricator/phabricator/bin/storage --force upgrade
