# Dockerfile - CentOS 7 - RPM version
# https://github.com/openresty/docker-openresty

FROM centos:7

MAINTAINER Evan Wies <evan@neomantra.net>

ARG RESTY_LUAROCKS_VERSION="2.3.0"
ARG RESTY_RPM_FLAVOR=""
ARG RESTY_RPM_VERSION="1.11.2.5-1.el7.centos.x86_64"

RUN yum install -y yum-utils \
    && yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo \
    && yum install -y \
        make \
        openresty${RESTY_RPM_FLAVOR}-${RESTY_RPM_VERSION} \
        openresty-opm-${RESTY_RPM_VERSION} \
        openresty-resty-${RESTY_RPM_VERSION} \
        unzip \
    && curl -fSL http://luarocks.org/releases/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz -o luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && tar xzf luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${RESTY_LUAROCKS_VERSION} \
    && ./configure \
        --prefix=/usr/local/openresty/luajit \
        --with-lua=/usr/local/openresty/luajit \
        --lua-suffix=jit-2.1.0-beta3 \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make build \
    && make install \
    && cd /tmp \
    && rm -rf luarocks-${RESTY_LUAROCKS_VERSION} luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && yum remove -y make \
    && yum clean all \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# Unused, present for parity with other Dockerfiles
# This makes some tooling/testing easier, as specifying a build-arg
# and not consuming it fails the build.
ARG RESTY_J="1"

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin/:/usr/local/openresty/nginx/sbin/:/usr/local/openresty/bin/

CMD ["/usr/bin/openresty", "-g", "daemon off;"]
