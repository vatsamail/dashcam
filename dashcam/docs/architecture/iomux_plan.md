# IOMUX Plan

- REQ-IOMUX-001: `IOMUX_SEL[1:0]` selects function for debug/camera/SPI group.
- Default reset mapping:
  - 0: camera DVP pins enabled
  - 1: SD SPI pins enabled
  - 2: UART debug
  - 3: GPIO test mode
