$PHABRICATOR_DIR/phabricator/bin/config set mysql.host $MYSQL_PORT_3306_TCP_ADDR
$PHABRICATOR_DIR/phabricator/bin/config set mysql.port $MYSQL_PORT_3306_TCP_PORT

$PHABRICATOR_DIR/phabricator/bin/config set mysql.user $MYSQL_USER
$PHABRICATOR_DIR/phabricator/bin/config set mysql.pass $MYSQL_PASS

$PHABRICATOR_DIR/phabricator/bin/storage --force upgrade
