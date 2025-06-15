---
status: "accepted"
date: 2025-06-14
---

# 0017 – Repository Directory Layout

## Context and Problem Statement
A predictable, minimal directory tree helps contributors orient quickly and
keeps CI scripts simple.  The layout must separate **source**, **generated**
artefacts, and **infrastructure** while remaining OS‑agnostic.

Current top‑level folders:
```
.                # project root
├── .github/     # CI workflows
├── .devcontainer/  # Dockerfile.dev + VS Code config
├── adr/         # Architectural Decision Records (MADR)
├── scripts/     # helper shell scripts (metadata, snapshot, etc.)
├── toolchains/  # per‑console build logic
├── roms/        # user‑supplied input & generated output binaries (git‑ignored)
├── patches/     # produced .bps + .json (committed or release artefacts)
└── snapshots/   # golden output binaries checked‑in for regression tests
```

## Decision Drivers
* **Separation of concerns** – infra vs content vs generated.
* **Clarity** – newcomers locate files without README.
* **Git hygiene** – large binaries out of source path (in `roms/`, git‑ignored).
* **Scalability** – new consoles add only under `toolchains/`.

## Considered Options
* **(A) Current flat layout** *(chosen)*
* (B) Nest everything under `src/`, `tests/`, `ci/` like software projects
* (C) Place generated artefacts in `build/` and clean via `just clean`
* (D) Use hidden `.data/` for binaries to hide from casual view

## Decision Outcome
Chosen layout **(A)** because it is the least surprising for ROM‑hacking
projects and cleanly separates mutable/generated directories.

### Consequences
* **Positive:** Tools & CI scripts reference short paths (`roms/input.bin`).
* **Positive:** Git status shows only relevant folders by default.
* **Negative:** Root directory contains 7 folders (visual clutter) – mitigated
  by grouping infra folders with leading dot (`.github`, `.devcontainer`).

### Confirmation
* `.gitignore` ensures `roms/` is never committed.
* CI steps assert directories exist before use.

## Pros and Cons of the Options
### (A) Flat layout (chosen)
* **Good:** Quick mental map; no deep nesting.
* **Bad:** Moderate folder count.

### (B) Software‑style `src/`, `tests/`
* **Good:** Familiar to developers.
* **Bad:** Weird for ROM patches; mixes infra with code.

### (C) Central `build/` for artefacts
* **Good:** Easy `rm -rf build` clean.
* **Bad:** Patches intermingle across mods; snapshot path less discoverable.

### (D) Hidden `.data/`
* **Good:** Clean root.
* **Bad:** Hidden folders confuse some GUIs; scripts need extra flags.

## More Information
If multi‑mod support is added (future ADR), a sub‑folder per mod could be
created under `patches/`, `roms/`, and `snapshots/` with consistent naming.
