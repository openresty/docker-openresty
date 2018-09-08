Changelog
=========

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
