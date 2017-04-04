# docker-openresty - Docker tooling for OpenResty

## Supported tags and respective `Dockerfile` links

- [`alpine`, (*alpine/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile)
- [`alpine-fat`, (*alpine-fat/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/alpine-fat/Dockerfile)
- [`armhf-xenial`, (*armhf-xenial/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/armhf-xenial/Dockerfile)
- [`centos`, (*centos/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/centos/Dockerfile)
- [`centos-rpm`, (*centos-rpm/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/centos-rpm/Dockerfile)
- [`jessie`, (*jessie/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/jessie/Dockerfile)
- [`trusty`, (*trusty/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/trusty/Dockerfile)
- [`wheezy`, (*wheezy/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/wheezy/Dockerfile)
- [`xenial`, (*xenial/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/xenial/Dockerfile)
- [`xenial-nginx-1.11.5`, (*xenial-nginx-1.11.5/Dockerfile*)](https://github.com/marrotte/docker-openresty/blob/master/xenial-nginx-1.11.5/Dockerfile)
- [`xenial-vts-sts`, (*xenial-vts-sts/Dockerfile*)](https://github.com/marrotte/docker-openresty/blob/master/xenial-vts-sts/Dockerfile)

[![](https://images.microbadger.com/badges/image/openresty/openresty.svg)](https://microbadger.com/#/images/openresty/openresty "Get your own image badge on microbadger.com")

Table of Contents
=================

* [Description](#description)
* [Usage](#usage)
* [OPM](#opm)
* [LuaRocks](#luarocks)
* [Docker ENTRYPOINT](#docker-entrypoint)
* [Building (non-RPM based)](#building-non-rpm-based)
* [Building (RPM based)](#building-rpm-based)
* [Feedback & Bug Reports](#feedback-bug-reports)
* [Changelog](#changelog)
* [Copyright & License](#copyright--license)

Description
===========

`docker-openresty` is [Docker](https://www.docker.com) tooling for OpenResty (https://www.openresty.org).

Docker is a container management platform.

OpenResty is a full-fledged web application server by bundling the standard nginx core,
lots of 3rd-party nginx modules, as well as most of their external dependencies.

From non-RPM flavors, the following modules are included by default, but one can easily increase or decrease that with [custom build options](#build-options) :

 * file-aio
 * http_addition_module
 * http_auth_request_module
 * http_dav_module
 * http_flv_module
 * http_geoip_module=dynamic
 * http_gunzip_module
 * http_gzip_static_module
 * http_image_filter_module=dynamic
 * http_mp4_module
 * http_random_index_module
 * http_realip_module
 * http_secure_link_module
 * http_slice_module
 * http_ssl_module
 * http_stub_status_module
 * http_sub_module
 * http_v2_module
 * http_xslt_module=dynamic
 * ipv6
 * mail
 * mail_ssl_module
 * md5-asm
 * pcre-jit
 * sha1-asm
 * stream
 * stream_ssl_module
 * threads

Usage
=====

If you are happy with the build defaults, then you can use the openresty image from the [Docker Hub](https://hub.docker.com/r/openresty/openresty/).  The image tags available there are listed at the top of this README.

```
docker run [options] openresty/openresty:trusty
```

*[options]* would be things like -p to map ports, -v to map volumes, and -d to daemonize.

`docker-openresty` symlinks `/usr/local/openresty/nginx/logs/access.log` and `error.log` to `/dev/stdout` and `/dev/stderr` respectively, so that Docker logging works correctly.  If you change the log paths in your `nginx.conf`, you should symlink those paths as well.

OPM
===

Starting at version 1.11.2.2, OpenResty includes a [package manager called `opm`](https://github.com/openresty/opm#readme), which can be found at `/usr/local/openresty/bin/opm`.

`opm` is built in all the images.  However, to use it in the `alpine` image, you must also install the `perl` package; it is not included by default because it doubles the image size.  You may install it like so: `apk add --no-cache perl`.

LuaRocks
========

[LuaRocks](https://luarocks.org/) is included in the `alpine-fat`, `centos`, `centos-rpm`, `trusty`, and `xenial` variants.  It is excluded from `alpine` because it generally requires a build system and we want to keep that variant lean.

It is available at `/usr/local/openresty/luajit/bin/luarocks`.  Packages can be added in your dependent Dockerfiles like so:

```
RUN /usr/local/openresty/luajit/bin/luarocks install <rock>
```

Docker ENTRYPOINT
=================

The `-g "daemon off;"` directive is used in the Dockerfile ENTRYPOINT to keep the Nginx daemon running after container creation. If this directive is added to the nginx.conf, then it may be omitted from the ENTRYPOINT.

To invoke with another ENTRYPOINT, for example the `resty` utility, invoke like so:

```
docker run [options] --entrypoint /usr/local/openresty/bin/resty openresty/openresty:xenial [script.lua]
```

*NOTE* The `alpine` images do not include the packages `perl` and `ncurses`, which is needed by the `resty` utility.

Building (non-RPM based)
========================

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

```
git clone https://github.com/openresty/docker-openresty.git
cd docker-openresty
docker build -t myopenresty -f trusty/Dockerfile .
docker run myopenresty
```

Dockerfiles are provided for the following base systems, selecting the Dockerfile path with `-f`:

 * [Alpine](https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile) (`alpine/Dockerfile`)
 * [Alpine Fat](https://github.com/openresty/docker-openresty/blob/master/alpine-fat/Dockerfile) (`alpine-fat/Dockerfile`)
 * [CentOS 7](https://github.com/openresty/docker-openresty/blob/master/centos/Dockerfile) (`centos/Dockerfile`)
 * [Debian Jessie](https://github.com/openresty/docker-openresty/blob/master/jessie/Dockerfile) (`jessie/Dockerfile`)
 * [Debian Wheezy](https://github.com/openresty/docker-openresty/blob/master/wheezy/Dockerfile) (`wheezy/Dockerfile`)
 * [Ubuntu Trusty](https://github.com/openresty/docker-openresty/blob/master/trusty/Dockerfile) (`trusty/Dockerfile`)
 * [Ubuntu Xenial](https://github.com/openresty/docker-openresty/blob/master/xenial/Dockerfile) (`xenial/Dockerfile`)
 * [Ubuntu Xenial armhf](https://github.com/openresty/docker-openresty/blob/master/armhf-xenial/Dockerfile) (`armhf-xenial/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_J=4 -f trusty/Dockerfile .
```

| Key | Default | Description |
:----- | :-----: |:----------- |
|RESTY_VERSION | 1.11.2.2 | The version of OpenResty to use. |
|RESTY_LUAROCKS_VERSION | 2.3.0 | The version of LuaRocks to use. |
|RESTY_OPENSSL_VERSION | 1.0.2j | The version of OpenSSL to use. |
|RESTY_PCRE_VERSION | 8.39 | The version of PCRE to use. |
|RESTY_J | 1 | Sets the parallelism level (-jN) for the builds. |
|RESTY_CONFIG_OPTIONS | "--with-file-aio --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_xslt_module=dynamic --with-ipv6 --with-mail --with-mail_ssl_module --with-md5-asm --with-pcre-jit --with-sha1-asm --with-stream --with-stream_ssl_module --with-threads" | The options to pass to OpenResty's `./configure` script. |

[Back to TOC](#table-of-contents)

Building (RPM based)
====================

OpenResty now now has [RPMs available](http://openresty.org/en/rpm-packages.html).  The `centos-rpm` images use these RPMs rather than the build system described above.

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

 * [CentOS 7 RPM](https://github.com/openresty/docker-openresty/blob/master/centos-rpm/Dockerfile) (`centos-rpm/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_RPM_FLAVOR="-debug" -f centos-rpm/Dockerfile centos-rpm
```

| Key | Default | Description |
:----- | :-----: |:----------- |
|RESTY_LUAROCKS_VERSION | 2.3.0 | The version of LuaRocks to use. |
|RESTY_RPM_FLAVOR | "" | The `openresty` package flavor to use.  Possibly `"-debug"` or `"-valgrind"`. |
|RESTY_RPM_VERSION | 1.11.2.2-8.el7.centos.x86_6 | The `openresty` package version to install. |

[Back to TOC](#table-of-contents)

Feedback & Bug Reports
======================

You're very welcome to report bugs and give feedback as GitHub Issues:

https://github.com/openresty/docker-openresty/issues

[Back to TOC](#table-of-contents)

Changelog
=========

## 2017-Feb-19

 * Add `armhf-xenial` image
 * Update `centos-rpm` to 1.11.2.2-8

## 2016-Nov-28

 * Add `alpine-fat` image
 * Remove 'latest' tags

## 1.11.2.2

 * Upgraded OpenResty to 1.11.2.2
 * Add resty-opm package to `centos-rpm`

## 2016-Oct-26

 * Added Debian Jessie and Wheezy Builds
 * Upgraded OpenSSL to 1.0.2j

## 1.11.2.1

 * Upgraded OpenResty to 1.11.2.1
 * Upgraded PCRE to 8.39
 * Updated ENTRYPOINT to use the new symlink `/usr/local/openresty/bin/openresty`
 * `centos-rpm` now has the build argument `RESTY_RPM_VERSION` and ENTRYPOINT `/usr/bin/openresty`

## 1.9.15.1

 * Upgraded OpenResty to 1.9.15.1
 * Logging is redirected to /dev/stdout and /dev/stderr
 * Introduced ENTRYPOINT with the `-g "daemon off;"` directive
 * Add `centos-rpm` base system, using upstream RPM packaging

[Back to TOC](#table-of-contents)

Copyright & License
===================

docker-openresty is licensed under the 2-clause BSD license.

Copyright (c) 2016, Evan Wies <evan@neomantra.net>.

This module is licensed under the terms of the BSD license.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)
