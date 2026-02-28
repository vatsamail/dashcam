# Threat Model

Assets: recorded video, firmware image, debug interfaces.

Threats:
- REQ-SEC-001-T1: unauthorized firmware execution.
- REQ-SEC-001-T2: debug port abuse.
- REQ-SEC-001-T3: tampered storage artifacts.

Mitigations (mock):
- Secure boot hash check placeholder in boot ROM flow.
- JTAG lock bit in lifecycle state model.
- Metadata integrity tag placeholder in SD write path.
