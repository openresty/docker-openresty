# Building Custom Images

Table of Contents
=================

* [Building (from source)](#building-from-source)
* [Building (RPM based)](#building-rpm-based)
* [Building (DEB based)](#building-deb-based)
* [Building (APK based)](#building-apk-based)
* [Building (Windows based)](#building-windows-based)

Building (from source)
======================

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

```
git clone https://github.com/openresty/docker-openresty.git
cd docker-openresty
docker build -t myopenresty -f bionic/Dockerfile .
docker run myopenresty
```

Dockerfiles are provided for the following base systems, selecting the Dockerfile path with `-f`:

 * [Alpine](https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile) (`alpine/Dockerfile`)
 * [Alpine Fat](https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile.fat) (`alpine/Dockerfile.fat`)
 * [Ubuntu Bionic](https://github.com/openresty/docker-openresty/blob/master/bionic/Dockerfile) (`bionic/Dockerfile`)
 * [Ubuntu Focal](https://github.com/openresty/docker-openresty/blob/master/focal/Dockerfile) (`focal/Dockerfile`)
 * [Ubuntu Jammy](https://github.com/openresty/docker-openresty/blob/master/jammy/Dockerfile) (`jammy/Dockerfile`)
 * [Ubuntu Noble](https://github.com/openresty/docker-openresty/blob/master/noble/Dockerfile) (`noble/Dockerfile`)

We used to support more build flavors but have trimmed that down.  Older Dockerfiles are archived in the [`archive`](https://github.com/openresty/docker-openresty/tree/master/archive) folder.


The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_J=4 -f jammy/Dockerfile .
```

| Key                                     | Default | Description |
|:-----------------------------------------| :-----: |:----------- |
| RESTY_IMAGE_BASE                        | "ubuntu" / "alpine" | The Debian or Alpine Docker image base to build `FROM`. |
| RESTY_IMAGE_TAG                         | "noble" / "3.22.2" | The Debian or Alpine Docker image tag to build `FROM`. |
| RESTY_VERSION                           | 1.27.1.2 | The version of OpenResty to use. |
| RESTY_LUAROCKS_VERSION                  | 3.12.2 | The version of LuaRocks to use. |
| RESTY_OPENSSL_VERSION                   | 3.5.5 | The version of OpenSSL to use. |
| RESTY_OPENSSL_PATCH_VERSION             | 3.5.5 | The version of OpenSSL to use when patching. |
| RESTY_OPENSSL_URL_BASE                  | "https://github.com/openssl/openssl/releases/download/openssl-${RESTY_OPENSSL_VERSION}" | The base of the URL to download OpenSSL from. |
| RESTY_OPENSSL_BUILD_OPTIONS             | "enable-camellia enable-seed enable-rfc3779 enable-cms enable-md2 enable-rc5 enable-weak-ssl-ciphers enable-ssl3 enable-ssl3-method enable-md2 enable-ktls enable-fips" | Options to tweak Resty's OpenSSL build. |
| RESTY_PCRE_VERSION                      | 10.44 | The version of PCRE2 to use. |
| RESTY_PCRE_SHA256                       | `86b9cb0aa3bcb7994faa88018292bc704cdbb708e785f7c74352ff6ea7d3175b` | The SHA-256 checksum of the PCRE2 package to check. |
| RESTY_PCRE_BUILD_OPTIONS                | "--enable-jit --enable-pcre2grep-jit --disable-bsr-anycrlf --disable-coverage --disable-ebcdic --disable-fuzz-support \
    --disable-jit-sealloc --disable-never-backslash-C --enable-newline-is-lf --enable-pcre2-8 --enable-pcre2-16 --enable-pcre2-32 \
    --enable-pcre2grep-callout --enable-pcre2grep-callout-fork --disable-pcre2grep-libbz2 --disable-pcre2grep-libz --disable-pcre2test-libedit \
    --enable-percent-zt --disable-rebuild-chartables --enable-shared --disable-static --disable-silent-rules --enable-unicode --disable-valgrind" | Options to tweak Resty's PCRE build.  | 
| RESTY_PCRE_OPTIONS                      | "--with-pcre-jit" | Options to tweak Resty's build args regarding PCRE. |
| RESTY_J                                 | 1 | Sets the parallelism level (-jN) for the builds. |
| RESTY_CONFIG_OPTIONS                    | "--with-compat --without-http_rds_json_module --without-http_rds_csv_module --without-lua_rds_parser --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_v3_module --with-http_xslt_module=dynamic --with-ipv6 --with-mail --with-mail_ssl_module --with-md5-asm --with-sha1-asm --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads" | Options to pass to OpenResty's `./configure` script. |
| RESTY_LUAJIT_OPTIONS                    | "--with-luajit-xcflags='-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT'" | Options to tweak LuaJIT. |
| RESTY_CONFIG_OPTIONS_MORE               | "" | More options to pass to OpenResty's `./configure` script. |
| RESTY_ADD_PACKAGE_BUILDDEPS             | "" | Additional packages to install with package manager required by build only (removed after installation) |
| RESTY_ADD_PACKAGE_RUNDEPS               | "" | Additional packages to install with package manager required at runtime (not removed after installation) |
| RESTY_EVAL_PRE_CONFIGURE                | "" | Command(s) to run prior to executing OpenResty's `./configure` script. (this can be used to clone a github repo of an extension you want to add to OpenResty, for example.  In that case, dont forget to add the appropriate argument to the RESTY_CONFIG_OPTIONS_MORE argument as described above). |
| RESTY_EVAL_POST_DOWNLOAD_PRE_CONFIGURE  | "" | Command(s) to run after downloading and extracting OpenResty's source tarball, but prior to executing OpenResty's `./configure` script. Working directory will be the extracted OpenResty source directory. |
| RESTY_EVAL_PRE_MAKE                     | "" | Command(s) to run before running `make install`.  |
| RESTY_EVAL_POST_MAKE                    | "" | Command(s) to run after running `make install`.  |
| RESTY_STRIP_BINARIES                    | "" | Set to non-zero to strip binaries in Alpine images. |
These built-from-source flavors include the following modules by default, but one can easily increase or decrease that with the custom build options above:

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
 * http_v3_module
 * http_xslt_module=dynamic
 * ipv6
 * mail
 * mail_ssl_module
 * md5-asm
 * pcre-jit
 * sha1-asm
 * stream
 * stream_ssl_module
 * stream_ssl_preread_module
 * threads

[Back to TOC](#table-of-contents)


Building (RPM based)
====================

OpenResty now now has [RPMs available](https://openresty.org/en/rpm-packages.html).  The `centos` and `fedora` images use these RPMs rather than building from source.

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

 * [CentOS 7 RPM](https://github.com/openresty/docker-openresty/blob/master/centos7/Dockerfile) (`centos/Dockerfile`)
 * [CentOS 8 RPM](https://github.com/openresty/docker-openresty/blob/master/centos/Dockerfile) (`centos/Dockerfile`)
 * [Fedora 35 RPM](https://github.com/openresty/docker-openresty/blob/master/fedora/Dockerfile) (`centos/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_RPM_FLAVOR="-debug" centos7/Dockerfile .
docker build --build-arg RESTY_RPM_FLAVOR="-debug" centos/Dockerfile .
docker build --build-arg RESTY_RPM_FLAVOR="-debug" -f fedora/Dockerfile .
```

| Key | Default | Description |
|:----- | :-----: |:----------- |
|RESTY_IMAGE_BASE | "centos" | The Centos Docker image base to build `FROM`. |
|RESTY_IMAGE_TAG | "8" | The CentOS Docker image tag to build `FROM`. |
|RESTY_LUAROCKS_VERSION | 3.12.2 | The version of LuaRocks to use. |
|RESTY_YUM_REPO | "https://openresty.org/package/centos/openresty.repo" | URL for the OpenResty YUM Repository. |
|RESTY_RPM_FLAVOR | "" | The `openresty` package flavor to use.  Possibly `"-debug"` or `"-valgrind"`. |
|RESTY_RPM_VERSION | "1.27.1.2-1" | The `openresty` package version to install. |
|RESTY_RPM_DIST | "el8" | The `openresty` package distribution to install. |
|RESTY_RPM_ARCH | "x86_64" | The `openresty` package architecture to install. |

[Back to TOC](#table-of-contents)


Building (DEB based)
====================

OpenResty now now has [Debian Packages (DEBs) available](https://openresty.org/en/deb-packages.html).  The `bullseye` image use these DEBs rather than building from source.

You can derive your own Docker images from this to install your own packages.  See [bookworm/Dockerfile.fat](https://github.com/openresty/docker-openresty/blob/master/bookworm/Dockerfile.fat) and [buster/Dockerfile.luarocks_example](https://github.com/openresty/docker-openresty/blob/master/archive/buster/Dockerfile.luarocks_example).

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

 * [Debian Bookworm 12 DEB](https://github.com/openresty/docker-openresty/blob/master/bookworm/Dockerfile) (`bookworm/Dockerfile`)
 * [Debian Bullseye 11 DEB](https://github.com/openresty/docker-openresty/blob/master/bullseye/Dockerfile) (`bullseye/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_DEB_FLAVOR="-debug" -f bullseye/Dockerfile .
```

| Key | Default | Description |
:----- | :-----: |:----------- |
|RESTY_APT_REPO    | "https://openresty.org/package/debian" | Apt repo to load from. |
|RESTY_APT_PGP     | "https://openresty.org/package/pubkey.gpg" | URL to download APT PGP key from |
|RESTY_APT_ARCH    | `amd64` | Architecture for APT lookups |
|RESTY_IMAGE_BASE  | "debian" | The Debian Docker image base to build `FROM`. |
|RESTY_IMAGE_TAG   | "bullseye-slim" | The Debian Docker image tag to build `FROM`. |
|RESTY_DEB_FLAVOR  | "" | The `openresty` package flavor to use.  Possibly `"-debug"` or `"-valgrind"`. |
|RESTY_DEB_VERSION | "=1.27.1.2-1~bookworm1" | The [Debian package version](https://openresty.org/package/debian/pool/openresty/o/openresty/) to use, with `=` prepended. |
|RESTY_FAT_DEB_FLAVOR  | "" | The `openresty` package flavor to use to install "fat" packages.  Possibly `"-debug"` or `"-valgrind"`. |
|RESTY_FAT_DEB_VERSION | "=1.27.1.2-1~bookworm1" | The [Debian package version](https://openresty.org/package/debian/pool/openresty/o/openresty/) to use to "fat" packages, with `=` prepended. |

 * For `amd64` builds, `RESTY_APT_REPO="https://openresty.org/package/debian"`
 * For `arm64` builds, `RESTY_APT_REPO="https://openresty.org/package/arm64/debian"`

[Back to TOC](#table-of-contents)


Building (APK based)
====================

OpenResty now now has [Alpine Packagesx-5q (APKs) available](https://openresty.org/en/apk-packages.html).  The `alpine-apk` image use these APKs rather than building from source.  You can derive your own Docker images from this to install your own packages.

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

 * [Alpine APK](https://github.com/openresty/docker-openresty/blob/master/alpine-apk/Dockerfile) (`alpine-apk/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_IMAGE_TAG="3.12" -f alpine-apk/Dockerfile .
```

| Key | Default | Description |
|:----- | :-----: |:----------- |
|RESTY_IMAGE_BASE   | "alpine" | The Alpine Docker image base to build `FROM`. |
|RESTY_IMAGE_TAG    | "3.18.12" | The Alpine Docker image tag to build `FROM`. |
|RESTY_APK_ALPINE_VERSION | "3.18" | The Alpine version for RESTY_APK_REPO_URL. |
|RESTY_APK_KEY_URL  | "https://openresty.org/package/admin@openresty.com-5ea678a6.rsa.pub" | The URL of the signing key of the `openresty` package. |
|RESTY_APK_REPO_URL | "https://openresty.org/package/alpine/v${RESTY_APK_ALPINE_VERSION}/main" | The URL of the APK repository for `openresty` package. |
|RESTY_APK_VERSION | "=1.27.1.2-r0" | The suffix to add to the apk install package name: `openresty${RESTY_APK_VERSION`}. |

[Back to TOC](#table-of-contents)


Building (Windows based)
========================

This Docker image can be built and customized by cloning the repo and running `docker build` with the desired Dockerfile:

 * [Windows](https://github.com/openresty/docker-openresty/blob/master/centos-rpm/Dockerfile) (`windows/Dockerfile`)

The following are the available build-time options. They can be set using the `--build-arg` CLI argument, like so:

```
docker build --build-arg RESTY_VERSION="1.27.1.2" -f windows/Dockerfile .
```

| Key | Default | Description |
|:----- | :-----: |:----------- |
|RESTY_INSTALL_BASE | "mcr.microsoft.com/dotnet/framework/runtime" | The Windows Server Docker image name to download and install OpenResty with. |
|RESTY_INSTALL_TAG  | "4.8-windowsservercore-ltsc2019" | The Windows Server Docker image name to download and install OpenResty with. |
|RESTY_IMAGE_BASE   | "mcr.microsoft.com/windows/nanoserver" | The Windows Server Docker image name to build `FROM` for final image. |
|RESTY_IMAGE_TAG    | "1809" | The Windows Server Docker image tag to build `FROM` for final image. |
|RESTY_VERSION      | 1.27.1.2 | The version of OpenResty to use. |

[Back to TOC](#table-of-contents)

GitHub Actions
==============

The GitHub Actions to build is located in the [`.github/workflows/docker-publish.yml`](./.github/workflows/docker-publish.yml) file.

| Environment Variable | Description |
|:---------------------|:----------- |
| GHCR_IMAGE | GitHub Container Registry image |
| DOCKERHUB_IMAGE | Docker Hub image |

| Secrets | Description |
|:---------------------|:----------- |
| GHCR_USERNAME | GitHub Container Registry username |
| GHCR_PASSWORD | GitHub Container Registry password |
| DOCKERHUB_USERNAME | Docker Hub username |
| DOCKERHUB_PASSWORD | Docker Hub password |


End-To-End Tests
================

The script [`./tests/e2e/run-test.sh`](./tests/e2e/run-test.sh) will stand up two local container registries and attempt to build all the images.

