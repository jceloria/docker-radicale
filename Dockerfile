FROM python:3-alpine

ENV DEBIAN_FRONTEND noninteractive

COPY . /tmp/build

RUN cd /tmp/build && \
    apk add --no-cache --virtual .build-deps build-base libffi-dev && \
    apk --no-cache add git shadow su-exec && \
    addgroup -S dav && adduser -S -G dav -h /data dav && \
    install -D -m644 /tmp/build/config /etc/radicale/config && \
    install -D -m755 /tmp/build/passgen.py /etc/radicale/passgen.py && \
    install -m755 /tmp/build/run.sh / && \
    pip3 install radicale passlib bcrypt && \
    apk del .build-deps && rm -rf /var/cache/apk/* /tmp/build

EXPOSE 5232

VOLUME ["/data"]

ENTRYPOINT ["/run.sh"]
