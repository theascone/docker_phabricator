#!/bin/sh

hterm()
{
    echo "Stopping: phd aphlict"

    $PHABRICATOR_DIR/phabricator/bin/aphlict stop
    $PHABRICATOR_DIR/phabricator/bin/phd stop

    kill -TERM $child
}

echo "Starting: phd aphlict"

$PHABRICATOR_DIR/phabricator/bin/phd start
$PHABRICATOR_DIR/phabricator/bin/phd restart
$PHABRICATOR_DIR/phabricator/bin/aphlict start

trap "hterm" TERM INT

#Wait for signals
tailf /dev/null &

child=$!
wait "$child"
