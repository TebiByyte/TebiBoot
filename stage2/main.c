#include "common/lib/a20.h"
#include <stdint.h>

void boot_main(){

    if (!enable_a20()){
        uint8_t *test_byte = (uint8_t*)0x7DFE; //Boot sector signature, this is definitely ok to write to
        uint8_t *odd_meg_location = (uint8_t*)(0x7DFE | (1 << 20));

        uint8_t value = *test_byte;
        uint8_t value1 = *odd_meg_location;

        asm volatile ("mov %0, %%eax" : : "m" (value) : "eax");
        asm volatile ("mov %0, %%ebx" : : "m" (value1) : "ebx");
    } else {
        asm volatile ("mov $0xdeadbeef, %%eax" ::: "eax");
    }

    while (1){}
    
    return;
}
