# Dockerfile - CentOS 8 - RPM version
# https://github.com/openresty/docker-openresty

ARG RESTY_IMAGE_BASE="centos"
ARG RESTY_IMAGE_TAG="8"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="Evan Wies <evan@neomantra.net>"

ARG RESTY_IMAGE_BASE="centos"
ARG RESTY_IMAGE_TAG="8"
ARG RESTY_LUAROCKS_VERSION="3.5.0"
ARG RESTY_YUM_REPO="https://openresty.org/package/centos/openresty.repo"
ARG RESTY_RPM_FLAVOR=""
ARG RESTY_RPM_VERSION="1.19.3.1-1"
ARG RESTY_RPM_DIST="el8"
ARG RESTY_RPM_ARCH="x86_64"

LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"
LABEL resty_luarocks_version="${RESTY_LUAROCKS_VERSION}"
LABEL resty_yum_repo="${RESTY_YUM_REPO}"
LABEL resty_rpm_flavor="${RESTY_RPM_FLAVOR}"
LABEL resty_rpm_version="${RESTY_RPM_VERSION}"
LABEL resty_rpm_dist="${RESTY_RPM_DIST}"
LABEL resty_rpm_arch="${RESTY_RPM_ARCH}"


RUN yum install -y yum-utils \
    && yum-config-manager --add-repo ${RESTY_YUM_REPO} \
    && yum install -y \
        gettext \
        gzip \
        make \
        openresty${RESTY_RPM_FLAVOR}-${RESTY_RPM_VERSION}.${RESTY_RPM_DIST}.${RESTY_RPM_ARCH} \
        openresty-opm-${RESTY_RPM_VERSION}.${RESTY_RPM_DIST} \
        openresty-resty-${RESTY_RPM_VERSION}.${RESTY_RPM_DIST} \
        tar \
        unzip \
    && cd /tmp \
    && curl -fSL https://luarocks.github.io/luarocks/releases/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz -o luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
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
    && yum clean all \
    && mkdir -p /var/run/openresty \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# Unused, present for parity with other Dockerfiles
# This makes some tooling/testing easier, as specifying a build-arg
# and not consuming it fails the build.
ARG RESTY_J="1"

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

# Add LuaRocks paths
# If OpenResty changes, these may need updating:
#    /usr/local/openresty/bin/resty -e 'print(package.path)'
#    /usr/local/openresty/bin/resty -e 'print(package.cpath)'
ENV LUA_PATH="/usr/local/openresty/site/lualib/?.ljbc;/usr/local/openresty/site/lualib/?/init.ljbc;/usr/local/openresty/lualib/?.ljbc;/usr/local/openresty/lualib/?/init.ljbc;/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/init.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/init.lua;./?.lua;/usr/local/openresty/luajit/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/openresty/luajit/share/lua/5.1/?.lua;/usr/local/openresty/luajit/share/lua/5.1/?/init.lua"

ENV LUA_CPATH="/usr/local/openresty/site/lualib/?.so;/usr/local/openresty/lualib/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so"

# Copy nginx configuration files
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
