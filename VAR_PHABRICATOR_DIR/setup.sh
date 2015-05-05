cd $PHABRICATOR_DIR

phabricator/bin/config set mysql.host $MYSQL_PORT_3306_TCP_ADDR
phabricator/bin/config set mysql.port $MYSQL_PORT_3306_TCP_PORT

phabricator/bin/config set mysql.user $MYSQL_USER
phabricator/bin/config set mysql.pass $MYSQL_PASS

phabricator/bin/storage upgrade
