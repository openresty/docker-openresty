# Dockerfile - OpenResty Source Branch build against Debian Trixie
# https://github.com/openresty/docker-openresty

ARG RESTY_IMAGE_BASE="debian"
ARG RESTY_IMAGE_TAG="trixie-slim"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG} AS resty-base
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bash \
        busybox \
        ca-certificates \
        coreutils \
        curl

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG} AS asfald-download

# Do not update this.
# Simply download asfald-latest with this version instead.
# Later versions removed the feature we depend upon.
ARG ASFALD_VERSION="0.6.0"

ARG ASFALD_FILE_AMD64="asfald-x86_64-unknown-linux-musl"
ARG ASFALD_FILE_ARM64="asfald-aarch64-unknown-linux-musl"

ARG SHA256_ASFALD_AMD64="017cdc44d767bb4733a3bd3fa5f97719e3f58236d006321dfae1924fdda3de9d"
ARG SHA256_ASFALD_ARM64="4fc112617a71f97592b8760b98c16339d5243577186c970c784fbcab2ef8abd1"

ARG DESTDIR="/downloaded"
ARG CHECKSUM_ALGORITHM="sha256"

ARG ASFALD_DOWNLOAD_URI="asfaload/asfald/releases/download/v${ASFALD_VERSION}"
ARG ASFALD_URL="https://github.com/${ASFALD_DOWNLOAD_URI}"

# Let Docker download and cache these files for us
ADD "${ASFALD_URL}/checksums.txt" "${DESTDIR}/"
ARG ASFALD_CHECKSUM_AMD64="${CHECKSUM_ALGORITHM}:${SHA256_ASFALD_AMD64}"
ARG ASFALD_CHECKSUM_ARM64="${CHECKSUM_ALGORITHM}:${SHA256_ASFALD_ARM64}"
ADD --checksum="${ASFALD_CHECKSUM_AMD64}" "${ASFALD_URL}/${ASFALD_FILE_AMD64}" "${DESTDIR}/"
ADD --checksum="${ASFALD_CHECKSUM_ARM64}" "${ASFALD_URL}/${ASFALD_FILE_ARM64}" "${DESTDIR}/"

ARG TARGETARCH
RUN set -eu ; \
    decide_fn() { \
      case "${TARGETARCH}" in \
        (amd64) printf -- '%s\n' "${ASFALD_FILE_AMD64}" ;; \
        (arm64) printf -- '%s\n' "${ASFALD_FILE_ARM64}" ;; \
        (*) printf -- '%s\n' 'fallback-to-busybox.sh' ;; \
      esac ; \
    } ; \
