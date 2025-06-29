# Loads .env automatically so all recipes see the variables
set dotenv-load := true

build:
    toolchains/$TOOLCHAIN}/pre.sh
    toolchains/$TOOLCHAIN}/build.sh
    toolchains/$TOOLCHAIN}/post.sh

patch:
    flips --create $ROM_INPUT_PATH $ROM_OUTPUT_PATH $PATCH_PATH

check:
    # Verify snapshot or create one if missing
    scripts/snapshot-check.sh || scripts/snapshot-save.sh
    # Validate JSON metadata hashes
    scripts/validate-patch-json.sh $PATCH_PATH.json

docs-build:
    mkdocs build --strict

docs-serve:
    mkdocs serve -a 0.0.0.0:8000

docs-deploy:
    mkdocs gh-deploy --force --clean
