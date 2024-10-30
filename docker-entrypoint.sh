#!/bin/sh

set -e

# Copy default configuration
if [[ ! -e /config/config ]]; then
    install -m664 /tmp/config.default /config/config
    rm -f /tmp/config.default
fi

# Generate a random password
if [[ ! -e /config/users ]]; then
    password=$(LC_CTYPE=C tr -dc '[:'alnum':]' < /dev/urandom | fold -w 16 | head -n1)
    echo "local:${password}" > /config/users
    echo "Credentials have been created for you at: /config/users"
fi

# Update permissions
chown -R ${PUID:=radicale}:${PGID:=radicale} /data

# Execute with an unprivileged user
su-exec ${PUID}:${PGID} "$@"