\
    { \
        printf -- '%s\n' '#!/usr/bin/env sh' '' \
            '_cleanup() { case "${1}" in' \
            '    (register) [ -n "${2}" ] && _cleanup_registry="${_cleanup_registry}${2}\000" ;;' \
            '    (clear)' \
            '        busybox printf "%b" "${_cleanup_registry}" | busybox xargs -r -0 busybox rm -f;' \
            '        _cleanup_registry="";' \
            '        ;;' \
            '    esac;' \
            '}' '_cleanup_registry="";' 'trap "_cleanup clear" EXIT;' '' \
            '_get_url() {' \
            '    _o="${1}"; shift;' \
            '    _u="${1}"; shift;' \
            '    if [ 1 -eq "${USE_CURL:-0}" ]; then' \
            '        curl -fsSLo "${_o}" -- "${_u}";' \
            '    else' \
            '        busybox wget -O "${_o}" "${@}" -- "${_u}";' \
            '    fi;' \
            '    _rc="${?}";' \
            '    unset -v _o _u;' \
            '    return "${_rc}";' \
            '}' '' \
            '_stderr() {' \
            '    printf 1>&2 -- "%s\n" "${@}";' \
            '}' '' \
            'extract_gh_digests() {' \
            '    busybox awk -e '\' \
            '      /clipboard digest for / {' \
            '        td=gensub(/<clipboard-copy (.+)>/, "\\1", "g");' \
            '        d=gensub(/^.* value="[^:]+:([^"]+)".*$/, "\\1", 1, td);' \
            '        f=gensub(/^.* aria-label=".+digest for ([^"]+)".*$/, "\\1", 1, td);' \
            '        print d " *" f;' \
            '      }' \
            '    '\'';' \
            '}' '' \
            'find_hash_for_file() {' \
            '    _f="${1}"; shift;' \
            '    busybox awk -v file="${_f}" -e '\''$0 ~ " [* ]" file "$" {print $1; exit;}'\'' "${@}";' \
            '    unset -v _f;' \
            '}' '' \
            'get_from_gh_url() { case "${1}" in' \
            '    (owner)' \
            '        busybox awk -v url="${2}" -e '\' \
            '          END {' \
            '            print gensub(/^https?:\/\/github\.com\/([^\/]+)\/.*$/, "\\1", 1, url);' \
            '          }' \
            '        '\'' </dev/null;' \
            '        ;;' \
            '    (repo)' \
            '        busybox awk -v url="${2}" -e '\' \
            '          END {' \
            '            print gensub(/^https?:\/\/github\.com\/[^\/]+\/([^\/]+)\/.*$/, "\\1", 1, url);' \
            '          }' \
            '        '\'' </dev/null;' \
            '        ;;' \
            '    (tag)' \
            '        _url="${2}";' \
            '        if is_gh_tag_url "${_url}"; then' \
            '            busybox basename "${_url}";' \
            '        elif is_gh_download_url "${_url}"; then' \
            '            _tag_url="$(busybox dirname "${_url}")";' \
            '            busybox basename "${_tag_url}";' \
            '            unset -v _tag_url;' \
            '        fi;' \
            '        unset -v _url;' \
            '        ;;' \
            '    esac;' \
            '}' '' \
            'get_gh_digests_from_tag() {' \
            '    _url="$(printf -- "https://github.com/%s/%s/releases/expanded_assets/%s\n" "${1}" "${2}" "${3}")";' \
            '    _get_url - "${_url}" -q | extract_gh_digests;' \
            '    unset -v _url;' \
            '}' '' \
            'is_gh_download_url() { case "${1}" in' \
            '    (http*://github.com/*/releases/download/*) return 0 ;;' \
            '    esac;' \
            '    return 1;' \
            '}' '' \
            'is_gh_tag_url() { case "${1}" in' \
            '    (http*://github.com/*/releases/tag/*) return 0 ;;' \
            '    esac;' \
            '    return 1;' \
            '}' '' \
            'for _arg in "${@}"; do case "${_arg}" in' \
            '    (--force-absent|-f) _verified=1 ;;' \
            '    (--hash|-H) _set_H=1 ;;' \
            '    (--output|-o) _set_o=1 ;;' \
            '    (--pattern|-p) _set_p=1 ;;' \
            '    (*)' \
            '        if [ 1 -eq "${_set_H:-0}" ]; then hash="${_arg}"; unset -v _set_H ; fi ;' \
            '        if [ 1 -eq "${_set_o:-0}" ]; then output="${_arg}"; unset -v _set_o ; fi ;' \
            '        if [ 1 -eq "${_set_p:-0}" ]; then pattern="${_arg}"; unset -v _set_p ; fi ;' \
            '        url="${_arg}"' \
            '        ;;' \
            'esac; done; unset -v _arg ;' '' \
            'if [ -z "${output-}" ]; then output="$(busybox basename "${url}")"; fi;' \
            'if [ -z "${hash-}" ] && [ -n "${pattern-}" ]; then' \
            '    cs_url="$(busybox awk '\\ \
            '        -v file="$(busybox basename "${url}")" '\\ \
            '        -v fullpath="${url}" '\\ \
            '        -v path="$(busybox dirname "${url}")" '\\ \
            '        -v pattern="${pattern}" -e '\' \
            '      END {' \
            '        out = gensub(/[$][{]file[}]/, file, "g", pattern);' \
            '        out = gensub(/[$][{]fullpath[}]/, fullpath, "g", out);' \
            '        out = gensub(/[$][{]path[}]/, path, "g", out);' \
            '        print out;' \
            '      }' \
            '    '\'' </dev/null)";' \
            'fi;' \
            'gh_tag="$(get_from_gh_url "tag" "${url}")";' \
            'if [ -z "${hash-}" ] && [ -n "${gh_tag}" ]; then' \
            '    gh_owner="$(get_from_gh_url "owner" "${url}")";' \
            '    gh_repo="$(get_from_gh_url "repo" "${url}")";' \
            '    csfile="$(busybox mktemp)" && _cleanup register "${csfile}" &&' \
            '    get_gh_digests_from_tag "${gh_owner}" "${gh_repo}" "${gh_tag}" > "${csfile}" &&' \
            '    hash="$(find_hash_for_file "$(busybox basename "${url}")" "${csfile}")";' \
            '    [ -s "${csfile}" ] || _stderr "Warning: No digests extracted for any artifacts at GitHub.com!";' \
            '    [ -n "${hash}" ] || _stderr "Warning: No digest found at GitHub.com!";' \
            'fi;' \
            'dlfile="$(busybox mktemp)" &&' \
            '    _cleanup register "${dlfile}" &&' \
            '    { [ -z "${cs_url-}" ] || { _get_url "${dlfile}" "${cs_url}" -q && hash="$(find_hash_for_file "$(busybox basename "${url}")" "${dlfile}")" ; [ -n "${hash-}" ]; } ; } &&' \
            '    _get_url "${dlfile}" "${url}" &&' \
            '    { [ -z "${hash-}" ] || { busybox printf -- "%s *%s\n" "${hash-}" "${dlfile}" | busybox sha256sum -cw && _verified=1 || _verified=0; } ; } &&' \
            '    { [ "-" = "${output-}" ] && busybox cat "${dlfile}" || [ 1 -eq "${_verified:-0}" ] && busybox mv -fT "${dlfile}" "${output-}" ; } ;' \
        ; \
    } > "${DESTDIR}/fallback-to-busybox.sh" ; \
\
    file="$(decide_fn)" ; \
    install -v -D -m 00755 -o root -g root "${DESTDIR}/${file}" "/verified/${TARGETARCH}/asfald"

