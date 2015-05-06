hterm()
{
    echo "Stopping: phd aphlict"

    $PHABRICATOR_DIR/phabricator/bin/phd stop
    $PHABRICATOR_DIR/phabricator/bin/aphlict stop
}

echo "Starting: phd aphlict"

$PHABRICATOR_DIR/phabricator/bin/phd start
$PHABRICATOR_DIR/phabricator/bin/aphlict start

trap "hterm" TERM INT

#Wait for signals
tailf /dev/null
