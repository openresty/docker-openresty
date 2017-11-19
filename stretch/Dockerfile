# Dockerfile - Debian 9 Stretch - DEB version
# https://github.com/openresty/docker-openresty

FROM debian:stretch-slim

LABEL maintainer="Evan Wies <evan@neomantra.net>"

# RESTY_DEB_FLAVOR build argument is used to select other
# OpenResty Debian package variants.
# For example: "-debug" or "-valgrind"
ARG RESTY_DEB_FLAVOR=""
ARG RESTY_DEB_VERSION="=1.13.6.1-1~stretch1"


RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        gettext-base \
        gnupg2 \
        lsb-release \
        software-properties-common \
        wget \
    && wget -qO /tmp/pubkey.gpg https://openresty.org/package/pubkey.gpg \
    && DEBIAN_FRONTEND=noninteractive apt-key add /tmp/pubkey.gpg \
    && rm /tmp/pubkey.gpg \
    && DEBIAN_FRONTEND=noninteractive add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty" \
    && DEBIAN_FRONTEND=noninteractive apt-get remove -y --purge \
        gnupg2 \
        lsb-release \
        software-properties-common \
        wget \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openresty${RESTY_DEB_FLAVOR}${RESTY_DEB_VERSION} \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /dev/stdout /usr/local/openresty${RESTY_DEB_FLAVOR}/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty${RESTY_DEB_FLAVOR}/nginx/logs/error.log


# Add additional binaries into PATH for convenience
ENV PATH="$PATH:/usr/local/openresty${RESTY_DEB_FLAVOR}/luajit/bin/:/usr/local/openresty${RESTY_DEB_FLAVOR}/nginx/sbin/:/usr/local/openresty${RESTY_DEB_FLAVOR}/bin/"

# Copy nginx configuration files
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/bin/openresty", "-g", "daemon off;"]
