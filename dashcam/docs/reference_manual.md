# Dashcam SoC Reference Manual

## Register Programming Summary
- Write `DMA_BASE` and `DMA_LEN`
- Configure `IOMUX_SEL`
- Set `CTRL[0]=1` camera enable
- Pulse `CTRL[1]=1` DMA start
- Wait for `IRQ_STATUS[0]`
- Clear with `IRQ_CLEAR[0]=1`

## Interrupts
- IRQ0: DMA done

## Storage
- `CTRL[2]` enables SD write trigger on DMA completion.
