FROM alpine:latest

ENV DEBIAN_FRONTEND noninteractive

COPY . /tmp/build

RUN cd /tmp/build && \
    apk --no-cache add git python3 py-pip shadow su-exec && \
    addgroup -S dav && adduser -S -G dav -h /data dav && \
    install -D -m644 /tmp/build/config /etc/radicale/config && \
    install -D -m755 /tmp/build/passgen.py /etc/radicale/passgen.py && \
    install -m755 /tmp/build/run.sh / && \
    pip3 install radicale passlib bcrypt && \
    rm -rf /var/cache/apk/* /tmp/build

EXPOSE 5232

VOLUME ["/data"]

ENTRYPOINT ["/run.sh"]
