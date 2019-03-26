FROM python:3-alpine

ENV DEBIAN_FRONTEND noninteractive

COPY . /tmp/build

RUN cd /tmp/build && \
    apk add --no-cache --virtual .build-deps build-base libffi-dev && \
    apk --no-cache add git shadow su-exec tar && \
    addgroup -S dav && adduser -S -G dav -h /data dav && \
    for file in config rights passgen.py; do \
        mode=0644; echo ${file} | grep -Eq '\.py$' && mode=0755; \
        install -D -m${mode} /tmp/build/${file} /etc/radicale/${file}; \
    done && install -m755 /tmp/build/run.sh / && \
    pip3 install radicale passlib bcrypt && \
    apk del .build-deps && rm -rf /var/cache/apk/* /tmp/build

EXPOSE 5232

VOLUME ["/data"]

ENTRYPOINT ["/run.sh"]
