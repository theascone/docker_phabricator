cd $PHABRICATOR_DIR

hterm()
{
    echo "Stopping: phd aphlict"

    phabricator/bin/phd stop
    phabricator/bin/aphlict stop
}

echo "Starting: phd aphlict"

phabricator/bin/phd start
phabricator/bin/aphlict start

trap "hterm" TERM INT

#Wait for signals
tailf /dev/null
