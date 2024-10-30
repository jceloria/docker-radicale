FROM python:3-alpine

COPY . /tmp/build

RUN cd /tmp/build && \
    apk add --no-cache gcompat git libgcc openssh tzdata shadow su-exec tar
RUN cd /tmp/build && \
    apk add --no-cache -t .build-deps build-base libffi-dev && \
    addgroup -S radicale && adduser -S -G radicale -h /config radicale && \
    pip install --no-cache-dir -r requirements.txt && \
    install -m0664 config.default /tmp && \
    install -m0755 docker-entrypoint.sh / && \
    cd /usr/local/lib/python3*/site-packages/radicale_storage_decsync && \
    patch -p0 < /tmp/build/multi-args.patch && \
    apk del .build-deps && rm -rf /var/cache/apk/* /tmp/build

HEALTHCHECK --interval=30s --retries=3 CMD curl --fail http://localhost:5232 || exit 1
VOLUME /config /data
EXPOSE 5232

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["radicale", "--config", "/config/config"]
