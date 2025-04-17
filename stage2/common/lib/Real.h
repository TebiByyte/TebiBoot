#ifndef __REAL__H
#define __REAL__H

#include <stdint.h>

typedef struct __attribute__((__packed__)) regs{
    uint32_t eax;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint32_t ebp;
    uint32_t eflags;
    uint16_t ds;
    uint16_t gs;
    uint16_t fs;
    uint16_t es;
} regs;

void interrupt_call(uint8_t int_num, regs *in_regs, regs *out_regs);

#endif
