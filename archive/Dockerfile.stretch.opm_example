# Derived Dockerfile Example using `opm`
# https://github.com/openresty/docker-openresty
#
# Installs openresty-opm and then uses opm to install pgmoon.
#

FROM openresty/openresty:stretch

LABEL maintainer="Evan Wies <evan@neomantra.net>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openresty-opm \
    && opm get leafo/pgmoon
