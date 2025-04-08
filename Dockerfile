# syntax=docker/dockerfile:1

FROM alpine:3

RUN apk update \
    && apk add --no-cache curl jq tini moreutils \
        sqlite-libs gcompat bash icu-libs krb5-libs \
        libgcc libintl libssl3 libstdc++ zlib

RUN mkdir -p /app/ && \
    cd /app/ && \
    f=Jackett.Binaries.LinuxMuslAMDx64.tar.gz && \
    repo=https://api.github.com/repos/Jackett/Jackett/releases/latest && \
    r=$(curl -s $repo | jq -r '.tag_name') && \
    curl -sLO https://github.com/Jackett/Jackett/releases/download/$r/$f && \
    tar -xvf "$f" && \
    rm -f "$f"

ENV XDG_CONFIG_HOME=/config/
RUN mkdir -p $XDG_CONFIG_HOME

RUN addgroup --system jackett && \
    adduser --system --disabled-password jackett --ingroup jackett && \
    chown -R jackett:jackett /app/Jackett && \
    chown -R jackett:jackett /config

COPY --chmod=755 bin/* /usr/bin/

EXPOSE 9117
USER jackett
WORKDIR /home/jackett/
VOLUME ["/config"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint.sh"]

HEALTHCHECK --interval=5m \
    --start-period=5m \
    --start-interval=10s \
    CMD pgrep /app/Jackett/jackett \
        && curl -f http://127.0.0.1:9117 \
        || exit 1