FROM scratch AS asfald
ARG TARGETARCH
COPY --from=asfald-download "/verified/${TARGETARCH}/asfald" /usr/local/sbin/

FROM resty-base AS with-asfald
COPY --from=asfald /usr/local/sbin/ /usr/local/sbin/

ARG TARGETARCH
RUN set -eu ; \
\
    decide_arch() { \
      case "${TARGETARCH}" in \
        (amd64) printf -- 'x86_64' ;; \
        (arm64) printf -- 'aarch64' ;; \
      esac ; \
    } ; \
    decide_latest_tag() { \
        busybox wget -q -S -O /dev/null \
            "https://github.com/${1}/${2}/releases/latest" 2>&1 | \
            busybox awk -F : -e 'tolower($1) ~ /^[[:space:]]*location$/ { n = split($NF, P, "/"); print P[n]; exit; }' ; \
    } ; \
\
    set -x ; arch="$(decide_arch)" ; \
    dest='/usr/local/sbin/asfald-latest' ; \
    if [ -z "${arch}" ]; then ln -s asfald "${dest}" ; exit 0; fi ; \
    gh_releases_uri='github.com/asfaload/asfald/releases' ; \
    TMPDIR="$(busybox dirname "${dest}")" \
    asfald --overwrite --output "${dest}" \
        --pattern '${path}/checksums.txt' -- \
        "https://${gh_releases_uri}/latest/download/asfald-${arch}-unknown-linux-musl" && \
    busybox chmod -c 00755 "${dest}" && busybox chown -c root:root "${dest}" ; \
\
    checksums_base_uri="https://gh.checksums.asfaload.com/${gh_releases_uri}/download" ; \
    latest_version="$(decide_latest_tag 'asfaload' 'asfald')" ; \
    checksums_url="${checksums_base_uri}/${latest_version}/checksums.txt" ; \
    dest="$(busybox mktemp)" ; \
    TMPDIR="$(busybox dirname "${dest}")" \
    asfald --overwrite --output "${dest}" \
        --quiet --force-absent --no-asfaload-index -- "${checksums_url}" ; \
    specific_checksum="$(busybox awk -v dl="asfald-${arch}-unknown-linux-musl" -e '$NF ~ dl "$" { print $1; exit; }' "${dest}" ; busybox rm -f "${dest}")" ; \
    (cd /usr/local/sbin && busybox printf -- '%s *%s\n' "${specific_checksum}" 'asfald-latest' | cksum --algorithm='sha256' --check --strict --warn || busybox rm -f 'asfald-latest') ; \
    [ -x /usr/local/sbin/asfald-latest ] ; \
    specific_checksum="$(asfald-latest --get-hash "https://${gh_releases_uri}/download/${latest_version}/asfald-${arch}-unknown-linux-musl" | busybox head -n 1)" ; \
    (cd /usr/local/sbin && busybox printf -- '%s *%s\n' "${specific_checksum##*:}" 'asfald-latest' | cksum --algorithm="${specific_checksum%%:*}" --check --strict --warn || busybox rm -f 'asfald-latest') ; \
    [ -x /usr/local/sbin/asfald-latest ] ;

