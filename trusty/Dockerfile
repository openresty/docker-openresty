# Dockerfile - Ubuntu Trusty
# https://github.com/openresty/docker-openresty

FROM ubuntu:trusty

MAINTAINER Evan Wies <evan@neomantra.net>

# Install APT dependencies
# Put this before the ARGS to minimize di
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential perl make \
        libreadline-dev libncurses5-dev zlib1g-dev


# Docker Build Arguments
ARG RESTY_VERSION="1.9.7.3"
ARG RESTY_OPENSSL_VERSION="1.0.2e"
ARG RESTY_PCRE_VERSION="8.38"
ARG RESTY_J="1"
ARG RESTY_CONFIG_OPTIONS="--with-ipv6 --with-pcre-jit"

# These are not intended to be user-specified
ARG _RESTY_CONFIG_DEPS="--with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} --with-pcre=/tmp/pcre-${RESTY_PCRE_VERSION}"


# Download and untar OpenSSL, PCRE, and OpenResty
WORKDIR /tmp

ADD https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz /tmp/openssl-${RESTY_OPENSSL_VERSION}.tar.gz
RUN tar xzf openssl-${RESTY_OPENSSL_VERSION}.tar.gz

ADD https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${RESTY_PCRE_VERSION}.tar.gz /tmp/pcre-${RESTY_PCRE_VERSION}.tar.gz
RUN tar xzf pcre-${RESTY_PCRE_VERSION}.tar.gz

ADD https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz /tmp/openresty-${RESTY_VERSION}.tar.gz
RUN tar xzf openresty-${RESTY_VERSION}.tar.gz


# Build OpenResty
WORKDIR /tmp/openresty-${RESTY_VERSION}
RUN ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} && \
    make -j${RESTY_J} && \
    make -j${RESTY_J} install


# Cleanup
WORKDIR /tmp
RUN rm -rf openssl-${RESTY_OPENSSL_VERSION}.tar.gz openssl-${RESTY_OPENSSL_VERSION} \
           pcre-${RESTY_PCRE_VERSION}.tar.gz pcre-${RESTY_PCRE_VERSION} \
           openresty-${RESTY_VERSION}.tar.gz openresty-${RESTY_VERSION}
WORKDIR /
