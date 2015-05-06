# Set mysql config
$PHABRICATOR_DIR/phabricator/bin/config set mysql.host $MYSQL_PORT_3306_TCP_ADDR
$PHABRICATOR_DIR/phabricator/bin/config set mysql.port $MYSQL_PORT_3306_TCP_PORT

$PHABRICATOR_DIR/phabricator/bin/config set mysql.user $MYSQL_USER
$PHABRICATOR_DIR/phabricator/bin/config set mysql.pass $MYSQL_PASS

# Upgrade storage
$PHABRICATOR_DIR/phabricator/bin/storage --force upgrade

# Set base uri
$PHABRICATOR_DIR/phabricator/bin/config set phabricator.base-uri 'http://'$HOSTNAME

# Set phd and ssh user
$PHABRICATOR_DIR/phabricator/bin/config set phd.user phd
$PHABRICATOR_DIR/phabricator/bin/config set diffusion.ssh-user vcs
