# CDC/RDC Plan

## Clocks
- Primary: `clk` in `dashcam_soc_top`
- Reset: `rst_n` (async assert, sync deassert via `reset_sync`)

## CDC Strategy
- Current design is single-clock; CDC checks are clean by construction
- For multi-clock expansion, use 2-flop sync for single-bit control signals
- Use async FIFOs for data streams crossing clock domains

## RDC Strategy
- All async resets must be synchronized to each clock domain
- `reset_sync` is instantiated in `dashcam_soc_top` and feeds all RTL blocks

## Checks
- Static CDC/RDC lint (tool-dependent)
- Assertion-based checks for metastability in critical paths