FROM with-asfald
SHELL ["/usr/bin/env", "bash", "-c"]

LABEL maintainer="Evan Wies <evan@neomantra.net>"

# Docker Build Arguments
ARG RESTY_VERSION="v1.29.2.4" # Uses the full tag name, hence 'v' prefix
ARG RESTY_SHA256="a9de2d4e7e20e31e439a85960300e1146837a9e33761d27ecb8964bef215aa85"
ARG RESTY_LUAROCKS_VERSION="3.13.0"
ARG RESTY_LUAROCKS_SHA256="245bf6ec560c042cb8948e3d661189292587c5949104677f1eecddc54dbe7e37"

# https://github.com/openresty/openresty-packaging/blob/master/deb/openresty-openssl3/debian/rules
ARG RESTY_OPENSSL_VERSION="3.5.6"
ARG RESTY_OPENSSL_SHA256="deae7c80cba99c4b4f940ecadb3c3338b13cb77418409238e57d7f31f2a3b736"
ARG RESTY_OPENSSL_PATCH_VERSION="3.5.5"
ARG RESTY_OPENSSL_PATCH_SHA256="0a30cc762a9d72901e8415a33f7671bb68469d46121061e26afe7b718f47581e"
ARG RESTY_OPENSSL_URL_BASE="https://github.com/openssl/openssl/releases/download/openssl-${RESTY_OPENSSL_VERSION}"
# LEGACY:  "https://www.openssl.org/source/old/1.1.1"
ARG RESTY_OPENSSL_BUILD_OPTIONS="enable-camellia enable-seed enable-rfc3779 enable-cms enable-md2 enable-rc5 \
        enable-weak-ssl-ciphers enable-ssl3 enable-ssl3-method enable-md2 enable-ktls enable-fips \
        "

# https://github.com/openresty/openresty-packaging/blob/master/deb/openresty-pcre2/debian/rules
ARG RESTY_PCRE_VERSION="10.47"
ARG RESTY_PCRE_SHA256="c08ae2388ef333e8403e670ad70c0a11f1eed021fd88308d7e02f596fcd9dc16"
ARG RESTY_PCRE_BUILD_OPTIONS="--enable-jit --enable-pcre2grep-jit --disable-bsr-anycrlf --disable-coverage --disable-ebcdic --disable-fuzz-support \
    --disable-jit-sealloc --disable-never-backslash-C --enable-newline-is-lf --enable-pcre2-8 --enable-pcre2-16 --enable-pcre2-32 \
    --enable-pcre2grep-callout --enable-pcre2grep-callout-fork --disable-pcre2grep-libbz2 --disable-pcre2grep-libz --disable-pcre2test-libedit \
    --enable-percent-zt --disable-rebuild-chartables --enable-shared --disable-static --disable-silent-rules --enable-unicode --disable-valgrind \
    "

ARG RESTY_J="1"

# https://github.com/openresty/openresty-packaging/blob/master/deb/openresty/debian/rules
ARG RESTY_CONFIG_OPTIONS="\
    --with-compat \
    --without-http_rds_json_module \
    --without-http_rds_csv_module \
    --without-lua_rds_parser \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_v3_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-threads \
    "
ARG RESTY_CONFIG_OPTIONS_MORE=""
ARG RESTY_LUAJIT_OPTIONS="--with-luajit-xcflags='-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT'"
ARG RESTY_PCRE_OPTIONS="--with-pcre-jit"

