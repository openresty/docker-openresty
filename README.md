Name
====

docker-openresty - Docker tooling for OpenResty

Table of Contents
=================

* [Description](#description)
* [Usage](#usage)
* [Build Options](#build-options)
* [Report Bugs](#report-bugs)
* [Copyright & License](#copyright--license)

Description
===========

`docker-openresty` is [Docker](https://www.docker.com) tooling for OpenResty (https://www.openresty.org).

Docker is a container management platform.

OpenResty is a full-fledged web application server by bundling the standard nginx core,
lots of 3rd-party nginx modules, as well as most of their external dependencies.

This tooling is maintained Evan Wies.

Usage
=====

 * **TODO: complete these run instructions**
 * **TODO: figure out base config, expose, etc**
 * **TODO: it is not actually on Docker Hub yet**

If you are happy with the defaults, then you can use the openresty image from the [Docker Hub](https://hub.docker.com/r/openresty/docker-openresty/)

```
docker run openresty/openresty 
```

Otherwise, it can be built by cloning the repo and running `docker build`.  The build can be customized; see [Build Options](#build-options) below.

```
git clone https://github.com/openresty/docker-openresty.git
cd docker-openresty
docker build  -t myopenresty .
docker run myopenresty 
```

Build Options
=============

The following are the available build-time options.  They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_J=4 .
```

| Key  | Default | Description |
:----- | :-----: |:----------- |
|RESTY_VERSION | 1.9.7.3 | The version of OpenResty to use. |
|RESTY_OPENSSL_VERSION | 1.0.2e | The version of OpenSSL to use. |
|RESTY_PCRE_VERSION | 8.38 | The version of PCRE to use. |
|RESTY_J | 1 | Sets the parallelism level (-jN) for the builds. |
|RESTY_CONFIG_OPTIONS | "--with-ipv6 --with-pcre-jit" | The options to pass to OpenResty's `./configure` script. |

[Back to TOC](#table-of-contents)

Report Bugs
===========

You're very welcome to report issues on GitHub:

https://github.com/openresty/docker-openresty/issues

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
