#!/usr/bin/env bash
set -euo pipefail
make clean
make regs
make sw
make sim
