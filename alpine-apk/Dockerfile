# Dockerfile - alpine-apk
# https://github.com/openresty/docker-openresty

ARG RESTY_IMAGE_BASE="alpine"
ARG RESTY_IMAGE_TAG="3.12"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="Evan Wies <evan@neomantra.net>"

# Docker Build Arguments
ARG RESTY_IMAGE_BASE="alpine"
ARG RESTY_IMAGE_TAG="3.12"

ARG RESTY_APK_KEY_URL="http://openresty.org/package/admin@openresty.com-5ea678a6.rsa.pub"
ARG RESTY_APK_REPO_URL="http://openresty.org/package/alpine/v${RESTY_IMAGE_TAG}/main"
ARG RESTY_APK_VERSION="=1.19.3.1-r0"

LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"
LABEL resty_apk_key_url="${RESTY_APK_KEY_URL}"
LABEL resty_apk_repo_url="${RESTY_APK_REPO_URL}"
LABEL resty_apk_version="${RESTY_APK_VERSION}"

RUN wget -O "/etc/apk/keys/$(basename ${RESTY_APK_KEY_URL})" "${RESTY_APK_KEY_URL}" \
    && echo "${RESTY_APK_REPO_URL}" >> /etc/apk/repositories \
    && apk update \
    && apk add "openresty${RESTY_APK_VERSION}" \
    && mkdir -p /var/run/openresty \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

# Copy nginx configuration files
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
