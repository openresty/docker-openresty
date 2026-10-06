# `docker-openresty` HARDENING.md

**Hardening Guide for `docker-openresty` (and official `openresty/openresty` Docker images)**

This document provides practical, production-ready hardening recommendations for deployments of the official OpenResty Docker images. It is especially important in light of the **critical NGINX vulnerability CVE-2026-42945** ("NGINX Rift" – heap buffer overflow in `ngx_http_rewrite_module`) disclosed in May 2026.

The vulnerability affects **all NGINX versions from 0.6.27 up to and including 1.30.0** (and all OpenResty releases built on them). It can be triggered by unauthenticated remote attackers, leading to worker-process crashes (DoS) or, in some configurations, potential remote code execution.

Until the patched OpenResty release is available and you have redeployed, the mitigations below reduce the risk when followed.

*NOTE:* This document was generated from a conversation with an LLM.  It was reviewed and edited by a human.  Please report any issues.

---

## 1. Immediate CVE Mitigation (Config-Level Workaround)

The official recommended temporary fix is to **eliminate the vulnerable `rewrite` pattern** from your NGINX configuration. This change is sufficient to neutralize the bug entirely and requires only a configuration reload (no container restart needed in most cases).

### Vulnerable Pattern
A `rewrite` directive is vulnerable when **all three** of the following are true in the same context (`server`, `location`, `if`, etc.):

- It uses an **unnamed PCRE capture** (`$1`, `$2`, …) in the replacement string.
- The replacement string contains a `?` (typically for query-string construction).
- It is followed (in the same block) by another `rewrite`, `if`, or `set` directive.

### Recommended Fix: Use Named Captures
**Vulnerable example:**
```nginx
rewrite ^/foo/(.*)$ /bar?id=$1;
```

**Fixed example:**
```nginx
rewrite ^/foo/(?<id>.*)$ /bar?id=$id;
```

**Alternative safe patterns (if you cannot use named captures):**
- Remove the `?` from the replacement string, or
- Ensure no other `rewrite`/`if`/`set` follows the rule in the same block.

### Quick Audit Commands

```bash
# On the host (if config is mounted)
grep -r "rewrite " /path/to/your/nginx/conf/ | grep -E '\$\d'

# Inside a running container
docker exec -it <container-name> sh -c \
  'grep -r "rewrite " /usr/local/openresty/nginx/conf/ | grep -E "\$\d"'
```

After editing:
1. Validate: `openresty -t` (or `nginx -t`)
2. Reload: `openresty -s reload` (or send `SIGHUP` to the master process)

If your configuration is generated dynamically (Lua templates, Ingress controllers, Helm charts, etc.), update the templates to emit **named captures** by default.

---

## 2. Docker Runtime Hardening (Reduce Blast Radius)

Even with the config fix applied, apply these container-level controls:

### Run as Non-Root with a Read-Only Filesystem

Selecting `--user` alone is insufficient: Nginx needs a writable PID location and temporary directories. The following example runs the `bookworm` image as UID/GID `10001:10001`, with a read-only root filesystem and no Linux capabilities.

Save this as `nonroot.default.conf` in your current directory. Port 8080 avoids needing `NET_BIND_SERVICE` on runtimes that enforce privileged ports. Docker normally sets `net.ipv4.ip_unprivileged_port_start=0` in containers, allowing non-root processes to bind port 80 without that capability; other runtimes and configurations may differ:

```nginx
server {
    listen 8080;
    server_name localhost;

    location / {
        root /usr/local/openresty/nginx/html;
        index index.html;
    }
}
```

Make the configuration readable by the container user, then start the server:

```bash
chmod 644 nonroot.default.conf
docker run --rm --name openresty-nonroot \
  --user 10001:10001 \
  --read-only \
  --tmpfs /var/run/openresty:rw,noexec,nosuid,nodev,size=64m,mode=0700,uid=10001,gid=10001 \
  --cap-drop=ALL \
  --security-opt no-new-privileges=true \
  --publish 127.0.0.1:8080:8080 \
  --mount "type=bind,src=$(pwd)/nonroot.default.conf,dst=/etc/nginx/conf.d/default.conf,readonly" \
  openresty/openresty:bookworm \
  openresty -g 'daemon off; pid /var/run/openresty/nginx.pid;'
```

In another terminal, verify the server with `curl --fail http://127.0.0.1:8080/`. To check the configuration before starting the server, use `openresty -t -g 'pid /var/run/openresty/nginx.pid;'` as the command after the image name.

