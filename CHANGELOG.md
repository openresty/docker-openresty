Changelog
=========

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
