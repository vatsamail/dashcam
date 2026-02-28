# Camera Subsystem

- Ingress protocol: `cam_valid`, `cam_sof`, `cam_pixel[7:0]`.
- Frame counter increments on `cam_sof` while capture enabled.
- Output stream drives DMA input.

Trace: REQ-CAM-001, REQ-CAM-002.
