#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THRESHOLD="${1:-5M}"

mkdir -p "${ROOT_DIR}/_dont_ship"

find "${ROOT_DIR}" -type f -size +"${THRESHOLD}" \
  -not -path "${ROOT_DIR}/.git/*" \
  -not -path "${ROOT_DIR}/_dont_ship/*" \
  -print0 | ROOT_DIR="${ROOT_DIR}" python3 -c 'import os, sys, shutil

data = sys.stdin.buffer.read().split(b"\0")
paths = [p.decode() for p in data if p]
root = os.environ.get("ROOT_DIR", os.getcwd())
dont = os.path.join(root, "_dont_ship")

if not paths:
    print("No large files found.")
    sys.exit(0)

for abs_path in paths:
    abs_path = os.path.abspath(abs_path)
    if not abs_path.startswith(root + os.sep):
        continue
    rel = os.path.relpath(abs_path, root)
    dest = os.path.join(dont, rel)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    # Move file into _dont_ship and replace with a relative symlink.
    shutil.move(abs_path, dest)
    link_target = os.path.relpath(dest, os.path.dirname(abs_path))
    os.symlink(link_target, abs_path)
    print(f"moved {rel} -> _dont_ship/{rel}")
'
