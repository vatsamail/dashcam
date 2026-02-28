# PSS Plan

Scenarios:
1. `pss_capture_single_frame`: one frame capture with IRQ service.
2. `pss_continuous_record`: repeated capture + SD flush.
3. `pss_error_recovery`: SD unavailable then recovery to capture-only mode.

Trace: REQ-CAM-001, REQ-DMA-001, REQ-SD-001.
