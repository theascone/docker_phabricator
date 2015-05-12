#!/bin/sh

hterm()
{
    echo "Stopping: phd aphlict"

    /opt/phabricator/phabricator/bin/aphlict stop
    /opt/phabricator/phabricator/bin/phd stop

    kill -TERM $child
}

echo "Setting up"

/opt/phabricator/setup.sh

echo "Starting: phd aphlict"

/opt/phabricator/phabricator/bin/phd start
/opt/phabricator/phabricator/bin/phd restart
/opt/phabricator/phabricator/bin/aphlict start

trap "hterm" TERM INT

#Wait for signals
tailf /dev/null &

child=$!
wait "$child"
