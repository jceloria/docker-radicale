#!/bin/sh

chown -R ${PUID:-dav}:${PGID:-dav} /data

su-exec ${PUID:-dav}:${PGID:-dav} radicale "$@"
