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

### Run as Non-Root
The official images support dropping privileges:

```yaml
# docker run
docker run --user nobody ...

# docker-compose / swarm / Kubernetes
user: "nobody"
```

or use your own UID/GID for even tighter control.

### Filesystem and Capability Hardening

```bash
--read-only \
--tmpfs /tmp \
--tmpfs /var/run \
--cap-drop=ALL \
--cap-add=NET_BIND_SERVICE \
--security-opt apparmor=docker-default \
--security-opt seccomp=unconfined   # or a custom seccomp profile
```

### Resource Limits (Prevent DoS Amplification)

```bash
--cpus=2.0 \
--memory=512m \
--memory-swap=512m \
--pids-limit=150 \
--ulimit nofile=1024:4096
```

### User Namespaces & Other Protections (Linux hosts)

```bash
--userns=host \          # or use rootless Docker / Podman
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

**Last updated:** May 15, 2026  EW
**Applies to:** All `openresty/openresty` images prior to the CVE-2026-42945 patch release.
```