ARG RESTY_ADD_PACKAGE_BUILDDEPS=""
ARG RESTY_ADD_PACKAGE_RUNDEPS=""
ARG RESTY_EVAL_PRE_CONFIGURE=""
ARG RESTY_EVAL_POST_DOWNLOAD_PRE_CONFIGURE=""
ARG RESTY_EVAL_PRE_MAKE=""
ARG RESTY_EVAL_POST_MAKE=""

# These are not intended to be user-specified
ARG _RESTY_CONFIG_DEPS="--with-pcre \
    --with-cc-opt='-DNGX_LUA_ABORT_AT_PANIC -I/usr/local/openresty/pcre2/include -I/usr/local/openresty/openssl3/include' \
    --with-ld-opt='-L/usr/local/openresty/pcre2/lib -L/usr/local/openresty/openssl3/lib -Wl,-rpath,/usr/local/openresty/pcre2/lib:/usr/local/openresty/openssl3/lib' \
    "

ARG RESTY_IMAGE_BASE RESTY_IMAGE_TAG
LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"

LABEL resty_version="${RESTY_VERSION}"
LABEL resty_sha256="${RESTY_SHA256}"
LABEL resty_luarocks_version="${RESTY_LUAROCKS_VERSION}"
LABEL resty_luarocks_sha256="${RESTY_LUAROCKS_SHA256}"
LABEL resty_openssl_version="${RESTY_OPENSSL_VERSION}"
LABEL resty_openssl_sha256="${RESTY_OPENSSL_SHA256}"
LABEL resty_openssl_patch_version="${RESTY_OPENSSL_PATCH_VERSION}"
LABEL resty_openssl_patch_sha256="${RESTY_OPENSSL_PATCH_SHA256}"
LABEL resty_openssl_url_base="${RESTY_OPENSSL_URL_BASE}"
LABEL resty_openssl_build_options="${RESTY_OPENSSL_BUILD_OPTIONS}"
LABEL resty_pcre_version="${RESTY_PCRE_VERSION}"
LABEL resty_pcre_sha256="${RESTY_PCRE_SHA256}"
LABEL resty_pcre_build_options="${RESTY_PCRE_BUILD_OPTIONS}"
LABEL resty_config_options="${RESTY_CONFIG_OPTIONS}"
LABEL resty_config_options_more="${RESTY_CONFIG_OPTIONS_MORE}"
LABEL resty_config_deps="${_RESTY_CONFIG_DEPS}"
LABEL resty_add_package_builddeps="${RESTY_ADD_PACKAGE_BUILDDEPS}"
LABEL resty_add_package_rundeps="${RESTY_ADD_PACKAGE_RUNDEPS}"
LABEL resty_eval_pre_configure="${RESTY_EVAL_PRE_CONFIGURE}"
LABEL resty_eval_post_download_pre_configure="${RESTY_EVAL_POST_DOWNLOAD_PRE_CONFIGURE}"
LABEL resty_eval_pre_make="${RESTY_EVAL_PRE_MAKE}"
LABEL resty_eval_post_make="${RESTY_EVAL_POST_MAKE}"
LABEL resty_luajit_options="${RESTY_LUAJIT_OPTIONS}"
LABEL resty_pcre_options="${RESTY_PCRE_OPTIONS}"



RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        dos2unix \
        git \
        make \
        mercurial \
        patch \
        perl \
        unzip \
        wget \
    && checksum_archives() ( cd work \
        && cksum --algorithm='sha256' --binary --untagged * \
    ) \
    && fetch_archives() ( cd work \
        && curl --config .curl-config --parallel --parallel-max 4 \
        --fail --location --connect-timeout 10 --retry 3 --retry-delay 2 \
        --remove-on-error --remote-time --silent --show-error \
        --write-out 'HTTP: %{http_code}  Wrote: %{size_download} bytes\t%{filename_effective}\nURL: %{url_effective}\n\n' \
    ) \
    && cd /tmp \
    && mkdir -v -p openresty_src.tmp/work \
    && cd openresty_src.tmp \
    && printf > work/.curl-config -- '%s\n' \
        'output = openresty-'"${RESTY_VERSION#v}"'.tar.gz' \
        'url = "https://github.com/openresty/openresty/archive/refs/tags/'"${RESTY_VERSION}"'.tar.gz"' \
    && fetch_archives && checksum_archives \
    && TMPDIR="${PWD}/work" asfald --overwrite \
        --hash "${RESTY_SHA256}" \
        --output 'work/openresty.tar.gz' -- \
        "https://github.com/openresty/openresty/archive/refs/tags/${RESTY_VERSION}.tar.gz" \
    && cd /tmp \
    && tar xzf openresty_src.tmp/work/openresty.tar.gz \
    && mv openresty-*/ openresty_src \
    && rm -rf openresty_src.tmp \
    && mkdir -v -p openresty_src/work \
    && cd openresty_src \
    && ( . util/ver >/dev/null \
        && busybox grep -B 1 -e '^[$]root/util/get-tarball ' util/mirror-tarballs | busybox sed -e 's@ver="$main_ver"@ver="'"${main_ver}"'"@;' \
    ) > work/.calls \
    && busybox awk -e '/^ver=/ { ver=gensub(/^ver="?([^"]+)"?$/, "\\1", 1); } $1 ~ /\/util\/get-tarball$/ { gsub(/[$][{]?ver[}]?/, ver); ofp=gensub(/^"?([^"]+)"?$/, "\\1", 1, $4); print "output","=",ofp; if (0 == system("test -s '\''" ofp "'\''")) { print "time-cond","=",ofp; }; print "url","=",$2; }' < work/.calls > work/.curl-config \
    && fetch_archives && checksum_archives \
    && make \
    && mv openresty-*.tar.gz "/tmp/openresty-${RESTY_VERSION}.tar.gz" \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        gettext-base \
        libgd-dev \
        libgeoip-dev \
        libncurses5-dev \
        libperl-dev \
        libreadline-dev \
        libxslt1-dev \
        zlib1g-dev \
        ${RESTY_ADD_PACKAGE_BUILDDEPS} \
        ${RESTY_ADD_PACKAGE_RUNDEPS} \
    && cd /tmp \
    && if [ -n "${RESTY_EVAL_PRE_CONFIGURE}" ]; then eval $(echo ${RESTY_EVAL_PRE_CONFIGURE}); fi \
    && TMPDIR="${TMPDIR:-/tmp}" asfald --overwrite \
        --hash "${RESTY_OPENSSL_SHA256}" \
        --output "${TMPDIR:-/tmp}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz" -- \
        "${RESTY_OPENSSL_URL_BASE}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz" \
    && tar xzf "${TMPDIR:-/tmp}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz" \
    && cd openssl-${RESTY_OPENSSL_VERSION} \
    && TMPDIR="${TMPDIR:-/tmp}" asfald --overwrite \
        --hash "${RESTY_OPENSSL_PATCH_SHA256}" \
        --output "${TMPDIR:-/tmp}/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch" -- \
        "https://github.com/openresty/openresty/raw/refs/heads/master/patches/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch" \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-2) = "3." ] ; then \
        echo 'patching OpenSSL 3.x for OpenResty' \
        && patch -p1 < "${TMPDIR:-/tmp}/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch"; \
    fi \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-5) = "1.1.1" ] ; then \
        echo 'patching OpenSSL 1.1.1 for OpenResty' \
        && patch -p1 < "${TMPDIR:-/tmp}/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch"; \
    fi \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-5) = "1.1.0" ] ; then \
        echo 'patching OpenSSL 1.1.0 for OpenResty' \
        && TMPDIR="${TMPDIR:-/tmp}" asfald --overwrite \
            --hash '060720ca2b93452dcf68211064841e0417c4a4a40e976fe0b2b5797162917066' \
            --output "${TMPDIR:-/tmp}/openssl-1.1.0j-parallel_build_fix.patch" -- \
            'https://github.com/openresty/openresty/raw/refs/heads/master/patches/openssl-1.1.0j-parallel_build_fix.patch' \
        && patch -p1 < "${TMPDIR:-/tmp}/openssl-1.1.0j-parallel_build_fix.patch" \
        && patch -p1 < "${TMPDIR:-/tmp}/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch"; \
    fi \
    && ./config \
      shared zlib -g \
      --prefix=/usr/local/openresty/openssl3 \
      --libdir=lib \
      -Wl,-rpath,/usr/local/openresty/openssl3/lib \
      ${RESTY_OPENSSL_BUILD_OPTIONS} \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install_sw \
    && cd /tmp \
    && TMPDIR="${TMPDIR:-/tmp}" asfald --overwrite \
        --hash "${RESTY_PCRE_SHA256}" \
        --output "${TMPDIR:-/tmp}/pcre2-${RESTY_PCRE_VERSION}.tar.gz" -- \
        "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${RESTY_PCRE_VERSION}/pcre2-${RESTY_PCRE_VERSION}.tar.gz" \
    && tar xzf "${TMPDIR:-/tmp}/pcre2-${RESTY_PCRE_VERSION}.tar.gz" \
    && cd /tmp/pcre2-${RESTY_PCRE_VERSION} \
    && CFLAGS="-g -O3" ./configure \
        --prefix=/usr/local/openresty/pcre2 \
        --libdir=/usr/local/openresty/pcre2/lib \
        ${RESTY_PCRE_BUILD_OPTIONS} \
    && CFLAGS="-g -O3" make -j${RESTY_J} \
    && CFLAGS="-g -O3" make -j${RESTY_J} install \
    && cd /tmp \
    && tar xzf "openresty-${RESTY_VERSION}.tar.gz" \
    && mv openresty-*/ "openresty-${RESTY_VERSION}" \
    && cd /tmp/openresty-${RESTY_VERSION} \
    && if [ -n "${RESTY_EVAL_POST_DOWNLOAD_PRE_CONFIGURE}" ]; then eval $(echo ${RESTY_EVAL_POST_DOWNLOAD_PRE_CONFIGURE}); fi \
    && eval ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} ${RESTY_LUAJIT_OPTIONS} ${RESTY_PCRE_OPTIONS} \
    && if [ -n "${RESTY_EVAL_PRE_MAKE}" ]; then eval $(echo ${RESTY_EVAL_PRE_MAKE}); fi \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install \
    && cd /tmp \
    && rm -rf \
        "${TMPDIR:-/tmp}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz" "${TMPDIR:-/tmp}"/openssl-*.patch openssl-${RESTY_OPENSSL_VERSION} \
        "${TMPDIR:-/tmp}/pcre2-${RESTY_PCRE_VERSION}.tar.gz" pcre2-${RESTY_PCRE_VERSION} \
        openresty-${RESTY_VERSION}.tar.gz openresty-${RESTY_VERSION} openresty_src \
    && TMPDIR="${TMPDIR:-/tmp}" asfald --overwrite \
        --hash "${RESTY_LUAROCKS_SHA256}" \
        --output "${TMPDIR:-/tmp}/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz" -- \
        "https://github.com/luarocks/luarocks/raw/refs/heads/gh-pages/releases/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz" \
    && tar xzf "${TMPDIR:-/tmp}/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz" \
    && cd luarocks-${RESTY_LUAROCKS_VERSION} \
    && ./configure \
        --prefix=/usr/local/openresty/luajit \
        --with-lua=/usr/local/openresty/luajit \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make build \
    && make install \
    && cd /tmp \
    && if [ -n "${RESTY_EVAL_POST_MAKE}" ]; then eval $(echo ${RESTY_EVAL_POST_MAKE}); fi \
    && rm -rf luarocks-${RESTY_LUAROCKS_VERSION} luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && if [ -n "${RESTY_ADD_PACKAGE_BUILDDEPS}" ]; then DEBIAN_FRONTEND=noninteractive apt-get remove -y --purge ${RESTY_ADD_PACKAGE_BUILDDEPS} ; fi \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && mkdir -p /var/run/openresty \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

# Add LuaRocks paths
# If OpenResty changes, these may need updating:
#    /usr/local/openresty/bin/resty -e 'print(package.path)'
#    /usr/local/openresty/bin/resty -e 'print(package.cpath)'
ENV LUA_PATH="/usr/local/openresty/site/lualib/?.ljbc;/usr/local/openresty/site/lualib/?/init.ljbc;/usr/local/openresty/lualib/?.ljbc;/usr/local/openresty/lualib/?/init.ljbc;/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/init.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/init.lua;./?.lua;/usr/local/openresty/luajit/share/luajit-2.1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/openresty/luajit/share/lua/5.1/?.lua;/usr/local/openresty/luajit/share/lua/5.1/?/init.lua"

ENV LUA_CPATH="/usr/local/openresty/site/lualib/?.so;/usr/local/openresty/lualib/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so"

# Copy nginx configuration files
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
