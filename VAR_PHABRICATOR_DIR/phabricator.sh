cd $PHABRICATOR_DIR

phabricator/bin/phd start
phabricator/bin/aphlict start

#TODO: Wait for SIGTERM

phabricator/bin/phd stop
phabricator/bin/aphlict stop
