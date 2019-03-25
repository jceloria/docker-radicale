FROM alpine:latest

ENV DEBIAN_FRONTEND noninteractive

COPY . /tmp/build

RUN cd /tmp/build && \
    apk --no-cache add python3 py-pip shadow su-exec && \
    addgroup -S dav && adduser -S -G dav -h /data dav && \
    install -D -m644 /tmp/build/config /etc/radicale/config && \
    install -m755 /tmp/build/run.sh / && \
    pip3 install radicale && rm -rf /var/cache/apk/* /tmp/build

EXPOSE 5232

VOLUME ["/data"]

ENTRYPOINT ["/run.sh"]
