# Tapeout Readiness Plan (Sky130 @ 200MHz, 1.8V)

## Scope
- Canonical top: `top/dashcam_top/rtl/dashcam_soc_top.sv`
- Bus: Wishbone
- Target: 200MHz @ 1.8V (Sky130)

## Phase 0: Requirements & Architecture Freeze
Deliverables:
- Final requirements: `docs/requirements/system_requirements.md`
- Memory/interrupt maps: `docs/specs/address_map/address_map.md`, `docs/specs/interrupts/interrupt_map.md`
- Block diagram: `docs/architecture/block_diagram.mmd`
Exit criteria:
- Requirements traced to RTL + verification plan
- Address map frozen

## Phase 1: RTL & CSR Integration
Deliverables:
- RTL under `ips/`, `fips/`, `top/`
- SystemRDL source: `ips/csr_regs/dashcam_csr.rdl`
- Generated RTL/headers/IP-XACT from `make regs`
Exit criteria:
- Lint clean (or waivered)
- CSR collateral reviewed

## Phase 2: Verification
Deliverables:
- Smoke sim: `dv/sim/verilator_smoke/`
- CDC/RDC plan: `docs/verification/cdc_rdc_plan.md`
- DFT plan: `docs/verification/dft_plan.md`
Exit criteria:
- Smoke sim passes and produces `dv/sim/verilator_smoke/out/frame_0000.ppm`
- CDC/RDC issues triaged

## Phase 3: DFT Insertion
Deliverables:
- Scan strategy + chain planning
- MBIST/LBIST integration plan
- JTAG/BSCAN integration
Exit criteria:
- DFT coverage targets met (stubbed until toolchain installed)

## Phase 4: Synthesis & STA
Deliverables:
- SDC: `constraints/sky130/dashcam_soc_top.sdc`
- Synth netlist + reports (Yosys/OpenROAD)
Exit criteria:
- No unconstrained paths
- Setup/hold clean at 200MHz target

## Phase 5: PnR
Deliverables:
- Floorplan, placement, CTS, routing (OpenROAD native; OpenLane optional)
- DEF/GDS placeholders
Exit criteria:
- DRC clean (or waivered)
- LVS clean (or waivered)

## Phase 6: Signoff
Deliverables:
- LEC (RTL vs netlist)
- Post-layout STA + SDF
- IR/EM reports
Exit criteria:
- Signoff checks clean (or waivered)

## Phase 7: Handoff
Deliverables:
- Final netlist, SDF, GDS, signoff reports
- Release checklist
