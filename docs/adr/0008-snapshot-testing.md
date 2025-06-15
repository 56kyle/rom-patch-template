---
status: "accepted"
date: 2025-06-14
---

# 0008 – Snapshot Testing for Built ROMs

## Context and Problem Statement
The template produces a binary ROM (`roms/output.bin`).  A single stray change
(byte‑level) can soft‑brick a patch or desynchronise TAS replays.  We need an
automated guardrail to detect unintended output changes across commits.

## Decision Drivers
* **Regression safety** – fail fast when output differs.
* **Zero‑false‑positives** – deterministic comparison.
* **Low overhead** – no emulator required; run in < 1 s.
* **Ease of update** – intentional changes should be trivial to approve.

## Considered Options
* **(A) Binary snapshot file stored in `snapshots/`** *(chosen)*
* (B) Store only SHA‑1 hash in text file
* (C) Golden screenshots / hash of emulator frame
* (D) No snapshot testing; rely on patch‑hash mismatch

## Decision Outcome
Chosen option: **(A) Full binary snapshot**.
We keep an exact copy of the *expected* ROM in `snapshots/`.  `snapshot-check.sh`
performs `cmp output.bin snapshot.bin` in CI and locally.  On first build a
snapshot is auto‑created by `snapshot-save.sh` (see ADR‑0009).

### Consequences
* **Positive:** Bit‑for‑bit verification catches any accidental change.
* **Positive:** No external tooling — `cmp` is POSIX standard.
* **Positive:** Developers approve intentional updates via `just snap-update`.
* **Negative:** Repository size grows by one binary per mod (typically ≤ 4 MB).
* **Negative:** Snapshot must be regenerated after every legitimate content
  change (acceptable; enforced by workflow).

### Confirmation
* CI step `snapshot-check.sh` fails if comparison differs.
* Local `just check` runs same script; contributors see error before push.

## Pros and Cons of the Options
### (A) Binary snapshot (chosen)
* **Good:** Zero ambiguity; works offline.
* **Bad:** Larger repo footprint vs hash‑only.

### (B) SHA‑1 hash only
* **Good:** 40‑byte file.
* **Bad:** Requires extra step (`sha1sum`) when debugging changes.

### (C) Emulator screenshot hash
* **Good:** Catches visual diffs even if binary differs inconsequentially.
* **Bad:** Flaky across emulators; heavy runtime cost.

### (D) No snapshot test
* **Good:** Simplest.
* **Bad:** Silent regressions possible; defeats reproducibility goal.

## More Information
If repo size becomes an issue we can gzip snapshots (lossless) or move them to
Git LFS — subject of a future ADR.
