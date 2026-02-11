# AGENTS.md — Rauthy

> Rauthy is a lightweight, high-performance **Single Sign-On Identity & Access Management** server
> supporting **OpenID Connect**, **OAuth 2.0**, and **PAM**. Written in **Rust**, it prioritizes
> memory safety, minimal footprint, and secure-by-default configuration.
>
> Repository: https://github.com/sebadob/rauthy
> Security Audit: [Full Report (v0.32)](https://raw.githubusercontent.com/sebadob/rauthy/refs/heads/main/assets/security_audit_report_v0.32.pdf)
> by [Radically Open Security](https://www.radicallyopensecurity.com/) — funded through [NGI Zero Core](https://nlnet.nl/core).

---

## Mission

When working on this codebase, AI agents should focus on two primary objectives:

1. **Feature Extension** — Implement new capabilities while preserving Rauthy's lightweight,
   secure-by-default philosophy and strict architectural patterns.
2. **Security Audit & Patching** — Identify vulnerabilities, harden attack surfaces, and apply
   fixes following the project's established security conventions.

---

## Project Structure

```
rauthy/
├── src/                        # Rust workspace crates (the core application)
│   ├── api/                    # HTTP API handlers (actix-web routes)
│   ├── api_types/              # Shared request/response types for the API
│   ├── bin/                    # Application entrypoint (main.rs, server setup, TLS)
│   ├── common/                 # Shared utilities (hashing, regex, constants, compression)
│   ├── data/                   # Data layer — entities, DB operations, config, email
│   │   └── src/entity/         # Domain entities (users, sessions, clients, JWK, OIDC, PAM...)
│   ├── error/                  # Unified ErrorResponse type used project-wide
│   ├── jwt/                    # JWT creation and validation
│   ├── middlewares/             # actix-web middlewares (CSRF, IP blacklist, principal extraction)
│   ├── notify/                 # Notification channels (email, Matrix, Slack)
│   ├── schedulers/             # Background jobs (JWKS rotation, backups, session cleanup...)
│   ├── service/                # Business logic (OIDC flows, token sets, forward_auth, login delay)
│   └── wasm-modules/           # WASM modules built for the frontend (PoW, markdown)
├── frontend/                   # Svelte (SvelteKit) UI — Admin dashboard + user account pages
├── rauthy-client/              # Standalone Rust client library for Rauthy consumers
├── migrations/                 # Database migrations
│   ├── hiqlite/                # SQLite/Hiqlite migrations (ID-prefixed: `<id>_*.sql`)
│   └── postgres/               # Postgres migrations (prefixed: `V<id>__*.sql`)
├── templates/                  # Askama HTML templates (email, error pages)
├── book/                       # mdBook documentation (the "Rauthy Book")
├── config.toml                 # Reference configuration (heavily documented, 2600+ lines)
├── justfile                    # Development recipes (build, test, run, format, release)
├── Cargo.toml                  # Workspace root with all shared dependencies
└── CONTRIBUTING.md             # Developer setup and contribution guidelines
```

---

## Tech Stack & Key Dependencies

| Layer            | Technology                                                               |
| ---------------- | ------------------------------------------------------------------------ |
| Language         | **Rust** (Edition 2024, MSRV ≥ 1.88)                                     |
| Web Framework    | **actix-web 4** with Rustls                                              |
| Database         | **Hiqlite** (embedded SQLite + Raft, default) or **Postgres** (optional) |
| Frontend         | **Svelte / SvelteKit** — compiled to static HTML, served by backend      |
| Templating       | **Askama** (compile-time checked HTML templates)                         |
| Cryptography     | `ring`, `ed25519-compact`, `rsa`, `chacha20poly1305`, `argon2`           |
| Auth Standards   | OIDC, OAuth 2.0, FIDO2/WebAuthn, DPoP, SCIM v2, FedCM (experimental)     |
| API Docs         | **utoipa** + Swagger UI                                                  |
| Metrics          | **Prometheus** (`/metrics` on separate port)                             |
| Serialization    | `serde` / `serde_json` / `bincode`                                       |
| Task Runner      | **just** (justfile recipes)                                              |
| Containerization | Multi-arch Docker (distroless base image)                                |

---

## Coding Conventions

### Rust

- **Safe Rust only** — All crates use `#![forbid(unsafe_code)]`.
- **Idiomatic Rust** — Prefer borrowing over cloning; minimize allocations.
- **Formatting** — Always use `cargo fmt`. Run `just fmt` before submitting.
- **Linting** — `cargo clippy -- -D warnings` must pass with zero warnings.
- **Error handling** — All fallible functions return `Result<_, ErrorResponse>` using the
  custom `ErrorResponse` from `rauthy-error`. Never use raw `anyhow` strings.
  - `ErrorResponse` has an `error` field (machine-readable `ErrorResponseType` enum) and
    a `message` field (human-readable string).
- **Naming** — Functions returning `bool` use `is_*` / `has_*` prefixes. DB operations use
  `find`, `create`, `update`, `save`, `delete` in dedicated `impl` blocks.
- **Performance matters** — Rauthy targets Raspberry Pi-class hardware. Avoid unnecessary
  allocations, clones, and memory overhead. Use caching aggressively.
- **Inline hints** — Performance-critical accessors use `#[inline(always)]`.

### Frontend (Svelte)

- **Formatting** — Use `prettier` with the config in `frontend/.prettierrc`.
- **Linting** — `npm run check` and `npm run format-check` must pass.
- **CSS** — Plain CSS only (no frameworks). Global styles in `frontend/src/css/global.css`.
  Per-component styles in `<style>` blocks.
- **i18n** — Translations live in `frontend/src/i18n/` split into `admin` and `common`.
  Use `useI18n()` → `t` for common, `useI18nAdmin()` → `ta` for admin.
- **SSR Templates** — `<Template>` component handles SSR data injection. In production,
  data comes from DOM `<template>` blocks. In dev, it fetches from the backend.

---

## Architecture & Design Principles

### Layered Architecture

```
┌─────────────────────────────┐
│     Frontend (Svelte)       │  ← Static HTML served by backend in production
├─────────────────────────────┤
│     API Layer (src/api)     │  ← HTTP handlers, request validation, response mapping
├─────────────────────────────┤
│   Middleware (src/middlewares)│ ← CSRF, IP blacklist, Principal extraction, logging
├─────────────────────────────┤
│   Service Layer (src/service)│ ← Business logic, OIDC flows, token management
├─────────────────────────────┤
│   Data Layer (src/data)     │  ← Entities, DB queries, caching, configuration
├─────────────────────────────┤
│   Database (Hiqlite/Postgres)│ ← Persistence with aggressive in-memory caching
└─────────────────────────────┘
```

### Key Design Decisions

1. **Principal-based authorization** — Every request is evaluated through a `Principal`
   (extracted by middleware). It encapsulates `Session`, `ApiKey`, and `roles`. Use its
   `validate_*` methods for access control — never roll custom auth checks.

2. **Dual database support** — Hiqlite (default, embedded) and Postgres (optional). Entity
   `impl` blocks are designed to be interchangeable. All DB operations are in `src/data/src/entity/`.

3. **Compile-time templates** — Askama templates are checked at compile time. If you modify
   the frontend, run `just build-ui` to regenerate static HTML or template errors will occur.

4. **Event system** — Events are generated for security-relevant actions and can be sent via
   Email, Matrix, or Slack. When adding new security-sensitive operations, emit appropriate events.

5. **Aggressive caching** — Most auth-chain data is cached in-memory for hours. When modifying
   cached entities, ensure proper cache invalidation.

---

## Development Workflow

### Initial Setup

```bash
just setup          # npm install + cargo installs (wasm-pack, mdbook)
just dev-env-start  # Start Mailcrab + Postgres containers
just build-ui       # Build frontend to static HTML
```

### Running Locally

```bash
just run            # Hiqlite backend on port 8080
just run ui         # Svelte dev UI on port 5173 (use this for frontend work)
just run postgres   # Use Postgres instead of Hiqlite
```

### Default Dev Credentials

```
Email:    admin@localhost
Password: 123SuperSafe
```

### Testing

```bash
just test <test_name>       # Run a single test (unit or integration with manual backend)
just test-hiqlite           # Full integration test suite with Hiqlite
just test-postgres          # Full integration test suite with Postgres
just test-backend           # Start test backend only (for debugging individual tests)
```

### Pre-PR Checklist

```bash
just fmt                    # Format all code (Rust + frontend)
just pre-pr-checks          # Full validation suite
```

---

## Database Migrations

Migrations live in `migrations/hiqlite/` and `migrations/postgres/`.

### Critical Rules

- **NEVER modify existing published migrations.** Migration files are hashed at startup and
  compared against applied hashes. Any mismatch causes a `panic`.
- Hiqlite files: `<id>_<description>.sql` — strictly ascending numeric IDs.
- Postgres files: `V<id>__<description>.sql` — strictly ascending numeric IDs.
- During development, if tuning an unpublished migration, clean the DB:
  - Hiqlite: `just delete-hiqlite`
  - Postgres: `just postgres-rm && just postgres-start`

---

## Security Guidelines

### Threat Model Awareness

Rauthy is an **Identity Provider** — it is the trust root. Every change must be evaluated
through a security lens. The project has passed an independent security audit (v0.32.1).

### Security-Critical Areas

| Area                     | Location                                      | Notes                                          |
| ------------------------ | --------------------------------------------- | ---------------------------------------------- |
| Authentication flows     | `src/service/src/oidc/`                       | OIDC/OAuth core — highest sensitivity          |
| Token generation         | `src/service/src/token_set.rs`, `src/jwt/`    | JWK, signing algorithms, token claims          |
| Password hashing         | `src/common/src/password_hasher.rs`           | Argon2ID with configurable parameters          |
| Session management       | `src/data/src/entity/sessions.rs`             | Session state machine, CSRF, IP binding        |
| Principal / AuthZ        | `src/data/src/entity/principal.rs`            | All access control decisions flow through here |
| CSRF protection          | `src/middlewares/src/csrf_protection.rs`      | Sec-\* header validation                       |
| IP blacklisting          | `src/middlewares/src/ip_blacklist.rs`         | Brute-force / DoS protection                   |
| Login delay              | `src/service/src/login_delay.rs`              | Artificial delay after failed logins           |
| API key validation       | `src/data/src/entity/api_keys.rs`             | Fine-grained access rights per group           |
| WebAuthn / Passkeys      | `src/data/src/entity/webauthn.rs`             | FIDO2 credential management                    |
| DPoP proofs              | `src/data/src/entity/dpop_proof.rs`           | Decentralized proof-of-possession              |
| Encryption at rest       | `src/service/src/encryption.rs`               | ChaCha20Poly1305 for critical DB entries       |
| Magic links              | `src/data/src/entity/magic_links.rs`          | Password reset, email verification             |
| Forward auth             | `src/service/src/forward_auth.rs`             | Reverse proxy authentication                   |
| Suspicious request block | `src/service/src/suspicious_request_block.rs` | Anomaly detection                              |

### Security Audit Checklist (for agents)

When reviewing or modifying security-sensitive code:

- [ ] **Input validation** — All user inputs validated via `validator` derive macros or
      regex patterns from `rauthy_common::regex`.
- [ ] **Output encoding** — HTML sanitized via `ammonia` / `svg-hush`. No raw user content
      in templates.
- [ ] **Authentication** — Endpoints correctly use `Principal::validate_*` methods. No
      auth bypass paths.
- [ ] **Authorization** — Role/group checks use the existing `Principal` infrastructure.
      API key endpoints check `AccessGroup` + `AccessRights`.
- [ ] **Cryptographic operations** — Use `ring`, `ed25519-compact`, `rsa` from workspace
      deps. No custom crypto implementations.
- [ ] **Timing attacks** — Use `constant_time_eq` for secret comparisons.
- [ ] **Error messages** — Never leak internal state, stack traces, or database details in
      `ErrorResponse::message`.
- [ ] **Rate limiting** — Login endpoints have artificial delay + IP blacklisting. New
      sensitive endpoints should integrate with existing rate limiting.
- [ ] **CSRF** — State-changing endpoints require CSRF token validation via session.
- [ ] **Cookie security** — Cookies use `__Host-` prefix in production (host-bound).
      Validate `COOKIE_MODE` settings.
- [ ] **Token claims** — Validate `nbf`, `exp`, `iss`, `aud` claims. Respect DPoP binding.
- [ ] **Cache invalidation** — When modifying user/session/client state, ensure cached
      entries are properly invalidated.

### Common Vulnerability Patterns to Watch

1. **Username enumeration** — Rauthy has explicit prevention. Don't add response differences
   that reveal whether a user exists.
2. **Open redirect** — Validate all redirect URIs against registered client redirect URIs.
3. **SSRF** — Be cautious with upstream provider callbacks, backchannel logout URLs, and
   SCIM endpoints.
4. **JWT confusion** — Always verify `alg` header against expected algorithms. Don't accept
   `none`.
5. **Session fixation** — Sessions rotate on auth state changes. Preserve this behavior.
6. **Privilege escalation** — The `rauthy_admin` role is the highest privilege. Guard all
   admin-only paths with `validate_admin_session()`.

---

## Feature Development Patterns

### Adding a New API Endpoint

1. **Define types** in `src/api_types/src/` — request/response structs with `serde` + `utoipa` derives.
2. **Add handler** in `src/api/src/<module>.rs` — use `ReqPrincipal`, `ReqSession`, `ReqApiKey` extractors.
3. **Implement business logic** in `src/service/src/` — keep handlers thin.
4. **Add entity operations** in `src/data/src/entity/` — DB queries with caching.
5. **Register route** in `src/bin/src/server.rs` — add to the actix-web app configuration.
6. **Add OpenAPI docs** — annotate with `#[utoipa::path(...)]` and register in `src/api/src/openapi.rs`.
7. **Emit events** for security-relevant operations via the event system.

### Adding a New Entity

1. Create the entity file in `src/data/src/entity/<name>.rs`.
2. Add DB migration files to **both** `migrations/hiqlite/` and `migrations/postgres/`.
3. Implement `find`, `create`, `update`, `delete` in a dedicated `impl` block.
4. Use `hiqlite::Param` derives for Hiqlite and `tokio-postgres` / `postgres-types` for Postgres.
5. Add cache integration if the entity is frequently read.
6. Register the module in `src/data/src/entity/mod.rs`.

### Adding a New Scheduler / Background Job

1. Create the scheduler in `src/schedulers/src/<name>.rs`.
2. Implement as an async task with proper error handling and logging.
3. Register in the scheduler initialization in `src/schedulers/src/lib.rs`.
4. Make scheduling configurable via `config.toml` (with env var override).

---

## Configuration

The reference config is `config.toml` (2600+ lines, extensively documented). Every option
documents its:

- Default value
- Environment variable override name
- Purpose and security implications

For local dev overrides, use a `.env` file (gitignored). Env vars always have the highest
priority.

### Config Architecture

The main config is parsed in `src/data/src/rauthy_config.rs` (120KB+ — the largest file in
the project). It loads TOML + env var overrides into a static `RauthyConfig` struct accessed
via `RauthyConfig::get()`.

---

## CI/CD

- **GitHub Actions** — `code_style.yaml` runs on PRs:
  - `cargo fmt --check`
  - `cargo clippy -- -D warnings`
  - `npm run format-check` (frontend)
  - `npm run check` (frontend)
- No automated test pipeline yet — tests are run locally via `just` recipes.
- Container builds use `ghcr.io/sebadob/rauthy-builder` image with cross-compilation
  for `x86_64` and `aarch64`.

---

## Important Caveats

1. **Never build from `main` for production.** The `main` branch may contain unstable
   migrations that can corrupt production databases. Always use stable release tags.

2. **Askama template errors** — If you see template compilation errors, run `just build-ui`
   to regenerate the static HTML files.

3. **Dev-only endpoints** — `src/api/src/dev_only/` contains endpoints that only exist
   with `debug_assertions`. They are workarounds for local development limitations
   (especially around SSR and password reset flows).

4. **Hiqlite vs Postgres parity** — Any data layer change must work with **both** database
   backends. Always test with `just test-hiqlite` and `just test-postgres`.

5. **FreeBSD** — Frontend compilation may fail on FreeBSD. Use `just build-ui container`
   as a workaround.

6. **PAM module** — The PAM/NSS module is in a separate repo
   ([rauthy-pam-nss](https://github.com/sebadob/rauthy-pam-nss)) due to GPLv3 licensing
   constraints.

---

## Quick Reference: Just Recipes

| Recipe                | Purpose                                             |
| --------------------- | --------------------------------------------------- |
| `just setup`          | Initial project setup (npm install, cargo installs) |
| `just run`            | Run with Hiqlite                                    |
| `just run postgres`   | Run with Postgres                                   |
| `just run ui`         | Start Svelte dev server                             |
| `just build-ui`       | Build static HTML from Svelte                       |
| `just build-wasm`     | Build WASM modules (PoW, markdown)                  |
| `just fmt`            | Format all code                                     |
| `just test <name>`    | Run a single test                                   |
| `just test-hiqlite`   | Full test suite (Hiqlite)                           |
| `just test-postgres`  | Full test suite (Postgres)                          |
| `just test-backend`   | Start test backend for debugging                    |
| `just delete-hiqlite` | Clean Hiqlite data (for migration dev)              |
| `just dev-env-start`  | Start Mailcrab + Postgres containers                |
| `just dev-env-stop`   | Stop dev containers                                 |
| `just pre-pr-checks`  | Full pre-PR validation                              |
| `just build-docs`     | Build mdBook documentation                          |
| `just version`        | Print current version                               |
