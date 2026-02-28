#include <stdint.h>
#include "dashcam_regs.h"

int main(void) {
    volatile uint32_t *ctrl = (uint32_t *)REG_CTRL;
    volatile uint32_t *dma_base = (uint32_t *)REG_DMA_BASE;
    volatile uint32_t *dma_len = (uint32_t *)REG_DMA_LEN;
    volatile uint32_t *iomux = (uint32_t *)REG_IOMUX_SEL;

    *dma_base = 0x00000000u;
    *dma_len = 64u;
    *iomux = 0x0u;
    *ctrl = 0x0Fu;

    while (1) {
        // idle loop
    }
    return 0;
}
