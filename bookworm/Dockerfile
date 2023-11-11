# Dockerfile - Debian 12 Bookworm - DEB version
# https://github.com/openresty/docker-openresty

ARG RESTY_IMAGE_BASE="debian"
ARG RESTY_IMAGE_TAG="bookworm-slim"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="Evan Wies <evan@neomantra.net>"

# RESTY_DEB_FLAVOR build argument is used to select other
# OpenResty Debian package variants.
# For example: "-debug" or "-valgrind"
ARG RESTY_DEB_FLAVOR=""
ARG RESTY_DEB_VERSION="=1.21.4.3-1~bookworm1"
ARG RESTY_APT_REPO="https://openresty.org/package/debian"
ARG RESTY_APT_PGP="https://openresty.org/package/pubkey.gpg"
ARG RESTY_APT_ARCH="amd64"
ARG RESTY_IMAGE_BASE="debian"
ARG RESTY_IMAGE_TAG="bookworm-slim"

LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"
LABEL resty_apt_repo="${RESTY_APT_REPO}"
LABEL resty_apt_pgp="${RESTY_APT_PGP}"
LABEL resty_apt_arch="${RESTY_APT_ARCH}"
LABEL resty_deb_flavor="${RESTY_DEB_FLAVOR}"
LABEL resty_deb_version="${RESTY_DEB_VERSION}"


RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        wget \
    && wget -qO - ${RESTY_APT_PGP} | gpg --dearmor > /etc/apt/trusted.gpg.d/openresty-keyring.gpg \
    && chown root:root /etc/apt/trusted.gpg.d/openresty-keyring.gpg \
    && chmod ugo+r /etc/apt/trusted.gpg.d/openresty-keyring.gpg \
    && chmod go-w /etc/apt/trusted.gpg.d/openresty-keyring.gpg \
    && echo "deb [arch=$RESTY_APT_ARCH signed-by=/etc/apt/trusted.gpg.d/openresty-keyring.gpg] $RESTY_APT_REPO $(grep -Po 'VERSION="[0-9]+ \(\K[^)]+' /etc/os-release) openresty" | tee /etc/apt/sources.list.d/openresty.list \
    && DEBIAN_FRONTEND=noninteractive apt-get remove -y --purge \
        gnupg \
        wget \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openresty${RESTY_DEB_FLAVOR}${RESTY_DEB_VERSION} \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/openresty \
    && ln -sf /dev/stdout /usr/local/openresty${RESTY_DEB_FLAVOR}/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty${RESTY_DEB_FLAVOR}/nginx/logs/error.log

# Add additional binaries into PATH for convenience
ENV PATH="$PATH:/usr/local/openresty${RESTY_DEB_FLAVOR}/luajit/bin:/usr/local/openresty${RESTY_DEB_FLAVOR}/nginx/sbin:/usr/local/openresty${RESTY_DEB_FLAVOR}/bin"

# Copy nginx configuration files
COPY nginx.conf /usr/local/openresty${RESTY_DEB_FLAVOR}/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
