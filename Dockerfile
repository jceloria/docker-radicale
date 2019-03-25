FROM alpine:latest

ENV DEBIAN_FRONTEND noninteractive

COPY . /tmp/build

RUN cd /tmp/build && \
    apk --no-cache add python3 py-pip shadow su-exec && \
    addgroup -S dav && adduser -S -h /dav -G dav dav && \
    mkdir -p /dav/.config/radicale && \
    install -m644 -D /tmp/build/config /data/config && \
    ln -s /data/config /dav/.config/radicale/config && \
    install -m755 /tmp/build/run.sh / && \
    pip3 install radicale && rm -rf /var/cache/apk/* /tmp/build

EXPOSE 5232

VOLUME ["/data"]

ENTRYPOINT ["/run.sh"]
