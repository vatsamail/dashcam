#include <stdint.h>
#include "dashcam_regs.h"

static inline void mmio_write(uint32_t addr, uint32_t val) {
#ifndef HOST_BUILD
    *(volatile uint32_t *)(uintptr_t)addr = val;
#else
    (void)addr;
    (void)val;
#endif
}

static inline uint32_t mmio_read(uint32_t addr) {
#ifndef HOST_BUILD
    return *(volatile uint32_t *)(uintptr_t)addr;
#else
    (void)addr;
    return 0;
#endif
}

void dashcam_record_loop(void) {
    mmio_write(REG_DMA_BASE, 0x0);
    mmio_write(REG_DMA_LEN, 64);
    mmio_write(REG_IOMUX_SEL, 0x3);
    mmio_write(REG_CTRL, (1u << 0) | (1u << 2) | (1u << 3));

    for (;;) {
        mmio_write(REG_CTRL, (1u << 0) | (1u << 1) | (1u << 2) | (1u << 3));
        while ((mmio_read(REG_IRQ_STATUS) & 1u) == 0u) {
        }
        mmio_write(REG_IRQ_CLEAR, 1u);
    }
}

#ifndef HOST_BUILD
void _start(void) { dashcam_record_loop(); }
#else
int main(void) { dashcam_record_loop(); return 0; }
#endif
