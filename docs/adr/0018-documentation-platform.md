---
status: "accepted"
date: 2025-06-14
---

# 0018 – Documentation Platform ( **MkDocs + Material** )

## Context and Problem Statement
The template needs human‑readable, version‑controlled documentation that scales
beyond a single `README.md`. We evaluated several approaches (see discussion)
and must choose one.

## Decision Drivers
* **Navigation & search** for multi‑page guides.
* **Lightweight tooling** to fit inside existing Debian‑based devcontainer.
* **Source‑controlled Markdown** – docs evolve via pull requests.
* **Easy hosting on GitHub Pages** with minimal CI.

## Considered Options
* **(A) MkDocs with `material` theme** *(chosen)*
* (B) Plain `docs/` Markdown folder, no generator
* (C) Docusaurus (Node/React)
* (D) GitHub Wiki / GitBook (hosted)

## Decision Outcome
Chosen option: **MkDocs + Material** because it offers full‑text search, a clean
sidebar, dark/light themes, and deploys to GitHub Pages with one line of CI
(`mkdocs gh-deploy`).  Python tooling is already available in the container,
adding only ~40 MB.

### Consequences
* **Positive:** Contributors write pure Markdown; no React/JSX knowledge.
* **Positive:** Documentation updates tested in the same Docker image.
* **Positive:** Public site auto‑publishes on merge to `main`.
* **Negative:** Adds `pip install mkdocs-material` to container build (~15 s).

### Confirmation
* New CI job builds docs and fails on broken links.
* Local preview via `mkdocs serve` documented in README.

## Pros and Cons of the Options
### (A) MkDocs + Material (chosen)
* **Good:** Zero JS build chain; excellent UX.
* **Neutral:** Python dependency.
* **Bad:** Less customizable than Docusaurus for interactive demos.

### (B) Plain Markdown folder
* **Good:** No tooling.
* **Bad:** No search/sidebar; harder to navigate as docs grow.

### (C) Docusaurus
* **Good:** First‑class versioning; MDX interactivity.
* **Bad:** Heavier Node toolchain; longer build times.

### (D) GitHub Wiki / GitBook
* **Good:** WYSIWYG editing.
* **Bad:** Docs live outside repo; separate review flow.

## More Information
Future ADR may expand CI to deploy preview docs for pull requests using
`mkdocs-material/pull-request-preview` action.
