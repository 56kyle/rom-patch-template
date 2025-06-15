---
status: "accepted"
date: 2025-06-14
---

# 0007 – Per‑Patch Metadata Files (`<patch>.bps.json`)

## Context and Problem Statement
Each generated patch must ship with descriptive information: version, author,
input/output hashes, toolchain, timestamp, etc.  We had to decide **where this
metadata lives**:

1. A single `patch.json` at repo root that is overwritten on every build.
2. Embed everything inside the BPS header only.
3. **A side‑car JSON file next to every patch** (chosen).

## Decision Drivers
* **Traceability** – keep old patch metadata even after new releases.
* **Distribution convenience** – users download one `.bps` and its `.json` mate.
* **Automation** – CI can treat every patch+json pair as a standalone artefact.
* **Simplicity** – no custom tools needed to extract metadata from BPS.

## Considered Options
* **(A) Side‑car `<patch>.bps.json` for every patch** *(chosen)*
* (B) Single global `patch.json` overwritten per build
* (C) Encode metadata only in BPS header

## Decision Outcome
Chosen option: **(A) Per‑patch JSON** because it satisfies all drivers with
minimal tooling.  A consumer (CLI, web frontend) can simply scan `patches/*.bps`
and load the adjacent `.json` for info and verification.

### Consequences
* **Positive:** Old releases keep their own metadata files in Git history **and**
  GitHub Releases assets.
* **Positive:** `validate-patch-json.sh` can assert hashes without parsing BPS.
* **Positive:** Easy bundling into ZIP/RAR downloads (drag‑select both files).
* **Negative:** Extra file clutter; patch authors must remember to publish both
  files together (CI automates this).

### Confirmation
* `generate-patch-json.sh` writes `${PATCH_PATH}.json` after every build.
* CI uploads `*.bps` **and** `*.bps.json` as Release artefacts.

## Pros and Cons of the Options
### (A) Per‑patch JSON (chosen)
* **Good:** Immutable history of every patch.
* **Good:** Human‑readable; no custom parser.
* **Bad:** Two files instead of one.

### (B) Single overwritten JSON
* **Good:** Only one file to read.
* **Bad:** Metadata for old versions lost unless hunting Git history.

### (C) BPS‑header only
* **Good:** Exactly one file per patch.
* **Bad:** Requires a custom BPS parser; web patchers ignore extra fields.

## More Information
Future ADRs may define a JSON Schema for validation or add signed checksums to
the metadata file for authenticity.
