---
status: "accepted"
date: 2025-06-14
---

# 0004 – Task Runner Choice ( **`just`** vs `make` vs custom CLI )

## Context and Problem Statement
The template needs a single command‑line interface that developers can run
locally and that CI can invoke identically.  Candidates were:

* **`just`** – a modern command runner with minimal syntax, automatic `.env`
  loading, and cross‑platform binaries.
* **`make`** – ubiquitous but tied to GNU/ BSD differences; designed for file
  dependency graphs rather than opaque shell recipes.
* **Custom Bash/Rust CLI** – maximum control but new learning curve.

## Decision Drivers
* **Readability** – new contributors should understand tasks at a glance.
* **Zero extra dependencies** – installers available via package managers.
* **Cross‑platform** – Windows (WSL), macOS, Linux.
* **Easy variable interpolation** (links to ADR‑0002 variable naming).

## Considered Options
* **(A) `just` recipes** *(chosen)*
* (B) `make` with phony targets only
* (C) One master Bash script (`./task <cmd>`)
* (D) Future Rust CLI (`romdev`) replacing shell completely

## Decision Outcome
Chosen option: **`just`** because it provides the cleanest syntax for shell
recipes, built‑in `.env` support (`set dotenv-load`), and a single binary that
runs everywhere, while avoiding `make` quirks (tabs, implicit targets).

### Consequences
* **Positive:** Tasks are declarative and self‑documenting (`just --list`).
* **Positive:** CI simply calls `just all` – parity with developer machines.
* **Negative:** Requires installing `just` binary (added to Dockerfile.dev).
* **Negative:** Limited built‑in dependency logic (acceptable; heavy lifting
  lives in toolchains).

### Confirmation
* Dockerfile includes `just`; devcontainer verified.
* CI job fails if `just build` returns non‑zero.

## Pros and Cons of the Options
### (A) `just`
* **Good:** `.env` autoload; `just -f` for ad‑hoc paths.
* **Good:** Nice error messages & recipe help.
* **Bad:** New tool for some contributors.

### (B) `make`
* **Good:** Already installed on most systems.
* **Neutral:** Tab‑indent quirks; phony targets need boilerplate.
* **Bad:** `.env` not native; Windows incompat (without GNU Make).

### (C) Custom Bash CLI
* **Good:** Unlimited flexibility.
* **Bad:** Reinvents wheels; harder to maintain.

### (D) Rust CLI (`romdev`)
* **Good:** Statically linked, cross‑platform.
* **Bad:** Compilation overhead; premature for template v1.

## More Information
A future ADR may describe migrating to `romdev` once feature parity is
reached and performance benefits outweigh the cost.
