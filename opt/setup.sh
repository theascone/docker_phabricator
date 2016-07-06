#!/bin/bash

# SSH keys
pushd "/etc/ssh/" >dev/null
if ! [ -f "ssh_host_rsa_key" ]; then
  echo -e "Regenerating ssh keys.\nKeep /etc/ssh/ as a volume to make it persistent."
  rm ssh_host_* 2>/dev/null
  dpkg-reconfigure openssh-server
  echo "Regenerating DH primes, this will take a few minutes.. "
  ssh-keygen -G /etc/ssh/moduli
  echo "Done!"
  echo "Installing sshd-config.. "
  cp /opt/phabricator/phabricator/resources/sshd/sshd_config.phabricator.example /etc/ssh/sshd_config.phabricator \  
      && sed -i "s|^AuthorizedKeysCommandUser\s.*|AuthorizedKeysCommandUser vcs|g" /etc/ssh/sshd_config.phabricator \  
      && sed -i "s|^AllowUsers\s.*|AllowUsers vcs|g" /etc/ssh/sshd_config.phabricator

  [ -f "/etc/ssh_config" ] || cp /tmp/ssh_config /etc/ssh_config
  
  echo "Done!"
fi
popd >/dev/null

# Sendmail
sendmailconfig
