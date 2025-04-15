#include "common/Real.h"

void boot_main(){
    regs test_regs = (regs){
        .eax = 0x4100,
        .ebx = 0x55aa,
        .edx = 0x80,
    };
    //Random comment 2
    regs out_regs;

    interrupt_call(0x13, &test_regs, &out_regs);

    if (out_regs.ebx == 0xaa55){
        asm volatile ("mov $0xdeadbeef, %%eax" : : : "eax");
    } else {
        asm volatile ("mov $0x10101010, %%eax" : : : "eax");
    }

    while (1){}
    
    return;
}