The tmpfs is owned by the selected UID/GID and holds both the PID file and the temporary directories configured by the image. Master and worker processes run as that same UID, so mode `0700` permits both to write. If you change the UID/GID, update the tmpfs ownership too; a root master configured to switch workers to another UID would need different directory ownership or permissions. Logs retain the image's stdout/stderr links.

The 64 MiB tmpfs limit is shared by request-body temporary files and proxy buffering spills. Size it for your workload: exhausting it can cause request failures.

Standard Linux flavors use `openresty` on PATH and `/usr/local/openresty/nginx/html` as the document root. For `bookworm-debug`, use `openresty-debug` and `/usr/local/openresty-debug/nginx/html`; for `bookworm-valgrind`, use `openresty-valgrind` and `/usr/local/openresty-valgrind/nginx/html`.

The example above mounts only Nginx's runtime directory as writable. Add separate, size-limited writable mounts if your application needs uploads, caches, or `/tmp`; give them the same UID/GID ownership. Keep application code and configuration read-only.

Retain Docker's default [seccomp profile](https://docs.docker.com/engine/security/seccomp/) and, where supported, its AppArmor profile. AppArmor and seccomp are separate controls. When translating the example to Compose or Kubernetes, preserve the non-root identity, writable runtime directory, PID override, read-only root filesystem, dropped capabilities, and prevention of privilege escalation.

### Resource Limits (Prevent DoS Amplification)

Here are Docker CLI args to consider to limit resource overconsumption:

```bash
--cpus=2.0 \
--memory=512m \
--memory-swap=512m \
--pids-limit=150 \
--ulimit nofile=1024:4096
```

### User Namespaces & Other Protections (Linux hosts)

If the Docker daemon uses [user-namespace remapping](https://docs.docker.com/engine/security/userns-remap/), retain it by omitting `--userns`. Do not use `--userns=host` for hardening: it disables that remapping for the container. Alternatively, use [rootless Docker](https://docs.docker.com/engine/security/rootless/) or rootless Podman. Arrange bind-mount permissions for the mapped host identity when using remapping.

Prevent processes from gaining additional privileges (also included in the example above):

```bash
--security-opt no-new-privileges=true
```

---

## 3. Defense-in-Depth Recommendations

| Layer                  | Recommendation                                                                 |
|------------------------|--------------------------------------------------------------------------------|
| **Front-end WAF**      | Place ModSecurity, OWASP CRS, or a cloud WAF (Cloudflare, Fastly, etc.) in front of OpenResty. |
| **Rate Limiting**      | Enable `limit_req_zone` and `limit_conn_zone` on public endpoints.            |
| **Request Validation** | Use `limit_except`, `valid_referer`, `access_by_lua_block`, or Lua-based validation. |
| **Logging & Monitoring** | Ship logs to a central system. Alert on worker crashes (`signal 11`, `exited on signal`). |
| **Auto-restart**       | Use `restart: unless-stopped` (Docker) or proper liveness probes (Kubernetes). |
| **Network**            | Expose only necessary ports; prefer internal networks.                        |

---

## 4. Upgrading to the Patched Version

1. Watch the official repository: [https://github.com/openresty/docker-openresty](https://github.com/openresty/docker-openresty)
2. Monitor Docker Hub tags for the next `openresty/openresty` release (they backport NGINX security fixes rapidly).
3. **Pin your image today** so you can upgrade cleanly:

   ```yaml
   image: openresty/openresty:1.29.2.4-0-bookworm   # example pinned tag
   ```

4. After the patched image is released:
   ```bash
   docker pull openresty/openresty:<new-tag>
   # rebuild / redeploy
   docker compose up -d
   ```

5. Verify the fix inside the container:
   ```bash
   docker exec -it <container> openresty -v
   ```

---

## 5. Additional Best Practices

- **ASLR**: Keep Address Space Layout Randomization enabled on the host (`/proc/sys/kernel/randomize_va_space` should be `2`).
- **Regular Audits**: Include the `grep` audit above in your CI/CD pipeline.

---

**Questions or need help?**

Open an issue in the [`docker-openresty` repository](https://github.com/openresty/docker-openresty). This document will be updated whenever new CVEs or best practices emerge.

**Last updated:** September 9, 2026  EW
**Applies to:** All `openresty/openresty` images prior to the CVE-2026-42945 patch release.
```
