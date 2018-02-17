# docker-openresty - Docker tooling for OpenResty

[![Build Status](https://travis-ci.org/neomantra/docker-openresty.svg?branch=master)](https://travis-ci.org/neomantra/docker-openresty)  [![](https://images.microbadger.com/badges/image/openresty/openresty.svg)](https://microbadger.com/#/images/openresty/openresty "microbadger.com")

## Supported tags and respective `Dockerfile` links

The following "flavors" are available:

- [`alpine`, (*alpine/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile)
- [`alpine-fat`, (*alpine-fat/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/alpine-fat/Dockerfile)
- [`armhf-xenial`, (*armhf-xenial/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/armhf-xenial/Dockerfile)
- [`centos`, (*centos/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/centos/Dockerfile)
- [`centos-rpm`, (*centos-rpm/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/centos-rpm/Dockerfile)
- [`jessie`, (*jessie/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/jessie/Dockerfile)
- [`stretch`, (*stretch/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/stretch/Dockerfile)
- [`trusty`, (*trusty/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/trusty/Dockerfile)
- [`wheezy`, (*wheezy/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/wheezy/Dockerfile)
- [`xenial`, (*xenial/Dockerfile*)](https://github.com/openresty/docker-openresty/blob/master/xenial/Dockerfile)


Starting with `1.13.6.1`, releases are tagged with `<openresty-version>-<image-version>-<flavor>`.  The latest `image-version` will also be tagged `<openresty-version>-<flavor>`.   The HEAD of the master branch is also labeled plainly as `<flavor>`.  The builds are managed by [Travis-CI](https://travis-ci.org/neomantra/docker-openresty).

For best stability, pin your images to the full tag, for example `1.13.6.1-0-xenial`.


Table of Contents
=================

* [Description](#description)
* [Usage](#usage)
* [OPM](#opm)
* [LuaRocks](#luarocks)
* [Tips & Pitfalls](#tips--pitfalls)
* [Docker CMD](#docker-entrypoint)
* [Building (from source)](#building-from-source)
* [Building (RPM based)](#building-rpm-based)
* [Building (DEB based)](#building-deb-based)
* [Feedback & Bug Reports](#feedback--bug-reports)
* [Changelog & Authors](#changelog--authors)
* [Copyright & License](#copyright--license)


Description
===========

`docker-openresty` is [Docker](https://www.docker.com) tooling for OpenResty (https://www.openresty.org).

Docker is a container management platform.

OpenResty is a full-fledged web application server by bundling the standard nginx core,
lots of 3rd-party nginx modules, as well as most of their external dependencies.

From non-RPM/DEB flavors, the following modules are included by default, but one can easily increase or decrease that with [custom build options](#build-options) :

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

nginx config files
==================

The Docker tooling installs its own [`nginx.conf` file](https://github.com/openresty/docker-openresty/blob/master/nginx.conf).  If you want to directly override it, you can replace it in your own Dockerfile or via volume bind-mounting.

That `nginx.conf` has the directive `include /etc/nginx/conf.d/*.conf;` so all nginx configurations in that directory will be included.  The [default virtual host configuration](https://github.com/openresty/docker-openresty/blob/master/nginx.vh.default.conf) has the original OpenResty configuration and is copied to `/etc/nginx/conf.d/default.conf`. 

You can override that `default.conf` directly or volume bind-mount the `/etc/nginx/conf.d` directory to your own set of configurations:

```
docker run -v /my/custom/conf.d:/etc/nginx/conf.d openresty/openresty:alpine
```

OPM
===

Starting at version 1.11.2.2, OpenResty includes a [package manager called `opm`](https://github.com/openresty/opm#readme), which can be found at `/usr/local/openresty/bin/opm`.

`opm` is built in all the images except `alpine` and `stretch`.

To use `opm` in the `alpine` image, you must also install the `curl` and `perl` packages; they are not included by default because they double the image size.  You may install them like so: `apk add --no-cache curl perl`.

To use `opm` in the `stretch` image, you must also install the `openresty-opm` package as shown in [this example](https://github.com/openresty/docker-openresty/blob/master/stretch/Dockerfile.opm_example).


LuaRocks
========

[LuaRocks](https://luarocks.org/) is included in the `alpine-fat`, `centos`, `centos-rpm`, `trusty`, and `xenial` variants.  It is excluded from `alpine` because it generally requires a build system and we want to keep that variant lean.

It is available at `/usr/local/openresty/luajit/bin/luarocks`.  Packages can be added in your dependent Dockerfiles like so:

```
RUN /usr/local/openresty/luajit/bin/luarocks install <rock>
```


Tips & Pitfalls
===============

 * The `envsubst` utility is included in all images except `alpine`; this utility is also included
 in the Nginx docker image and is used to template environment variables into configuration files.

 * **Docker Hub** does not currently support ARM builds, thus the `armhf-xenial` image is not available. (See [#26](https://github.com/openresty/docker-openresty/pull/26))

 * By default, OpenResty is built with SSE4.2 optimizations if the build machine supports it.  If run on machine without SSE4.2, there will be [invalid opcode issues](https://github.com/openresty/docker-openresty/issues/39). **Thus all the Docker Hub images require SSE4.2.**  You can [build a custom image from source](#building-from-source) explicitly without SSE4.2 support, using build arguments like so:
```
docker build -f xenial/Dockerfile --build-arg "RESTY_CONFIG_OPTIONS_MORE=--with-luajit-xcflags='-mno-sse4.2'" .
```


Docker CMD
==========

The `-g "daemon off;"` directive is used in the Dockerfile CMD to keep the Nginx daemon running after container creation. If this directive is added to the nginx.conf, then the `docker run` should explicitly invoke `openresty`:
```
docker run [options] openresty/openresty:xenial openresty
```

Invoke another CMD, for example the `resty` utility, like so:
```
docker run [options] openresty/openresty:xenial resty [script.lua]
```

*NOTE* The `alpine` images do not include the packages `perl` and `ncurses`, which is needed by the `resty` utility.


Building (from source)
======================

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
|RESTY_VERSION | 1.13.6.1 | The version of OpenResty to use. |
|RESTY_LUAROCKS_VERSION | 2.4.3 | The version of LuaRocks to use. |
|RESTY_OPENSSL_VERSION | 1.0.2k | The version of OpenSSL to use. |
|RESTY_PCRE_VERSION | 8.41 | The version of PCRE to use. |
|RESTY_J | 1 | Sets the parallelism level (-jN) for the builds. |
|RESTY_CONFIG_OPTIONS | "--with-file-aio --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_xslt_module=dynamic --with-ipv6 --with-mail --with-mail_ssl_module --with-md5-asm --with-pcre-jit --with-sha1-asm --with-stream --with-stream_ssl_module --with-threads" | Options to pass to OpenResty's `./configure` script. |
|RESTY_CONFIG_OPTIONS_MORE | "" | More options to pass to OpenResty's `./configure` script. |

[Back to TOC](#table-of-contents)


Building (RPM based)
====================

OpenResty now now has [RPMs available](http://openresty.org/en/rpm-packages.html).  The `centos-rpm` images use these RPMs rather than building from source.

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

 * [CentOS 7 RPM](https://github.com/openresty/docker-openresty/blob/master/centos-rpm/Dockerfile) (`centos-rpm/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_RPM_FLAVOR="-debug" centos-rpm
```

| Key | Default | Description |
:----- | :-----: |:----------- |
|RESTY_LUAROCKS_VERSION | 2.3.0 | The version of LuaRocks to use. |
|RESTY_RPM_FLAVOR | "" | The `openresty` package flavor to use.  Possibly `"-debug"` or `"-valgrind"`. |
|RESTY_RPM_VERSION | 1.11.2.5-1.el7.centos | The `openresty` package version to install. |
|RESTY_RPM_ARCH | x86_64 | The `openresty` package architecture to install. |

[Back to TOC](#table-of-contents)


Building (DEB based)
====================

OpenResty now now has [Debian Packages (DEBs) available](http://openresty.org/en/deb-packages.html).  The `stretch` image use these DEBs rather than building from source.

You can derive your own Docker images from this to install your own packages.  See [Dockerfile.opm_example](https://github.com/openresty/docker-openresty/blob/master/stretch/Dockerfile.opm_example) and [Dockerfile.luarocks_example](https://github.com/openresty/docker-openresty/blob/master/stretch/Dockerfile.luarocks_example).

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

 * [Debian Stretch 9 DEB](https://github.com/openresty/docker-openresty/blob/master/stretch/Dockerfile) (`stretch/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_DEB_FLAVOR="-debug" -f stretch/Dockerfile stretch
```

| Key | Default | Description |
:----- | :-----: |:----------- |
|RESTY_DEB_FLAVOR  | "" | The `openresty` package flavor to use.  Possibly `"-debug"` or `"-valgrind"`. |
|RESTY_DEB_VERSION | "=1.13.6.1-1~stretch1" | The Debian package version to use, with `=` prepended. |

[Back to TOC](#table-of-contents)


Feedback & Bug Reports
======================

You're very welcome to report bugs and give feedback as GitHub Issues:

https://github.com/openresty/docker-openresty/issues

[Back to TOC](#table-of-contents)


Changelog & Authors
===================

 * [CHANGELOG](https://github.com/openresty/docker-openresty/blob/master/CHANGELOG.md)
 * [AUTHORS](https://github.com/openresty/docker-openresty/blob/master/AUTHORS.md)

[Back to TOC](#table-of-contents)


Copyright & License
===================

`docker-openresty` is licensed under the 2-clause BSD license.

Copyright (c) 2017, Evan Wies <evan@neomantra.net>.

This module is licensed under the terms of the BSD license.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)
