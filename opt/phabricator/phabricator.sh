#!/bin/sh

hterm()
{
    echo "Stopping: phd aphlict"

    /opt/phabricator/phabricator/bin/aphlict stop
    /opt/phabricator/phabricator/bin/phd stop

    kill -TERM $child
}

echo "Setting up"

bash /opt/phabricator/setup.sh

echo "Starting: phd"

#/opt/phabricator/phabricator/bin/phd start
su -s /bin/sh -c '/opt/phabricator/phabricator/bin/phd start' phd

echo "Starting: aphlict"
su -s /bin/sh -c '/opt/phabricator/phabricator/bin/aphlict start' phd

trap "hterm" TERM INT

#Wait for signals
tailf /dev/null &

child=$!
wait "$child"
