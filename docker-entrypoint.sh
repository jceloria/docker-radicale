#!/bin/sh

set -e

# Copy default configuration
if [[ ! -e /etc/radicale/config ]]; then
    install -m664 /tmp/config.default /etc/radicale/config
    rm -f /tmp/config.default
fi

# Generate a random password
if [[ ! -e /etc/radicale/users ]]; then
    password=$(LC_CTYPE=C tr -dc '[:'alnum':]' < /dev/urandom | fold -w 16 | head -n1)
    echo "local:${password}" > /etc/radicale/users
    echo "Credentials have been created for you at: /etc/radicale/users"
fi

# Update permissions
chown -R ${PUID:=radicale}:${PGID:=radicale} /etc/radicale /srv/radicale

# Execute with an unprivileged user
su-exec ${PUID}:${PGID} "$@"
