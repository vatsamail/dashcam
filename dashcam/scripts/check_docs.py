#!/usr/bin/env python3
import pathlib
import re

root = pathlib.Path(__file__).resolve().parents[1]
req_file = root / "docs/requirements/system_requirements.md"
req_ids = set(re.findall(r"(REQ-[A-Z]+-\d{3})", req_file.read_text()))
if not req_ids:
    raise SystemExit("No requirement IDs found")

trace_hits = 0
for p in (root / "docs").rglob("*.md"):
    txt = p.read_text(errors="ignore")
    for rid in req_ids:
        if rid in txt:
            trace_hits += 1
print(f"docs check passed: {len(req_ids)} requirements, {trace_hits} trace hits")
