---
status: "accepted"
date: 2025-06-14
---

# 0009 – Snapshot Auto‑Generation on First Build

## Context and Problem Statement
ADR‑0008 introduced binary snapshots to guard against accidental ROM output
changes.  We now need to decide **how the initial snapshot is created**.

Manual creation (developer copies `output.bin` → `snapshots/`) risks being
forgotten; CI‑only creation blocks local work.  We added a fallback in
`just check`:

> If no snapshot exists, automatically save the current build as the golden
> reference via `scripts/snapshot-save.sh`.

Is auto‑generation the right choice?

## Decision Drivers
* **Low friction** – contributors should not read docs before first successful
  `just check`.
* **Determinism** – snapshot should only be generated once per repo unless
  explicitly updated.
* **CI friendliness** – first CI run of a fresh fork should not fail.

## Considered Options
* **(A) Auto‑generate snapshot on first check** *(chosen)*
* (B) Require manual `just snap-update` before CI passes
* (C) CI creates snapshot artefact, devs pull

## Decision Outcome
Chosen option: **(A) Auto‑generate**.  `snapshot-check.sh` exits with code 0
when no snapshot exists; `snapshot-save.sh` is invoked via shell OR’ed logic
in the `just check` recipe.

### Consequences
* **Positive:** New contributors can clone → `just build` → `just check` → pass.
* **Positive:** Forks pass CI on first PR without extra steps.
* **Negative:** A developer could accidentally snapshot a *broken* build and
  commit it; mitigated by code review.

### Confirmation
* CI warns (but does not fail) if snapshot file size is 0 bytes or < 1 KiB.
* Review checklist item: “Snapshot looks intentional.”

## Pros and Cons of the Options
### (A) Auto‑generation (chosen)
* **Good:** Zero manual steps on bootstrap.
* **Bad:** Potential to capture unintended output (human review required).

### (B) Manual snapshot
* **Good:** Explicit approval.
* **Bad:** Higher onboarding friction; frequent CI failures.

### (C) CI creates then devs pull
* **Good:** Single source of truth in CI.
* **Bad:** Complex workflow; breaks offline dev.

## More Information
Future tooling (`romtools`) could require an explicit `--init-snapshot` flag to
balance safety and convenience if accidental snapshots become a problem.
