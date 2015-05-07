#!/bin/sh

su -m -c "$PHABRICATOR_DIR/setup.sh" - phd

exec supervisord -c $SUPERVISORD_DIR/supervisord.conf
