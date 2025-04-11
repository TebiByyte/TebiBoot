SHELL=/bin/bash
CSRCS = $(shell find -name "*.c")
ASMSRCS = $(shell find -name "*.asm")

COBJS = $(patsubst %.c, %.o, $(CSRCS))
ASMOBJS = $(patsubst %.asm, %.o, $(ASMSRCS))
GCCFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -mno-red-zone -mgeneral-regs-only 

stage2.bin: $(COBJS) $(ASMOBJS)
	ld -m elf_i386 -o stage2.bin -T stage2.ld -Ttext 0x8000 $(ASMOBJS) $(COBJS) --oformat binary

%.o: %.c
	gcc $(GCCFLAGS) -c $< -o $@

%.o: %.asm
	nasm $< -f elf32 -o $@

clean:
	rm $(COBJS) $(ASMOBJS) 
