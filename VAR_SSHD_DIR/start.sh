hterm()
{
    echo "Stopping: sshd"

    kill -TERM $(cat var/run/sshd-phabricator.pid )
}

echo "Starting: sshd"

/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator

trap "hterm" TERM INT

#Wait for signals
tailf /dev/null
