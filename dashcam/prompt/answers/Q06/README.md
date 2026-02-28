# Q06 – DMA robustness

> Notes:
> - Commands assume repo root is the current directory.
> - If you have commercial tools, set environment variables as described in `compute_it/env_setup.md`.
> - Open-source fallbacks are listed for each step.


## Goal
Add DMA error handling and tests.

## Suggested DMA errors
- Unaligned destination address
- Transfer length too large for buffer
- Write response timeout (simulated)

## Implementation plan
1. Add error status bits in `DMA_STATUS` CSR + an `DMA_ERR_CODE` CSR.
2. Add `dma_err_irq` interrupt.
3. In DMA RTL, detect error, set status, raise IRQ, stop transfer.
4. Firmware:
   - Trigger an error intentionally (unaligned addr).
   - Confirm ISR runs and error code matches.
5. DV:
   - Add a test that expects error interrupt and checks CSR state.

## Run
```bash
make regs
make sw
make sim
```
