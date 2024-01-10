Changelog
=========

## 1.21.4.3-3

 * Upgrade `alpine` built-from-source flavor to Alpine 3.19 (#244)

## 1.21.4.3-2

 * Upgrade `alpine-apk` flavor to Alpine 3.18 (#235)

## 1.21.4.3-1

 * Add Debian `bookworm` built-from-upstream flavor (#232)

## 1.21.4.3-0

 * Upgrade OpenResty to 1.21.4.3.  Addresses CVE-2023-44487 (#238)
 * Restore fedora aarch64 build

## 1.21.4.2-1

 * Update OpenSSL to `1.1.1w` for built-from-source flavors (#237)

## 1.21.4.2-0

 * Upgrade OpenResty to 1.21.4.2
 * Bump `fedora` flavor to FC36.
 * Upgrade LuaRocks to 3.9.2

## 1.21.4.1-8

 * Add Policies to README to clarify how we operate
 * Upgraded Alpine to `3.18` for `alpine` not `alpine-apk`
 * Update OpenSSL to `1.1.1u` for built-from-source flavors (#233)

## 1.21.4.1-7

 * Tagged rebuild to catch latest Alpine and more.
 * Remove Fedora aarch64 build (#229)

## 1.21.4.1-6

 * Added `centos/Dockerfile.expat_example` of installing expat from source (#221)
 * Upgraded Alpine to `3.17` for `alpine` not `alpine-apk` (#224)
 * Update OpenSSL to 1.1.1t for built-from-source flavors

## 1.21.4.1-5

 * Adds `RESTY_EVAL_POST_DOWNLOAD_PRE_CONFIGURE` build argument to run patches
   against OpenResty source download (#219).

## 1.21.4.1-4

 * Tag to update CI/CD with latest base images, 2022-11-30.

## 1.21.4.1-3

 * Update OpenSSL to 1.1.1q for built-from-source flavors (#212)
 * Ensure "fat" images are built from the correct RESTY_IMAGE_TAG_BASE (#211)
 * "Fat" Debian images now install the `resty` utility

## 1.21.4.1-2

 * Update OpenSSL to 1.1.1p for built-from-source flavors due to CVE-2022-2068
 * Remove `jammy` flavor on `s390x` architecture because the build rarely succeeds (#209)

## 1.21.4.1-1

 * Add `rocky` flavor, Rocky Linux built-from-upstream 
 * Add `s390x` architecture for built-from-source Ubuntu flavors, with PCRE JIT disabled
 * Upgrade built-from-source `alpine` to Alpine `3.16`

## 1.21.4.1-0

 * Upgrade OpenResty to 1.21.4.1
 * Upgrade PRCE to 8.45 for built-from-source flavors
 * Bump `fedora` flavor to FC35.

## 1.21.4.1rc3-1

 * LuaRocks 3.9.0 depends on wget (#204)

## 1.21.4.1rc3-0

 * Upgrade Openresty to 1.21.4.1rc3
   NOTE: only for build-from-source flavors `alpine`, `bionic`, `focal`, `jammy`

## 1.19.9.1-14

 * Update OpenSSL to 1.1.1q for built-from-source flavors (#212)
 * Ensure "fat" images are built from the correct RESTY_IMAGE_TAG_BASE (#211)
 * "Fat" Debian images now install the `resty` utility

## 1.19.9.1-13
  NOTE!!! The "fat" images for 1.19.9.1-13 are accidentally based on OpenResty 1.21.4.1.
          Other version tags are OK.

 * Update OpenSSL to 1.1.1p for built-from-source flavors due to CVE-2022-2068
 * Upgrade PRCE to 8.45 for built-from-source flavors
 * Upgrade built-from-source `alpine` to Alpine `3.16`
 * Bump `fedora` flavor to FC35.

## 1.19.9.1-12

 * LuaRocks 3.9.0 depends on wget (#204)

## 1.19.9.1-11

 * Update LuaRocks to 3.9.0
 * Add `jammy` build-from-source flavor for Ubuntu Jammy Jellyfish 22.04

## 1.19.9.1-10

 * Tagged rebuild to get zlib-1.2.12 due to CVE-2018-25032 (#202)

## 1.19.9.1-9

 * Upgrade alpine-apk Alpine to 3.15 (#196)

## 1.19.9.1-8

 * Tagged rebuild for CVE-2022-0778... all flavors covered

## 1.19.9.1-7

 * Tagged rebuild for CVE-2022-0778... covered flavors are:
    * all build-from-source flavors
    * upstream `amd64` flavors except `alpine-apk`

## 1.19.9.1-6

 * Update OpenSSL to 1.1.1n for built-from-source flavors due to CVE-2022-0778 (#200)
 * `centos` flavor (from EOL Centos 8) now uses yum repo http://vault.centos.org

## 1.19.9.1-5

 * Update LuaRocks to 3.8.0 (#197)

## 1.19.9.1-4

 * Update `alpine` to 3.15, but not `alpine-apk` (#196)

## 1.19.9.1-3

 * change ftp.pcre.org to SourceForge mirror for PCRE downloads (#193)
 * check SHA-256 of PCRE downloads (#193)

## 1.19.9.1-2

 * Add multi-arch upstream Debian Bullseye flavors `bullseye` and `bullseye-fat` (#191)
 * Update `fedora` flavor to FC 34 (#190)
 * Convert many http:// references to https://

## 1.19.9.1-1

 * Upgrade OpenSSL to 1.1.1l for built-from-source images (alpine, bionic, focal) (#189)
 * Upstream flavors are rebuilt with this tag and have 1.1.1l as well

## 1.19.9.1-0

 * Upgrade OpenResty to 1.19.9.1 (#188)
 * `alpine` and `alpine-apk` are both Alpine 3.14 (#187)
 * Build with Ubuntu Focal and latest Docker

## 1.19.3.2-3

 * -----XXXX Upgrade `alpine` to Alpine 3.14.   `alpine-apk` is still at Alpine 3.13.
 * Due to an error, this actually shipped with Alpine 3.13. See (#187)

## 1.19.3.2-2

 * Add multi-architecture image for Debian Buster (#184)
 * Builds happen again at https://travis-ci.com/github/openresty/docker-openresty

## 1.19.3.2-1

 * Expand multi-architecture to all images except Windows and Debian Buster
 * arm64 references are now referred to as aarch64 to match upstream
 * fix build script error propagation

## 1.19.3.2-0

 * Upgrade OpenResty to 1.19.3.2 (#181)
 * Upgrade `alpine-apk` to Alpine 3.13

## 1.19.3.1-8

 * "Fat" images now have RESTY_FAT_IMAGE_BASE label (#179)
 * Upgrade LuaRocks to 3.7.0

## 1.19.3.1-7

 * skipped because of my CI mistakes, use 1.19.3.1-8

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
