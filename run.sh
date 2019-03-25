#!/bin/sh

# use default configuration if not supplied
if [[ ! -e /data/.config/radicale/config ]]; then
    mkdir -p /data/.config && mv /etc/radicale /data/.config
fi

# fix permissions
chown -R ${PUID:=dav}:${PGID:=dav} /data

# execute radicale with different privileges
su-exec ${PUID}:${PGID} radicale "$@"
