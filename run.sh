#!/bin/sh

# use default configuration if not supplied
if [[ ! -e /data/.config/radicale/config ]]; then
    mkdir -p /data/.config && mv /etc/radicale /data/.config
fi

# setup git repository for change tracking
if [[ ! -e /data/.git ]]; then
    (
      cd /data && git init && {
        git config user.email "radicale@localhost"
        git config user.name "Radicale"
      }
    )
    cat <<-'!!' > /data/.gitignore
	.*_history
	.Radicale.cache
	.Radicale.lock
	.Radicale.tmp.*
	!!
fi

# create symlinks to shared calendars
(
  cd /data/collection-root 2>/dev/null && for user in *; do
    [[ ${user} == shared ]] && continue
    (cd ${user} && for cal in ../shared/*; do ln -sf ${cal} .; done)
  done
)

# fix permissions
chown -R ${PUID:=dav}:${PGID:=dav} /data

# execute radicale with different privileges
su-exec ${PUID}:${PGID} radicale "$@"
