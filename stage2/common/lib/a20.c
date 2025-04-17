#include "a20.h"
#include <stdint.h>

bool test_a20(){
    uint8_t *test_byte = (uint8_t*)0x7DFE; //Boot sector signature, this is definitely ok to write to
    uint8_t *odd_meg_location = (uint8_t*)(0x7DFE | (1 << 20));

    if (*test_byte == *odd_meg_location){ // If they're the same we need to rule out this isn't by coincidence
        *test_byte >>= 4;

        return *test_byte != *odd_meg_location; 
    }

    return true;
}

void bios_enable(){

}

//Returns false for failure, true for success
bool enable_a20(){
    if (!test_a20()){
        //TODO find emulator where a20 is not enabled
    }

    return test_a20();
}

