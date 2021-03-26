Changelog
=========

## 1.19.3.1-6

 * Upgrade OpenSSL to 1.1.1k for built-from-source images (alpine, bionic, focal)
 * Builds now happen at https://travis-ci.com/github/neomantra/docker-openresty (#169)

## 1.19.3.1-5

 * Upgrade OpenSSL to 1.1.1j for built-from-source images (alpine, bionic, focal)

## 1.19.3.1-4

 * Restructure travis.yml with build scripts
 * Add `centos7` flavor (#173) supporting both `x86_64` and `aarch64`

## 1.19.3.1-3

 * Upgrade `alpine` to Alpine 3.13.   `alpine-apk` is still at Alpine 3.12.
 * Upgrade LuaRocks to 3.5.0
 
## 1.19.3.1-2

 * Upgrade OpenSSL to 1.1.1i
 * Upstream OpenResty packages built on this tag also have OpenSSL to 1.1.1i

## 1.19.3.1-1

 * Remove `no-sse2` images as 1.19.3.1 now auto-detects SSE 4.2 support based on architecture (#168)

## 1.19.3.1-0

 * Upgrade OpenResty to 1.19.3.1 (#161)
 * Added some documentation to `nginx.conf` file
 * Set `pcre_jit on` in `nginx.conf`
 * Added gitignore

## 1.17.8.2-5

 * Fix alpine manifest (#160)

## 1.17.8.2-4

 * Bump `alpine` and `alpine-apk` to 3.12 to address CVE-2019-2201

## 1.17.8.2-3

 * Multi-architecture builds for `alpine`, supporting `amd64` and `arm64v8` (#130, #157)

## 1.17.8.2-2

 * Don't uninstall `make` in `centos` and `fedora` flavors (#154)
 * Install `lsb-base` dependency in `buster` flavor (#155)

## 1.17.8.2-1

 * Upgrade OpenSSL to 1.1.1 for build-from-source `bionic` and `focal` flavors
 * Add `fedora` built-from-upstream flavor (#150)

## 1.17.8.2-0

 * Upgrade OpenResty to 1.17.8.2
 * Add `RESTY_APK_VERSION` to  manage versions and build `-debug`

## 1.17.8.1-0

 * Upgrade OpenResty to 1.17.8.1 (#138)
 * Upgrade CentOS to 8
 * Upgrade LuaRocks to 3.3.1
 * Build-from-source flavors download from https://openresty.org/download/openresty
 * Add `alpine-apk` build-from-package flavor (#142)
 * Add `focal` build-from-source flavor
 * Move `xenial` and `stretch` to archive

## 1.15.8.3-2

 * Upgrade OpenSSL to 1.1.1g for `alpine` flavor (for CVE-2020-1967).

## 1.15.8.3-1

 * Upgrade PRCE to 8.44 for built-from-source flavors
 * Upgrade OpenSSL to 1.1.0l and 1.1.1f for built-from-source flavors
 * Add RESTY_OPENSSL_PATCH_VERSION and RESTY_OPENSSL_URL_BASE build args

## 1.15.8.3-0

* Upgrade OpenResty to 1.15.8.3
* Windows builds now use `servercore:ltsc2019` and `nanoserver:1809`

## 1.15.8.2-7

 * Add `buster-nosse2` and `buster-fat-nosse2` (#103)
 * Bump `alpine` to 3.11 to address CVE-2019-18276 (#135)

## 1.15.8.2-6

 * Add `RESTY_YUM_REPO` and `RESTY_RPM_DIST` build args to `centos`
 * Install more yum packages for `centos` builds
 * Add `amzn2` flavor, based on `centos`

## 1.15.8.2-5

 * Remove `VOLUME` directive and just `mkdir /var/run/openresty` (#128)

## 1.15.8.2-4

 * Add `buster` and `buster-fat` using upstream Debian packages

## 1.15.8.2-3

 * Fix broken `alpine` logging
 * Add `VOLUME` for temporary paths (#124) (but not for `windows`)

## 1.15.8.2-2 (broken, do not use)

 * Upgrade built-from-upstream packages (`stretch`, `centos`, `windows`) to 1.15.8.2
 * Upgrade LuaRocks to 3.2.1 (#122)
 * Move default writable temp paths to dedicated directories `/var/run/openresty` (#119)

## 1.15.8.2-1 (untagged in git)

 * Patch and build OpenSSL ourselves in built-from-source flavors (#117, #118)

## 1.15.8.2-0 (untagged in git)

For now (untagged release), the following only applies to built-from-source flavors (alpine/bionic/xenial). We are waiting for OpenResty upstream to release their packages for CentOS and Debian.

 * Upgrade OpenResty to 1.15.8.2
 * Upgrade PCRE to 8.43
 * Upgrade OpenSSL 1.1.0 versions to 1.1.0k
 * Download OpenResty source from github.com instead of openresty.org
 * README note about OpenSSL 1.1.1 / TLS 1.3 issues with ssl_session_(store|fetch)_by_lua* (affects `alpine` flavor)

## 1.15.8.1-4

 * enable --with-compat NGINX option in source-built images (#114)

## 1.15.8.1-3

 * Fix PCRE issues by building it ourselves (#22, #108)
 * Build Nginx with `-DNGX_LUA_ABORT_AT_PANIC` like upstream
 * Add `RESTY_LUAJIT_OPTIONS` build arg for harmony with upstream
     Defaults to `--with-luajit-xcflags='-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT'`
 * Tag `stretch` builds on `master` branch as the `latest` (#112)

## 1.15.8.1-2

 * Alpine upgraded to 3.9 with OpenSSL 1.1.1c (#94, #101)
 * Upgrade LuaRocks to 3.1.3
 * Windows installer and base images are more precisely specified and customizable
 * Add Docker labels for the image bases and add some label documentation

## 1.15.8.1-1

 * Fixed an error caused by '"' in executing apt (#95)

## 1.15.8.1-0

 * Upgrade OpenResty to 1.15.8.1
 * Add `-nosse42` builds to `alpine`, `xenial`, and `bionic` flavors (#103)

## 1.15.8.1rc2-1

 * Upgrade LuaRocks to 3.1.2 and change release URL (#100)
 * Downgrade alpine base image to 3.8 until OpenSSL 1.1.1 works (#99)

## 1.15.8.1rc2-0

 * Upgrade Openresty to 1.15.8.1rc2
 * Upgraded alpine base image to 3.9 (#94)
 * Install `outils-md5` on `alpine-fat` (#98)

## 1.15.8.1rc1-0

 * Upgrade Openresty to 1.15.8.1rc1
 * Upgrade LuaRocks to 3.0.4
 * Upgrade OpenSSL to 1.0.2r / 1.1.0j

 * Temporarily disable Travis builds of centos / stretch images
   until upstream packages are available

## 1.13.6.2-2

 * Add LUA_PATH and LUA_CPATH to ENV for LuaRocks (#53)
 * Add custom module building via build-args (#79)
 * Stop with SIGQUIT so that "docker stop" is actually a graceful stop (#80)

## 1.13.6.2-1

 * Added `bionic` image
 * Upgraded alpine base image to 3.8
 * Upgraded OpenSSL to 1.1.0i (xenial/bionic) and 1.0.2p (alpine)

## 1.13.6.2-0

 * Upgraded OpenResty to 1.13.6.2
 * Upgraded LuaRocks to 2.4.4 via GitHub Releases
 * Upgraded PCRE to 8.42
 * Upgraded OpenSSL to 1.1.0h (except Alpine is still at 1.0.2k)

 * Upgraded Windows build to 64-bit upstream and nanoserver (much smaller image!!)

 * Use build-args with `FROM` to give more flexible package building (and less Dockerfiles),
   with `RESTY_IMAGE_BASE` and `RESTY_IMAGE_TAG`.

 * Simplify availble images and archive old distributions,
   settling on alpine/xenial from source and centos/stretch from upsteam packages.

    * `centos-rpm` renamed to `centos`.  `centos-rpm` tag works but is deprecated.

    * Archive `armhf-xenial`, `centos`, `jessie`, `trusty`, `wheezy`

    * `alpine-fat` is now built on top of `alpine` rather than standalone

    * added `stretch-fat` image

## 1.13.6.1-2

 * Add Windows support

## 1.13.6.1-1

 * New docker tagging scheme
 * Travis CI build system (Thank you @travis-ci!!) (#62)
 * Add underlying package metadata as labels (#48)
 * Install custom nginx.conf with `include /etc/nginx/conf.d/*.conf`
   Long term this will make it easier to make docker-specifc changes.

## 1.13.6.1-0

 * Upgraded OpenResty to 1.13.6.1
 * Upgraded LuaRocks to 2.4.3 via GitHub Releases
 * Upgraded PCRE to 8.41
 * Add `bash` package to `alpine-fat`
 * Add `RESTY_DEB_VERSION`
 * Add `envsubst` utility
 * Add `RESTY_CONFIG_OPTIONS_MORE` build-arg to facilitate adding options (versus overriding them)
 * Use `CMD` instead of `ENTRYPOINT`

## 1.11.2.5  (2017-Aug-28)

 * Fixed `centos-rpm` installation of `opm` and `resty` (2017-Sep-06)
 * Upgraded OpenResty to 1.11.2.5
 * Update `centos-rpm` to 1.11.2.5-1 and use latest repos
 * Upgraded PCRE to 3.40
 * Add `stretch` using official Debian packages

## 1.11.2.4

 * Upgraded OpenResty to 1.11.2.4
 * Update `centos-rpm` to 1.11.2.4-1

## 1.11.2.3

 * Upgraded OpenResty to 1.11.2.3
 * Upgraded OpenSSL to 1.0.2k
 * Update `centos-rpm` to 1.11.2.3-1
 * Change PCRE download URL to https://ftp.pcre.org/pub/pcre
 * Add `armhf-xenial` image
 * Update `centos-rpm` to 1.11.2.2-8
 * Add `alpine-fat` image
 * Remove 'latest' tags

## 1.11.2.2

 * Upgraded OpenResty to 1.11.2.2
 * Add resty-opm package to `centos-rpm`
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
