# 🧩 Generic ROM Patching Template

A modern, extensible template for developing ROM patches across cartridge-based systems like the Sega Genesis. Features clean tooling, snapshot testing, metadata tracking, and CI/CD.

---

## WIP
Just a heads up, this isn't currently working and was more of a spur of the moment thing.

This has some interesting ideas but needs a lot of tlc before it is useful.

## 🚀 Features

- 🧱 Modular toolchain support (e.g., Sega Genesis w/ BPS)
- 🛠️ Devcontainer + Docker-based build environment
- 🧪 Snapshot testing and patch validation
- 📦 GitHub Releases integration with patch metadata
- 📋 `patch.json` tracks hash-locked metadata
- 🧩 Uses [BPS patches](https://www.romhacking.net/utilities/893/) (via flips)

---

## 📂 Project Layout

```
├── .env                        # Environment config
├── Justfile                   # Task runner
├── scripts/                   # Metadata + validation helpers
├── toolchains/                # Toolchain logic (per-console or method)
│   └── genesis-bps/           # Example: Sega Genesis BPS-based patching
│       ├── pre.sh             # Pre-build cleanup or setup
│       ├── build.sh           # ROM build (patching or compilation)
│       └── post.sh            # Final validation
├── roms/                      # Input/output ROMs (not committed)
├── patches/                   # Output .bps and .json metadata
├── snapshots/                # Golden reference outputs
└── .github/workflows/        # GitHub Actions CI
```

---

## ✅ Usage

### 1. 🐳 Start Devcontainer

```bash
# Recommended: VSCode Devcontainer, or build manually
```

### 2. 🧱 Build ROM

```bash
just build
```

### 3. 🔧 Generate Patch

```bash
just patch
```

### 4. 🧪 Verify Patch

```bash
just check
```

---

## 🧪 Patch Metadata (`patch.json`)

For each `.bps`, a `.json` file will be generated containing:

- SHA1 hashes of input/output/patch
- Toolchain name
- Author + version + timestamp
- Rebuild safety + archival validation

---

## 📦 GitHub Releases

When configured, a CI workflow:
- Builds ROM
- Validates snapshot
- Publishes patch + `.json` metadata

---

## 🧰 Toolchains

Each toolchain lives in `toolchains/<name>` with:
- `pre.sh`, `build.sh`, `post.sh`
- Hooked into `just build`
- Swappable via `.env`:

```
TOOLCHAIN=genesis-bps
```

You can create new toolchains like `snes-bps` or `gbc-asm` for other consoles or workflows.

---

## 🧠 Philosophy

- Zero ROMs committed: all patches are derived
- Declarative patch tracking via JSON
- Extensible for any cartridge-style system

---

## 📄 License

MIT. Patches built using this template may have separate licensing requirements.
