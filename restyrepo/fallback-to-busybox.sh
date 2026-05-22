#!/usr/bin/env sh

_cleanup() { case "${1}" in
    (register) [ -n "${2}" ] && _cleanup_registry="${_cleanup_registry}${2}\000" ;;
    (clear)
        busybox printf "%b" "${_cleanup_registry}" | busybox xargs -r -0 busybox rm -f;
        _cleanup_registry="";
        ;;
    esac;
}
_cleanup_registry="";
trap "_cleanup clear" EXIT;

_get_url() {
    _o="${1}"; shift;
    _u="${1}"; shift;
    if [ 1 -eq "${USE_CURL:-0}" ]; then
        curl -fsSLo "${_o}" -- "${_u}";
    else
        busybox wget -O "${_o}" "${@}" -- "${_u}";
    fi;
    _rc="${?}";
    unset -v _o _u;
    return "${_rc}";
}

_stderr() {
    printf 1>&2 -- "%s\n" "${@}";
}

extract_gh_digests() {
    busybox awk -e '
      /clipboard digest for / {
        td=gensub(/<clipboard-copy (.+)>/, "\\1", "g");
        d=gensub(/^.* value="[^:]+:([^"]+)".*$/, "\\1", 1, td);
        f=gensub(/^.* aria-label=".+digest for ([^"]+)".*$/, "\\1", 1, td);
        print d " *" f;
      }
    ';
}

find_hash_for_file() {
    _f="${1}"; shift;
    busybox awk -v file="${_f}" -e '$0 ~ " [* ]" file "$" {print $1; exit;}' "${@}";
    unset -v _f;
}

get_from_gh_url() { case "${1}" in
    (owner)
        busybox awk -v url="${2}" -e '
          END {
            print gensub(/^https?:\/\/github\.com\/([^\/]+)\/.*$/, "\\1", 1, url);
          }
        ' </dev/null;
        ;;
    (repo)
        busybox awk -v url="${2}" -e '
          END {
            print gensub(/^https?:\/\/github\.com\/[^\/]+\/([^\/]+)\/.*$/, "\\1", 1, url);
          }
        ' </dev/null;
        ;;
    (tag)
        _url="${2}";
        if is_gh_tag_url "${_url}"; then
            busybox basename "${_url}";
        elif is_gh_download_url "${_url}"; then
            _tag_url="$(busybox dirname "${_url}")";
            busybox basename "${_tag_url}";
            unset -v _tag_url;
        fi;
        unset -v _url;
        ;;
    esac;
}

get_gh_digests_from_tag() {
    _url="$(printf -- "https://github.com/%s/%s/releases/expanded_assets/%s\n" "${1}" "${2}" "${3}")";
    _get_url - "${_url}" -q | extract_gh_digests;
    unset -v _url;
}

is_gh_download_url() { case "${1}" in
    (http*://github.com/*/releases/download/*) return 0 ;;
    esac;
    return 1;
}

is_gh_tag_url() { case "${1}" in
    (http*://github.com/*/releases/tag/*) return 0 ;;
    esac;
    return 1;
}

for _arg in "${@}"; do case "${_arg}" in
    (--force-absent|-f) _verified=1 ;;
    (--hash|-H) _set_H=1 ;;
    (--output|-o) _set_o=1 ;;
    (--pattern|-p) _set_p=1 ;;
    (*)
        if [ 1 -eq "${_set_H:-0}" ]; then hash="${_arg}"; unset -v _set_H ; fi ;
        if [ 1 -eq "${_set_o:-0}" ]; then output="${_arg}"; unset -v _set_o ; fi ;
        if [ 1 -eq "${_set_p:-0}" ]; then pattern="${_arg}"; unset -v _set_p ; fi ;
        url="${_arg}"
        ;;
esac; done; unset -v _arg ;

if [ -z "${output-}" ]; then output="$(busybox basename "${url}")"; fi;
if [ -z "${hash-}" ] && [ -n "${pattern-}" ]; then
    cs_url="$(busybox awk \
        -v file="$(busybox basename "${url}")" \
        -v fullpath="${url}" \
        -v path="$(busybox dirname "${url}")" \
        -v pattern="${pattern}" -e '
      END {
        out = gensub(/[$][{]file[}]/, file, "g", pattern);
        out = gensub(/[$][{]fullpath[}]/, fullpath, "g", out);
        out = gensub(/[$][{]path[}]/, path, "g", out);
        print out;
      }
    ' </dev/null)";
fi;
gh_tag="$(get_from_gh_url "tag" "${url}")";
if [ -z "${hash-}" ] && [ -n "${gh_tag}" ]; then
    gh_owner="$(get_from_gh_url "owner" "${url}")";
    gh_repo="$(get_from_gh_url "repo" "${url}")";
    csfile="$(busybox mktemp)" && _cleanup register "${csfile}" &&
    get_gh_digests_from_tag "${gh_owner}" "${gh_repo}" "${gh_tag}" > "${csfile}" &&
    hash="$(find_hash_for_file "$(busybox basename "${url}")" "${csfile}")";
    [ -s "${csfile}" ] || _stderr "Warning: No digests extracted for any artifacts at GitHub.com!";
    [ -n "${hash}" ] || _stderr "Warning: No digest found at GitHub.com!";
fi;
dlfile="$(busybox mktemp)" &&
    _cleanup register "${dlfile}" &&
    { [ -z "${cs_url-}" ] || { _get_url "${dlfile}" "${cs_url}" -q && hash="$(find_hash_for_file "$(busybox basename "${url}")" "${dlfile}")" ; [ -n "${hash-}" ]; } ; } &&
    _get_url "${dlfile}" "${url}" &&
    { [ -z "${hash-}" ] || { busybox printf -- "%s *%s\n" "${hash-}" "${dlfile}" | busybox sha256sum -cw && _verified=1 || _verified=0; } ; } &&
    { [ "-" = "${output-}" ] && busybox cat "${dlfile}" || [ 1 -eq "${_verified:-0}" ] && busybox mv -fT "${dlfile}" "${output-}" ; } ;
