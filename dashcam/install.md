# Install

## Submodules
This repo uses git submodules for `third_party/` dependencies.
After cloning, run:
1. `git submodule update --init --recursive`

## Large Assets (_dont_ship)
This repo keeps very large files out of git. Files larger than 5MB are moved into `_dont_ship/` and replaced with symlinks at their original locations.

To generate `_dont_ship/` on a fresh checkout:
1. Place required tool sources under `tools/` (for example `tools/OpenROAD-src` and `tools/OpenLane` as referenced by `scripts/build_openroad_native.sh` and `scripts/run_openlane.sh`).
2. Run `scripts/prepare_dont_ship.sh` to move large files into `_dont_ship/` and create symlinks.
3. If you need OpenROAD build outputs, run `scripts/build_openroad_native.sh` (this will repopulate `tools/OpenROAD-src/build/` and `scripts/prepare_dont_ship.sh` will move the large artifacts into `_dont_ship/`).

Notes:
- `_dont_ship/` is ignored by git and must be created locally.
- For OpenROAD source builds, fetch submodules inside `tools/OpenROAD-src` before building (`git submodule update --init --recursive`).
