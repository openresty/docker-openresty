#!/usr/bin/env bash
# Smoke tests for source-built images, run inside the image.
# Covers the ppc64le LuaJIT number-conversion regression (openresty/openresty#1152).
# Exits non-zero if any check fails.
#
# Usage: docker run --rm -v "$PWD/tests/smoke:/smoke:ro" <image> bash /smoke/smoke.sh
set -u

fail=0
check() {
  local name="$1" expected="$2"; shift 2
  local out
  out="$("$@" 2>&1)"
  if [ "$out" = "$expected" ]; then
    echo "PASS  $name"
  else
    echo "FAIL  $name"
    echo "  command : $*"
    echo "  expected: $expected"
    echo "  actual  : $out"
    fail=1
  fi
}

LJ=/usr/local/openresty/luajit/bin/luajit
echo "arch: $(uname -m)"
$LJ -v

# 1. 64-bit FFI casts round-trip (the regression: these returned 0).
for t in int64_t uint64_t intptr_t; do
  check "ffi.cast $t 123456789" "123456789" \
    $LJ -e "local ffi=require('ffi'); print(tonumber(ffi.cast('$t', 123456789)))"
done
check "ffi.cast int64_t above 2^31" "4294967296" \
  $LJ -e "local ffi=require('ffi'); print(tonumber(ffi.cast('int64_t', 4294967296)))"
check "ffi.cast int64_t negative" "-5" \
  $LJ -e "local ffi=require('ffi'); print(tonumber(ffi.cast('int64_t', -5)))"

# 2. ipairs visits every element (the regression: visited 1).
check "ipairs count" "9" \
  $LJ -e "local n=0; for _ in ipairs({1,2,10,100,255,256,1000,123456789,2147483647}) do n=n+1 end; print(n)"

# 3. ngx.re works through resty (the regression: silently returned nil).
check "ngx.re.match jo" "12345" \
  resty -e 'local m = ngx.re.match("hello 12345 world", [[(\d+)]], "jo"); print(m and m[1])'
check "ngx.re.match no match is nil" "nil" \
  resty -e 'local m = ngx.re.match("hello world", [[(\d+)]], "jo"); print(tostring(m))'

# 4. nginx config is valid and serves the default page.
check "nginx -t" "ok" bash -c 'openresty -t >/dev/null 2>&1 && echo ok'
if openresty -g 'daemon on;'; then
  # Poll for readiness: emulated or loaded hosts can take a while to bind.
  for _ in $(seq 30); do
    curl -fsS --max-time 2 -o /dev/null http://127.0.0.1/ 2>/dev/null && break
    sleep 1
  done
  check "http request" "200" curl -sS --max-time 10 -o /dev/null -w '%{http_code}' http://127.0.0.1/
  openresty -s stop >/dev/null 2>&1
else
  echo "FAIL  nginx start"
  fail=1
fi

exit "$fail"
