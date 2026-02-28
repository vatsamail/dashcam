#!/usr/bin/env bash
set -euo pipefail
xrun -sv ../../../../rtl/top/dashcam_soc_top.sv ../../verilator_smoke/tb_dashcam_smoke.sv -R
