#!/bin/sh

hterm()
{
    echo "Stopping"

    kill -TERM $child
}

echo "Starting"

supervisord -c $SUPERVISORD_DIR/supervisord.conf &

child=$!
wait "$child"
