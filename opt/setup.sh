#!/bin/bash

# SSH keys
pushd "/etc/ssh/" >dev/null
if ! [ -f "ssh_host_rsa_key" ]; then
  echo -e "Regenerating ssh keys.\nKeep /etc/ssh/ as a volume to make it persistent."
  rm ssh_host_* 2>/dev/null
  dpkg-reconfigure openssh-server || exit
  echo "Done!"
fi
if ! [ -f "/etc/ssh/moduli" ]; then
  echo "Regenerating DH primes, this will take a few minutes.. "
  ssh-keygen -G /etc/ssh/moduli || exit
  echo "Done!"
fi

ssh_conf_phab="sshd_config.phabricator"
if ! [ -f "$ssh_conf_phab" ]; then
  echo -n "Installing phabricator sshd-config.. "
  cp /opt/phabricator/phabricator/resources/sshd/sshd_config.phabricator.example "$ssh_conf_phab" || exit
  sed -i "s|^AuthorizedKeysCommandUser\s.*|AuthorizedKeysCommandUser vcs|g" "$ssh_conf_phab" || exit
  sed -i "s|^AllowUsers\s.*|AllowUsers vcs|g" "$ssh_conf_phab" || exit
  echo "Done!"
fi

ssh_conf="/etc/ssh/ssh_config"
if ! [ -f "$ssh_conf" ]; then
  echo -e "Installing sshd-config.. "
  cp /tmp/ssh_config "$ssh_conf" || exit
  echo "Done!"
fi
popd >/dev/null

# Sendmail
sendmailconfig
