#!/usr/bin/env bash
set -euo pipefail
vcs -sverilog ../../../../rtl/top/dashcam_soc_top.sv ../../verilator_smoke/tb_dashcam_smoke.sv -o simv
./simv
