void boot_main(){
    asm volatile ("mov $0xdeadbeef, %%eax" : : : "eax");

    while (1){}
    
    return;
}
