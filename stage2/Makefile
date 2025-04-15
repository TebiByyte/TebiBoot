SHELL=/bin/bash
CSRCS = $(shell find -name "*.c")
ASMSRCS = entry.asm $(shell find ./common -name "*.asm")
INCLUDE = common/
CHEAD = $(shell find -name "*.h")

COBJS = $(patsubst %.c, %.o, $(CSRCS))
ASMOBJS = $(patsubst %.asm, %.o, $(ASMSRCS))
GCCFLAGS = -I $(INCLUDE) -m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -mno-red-zone -mgeneral-regs-only 

stage2.bin: $(COBJS) $(ASMOBJS)
	ld -m elf_i386 -o stage2.bin -T stage2.ld -Ttext 0x8000 $(ASMOBJS) $(COBJS) --oformat binary

%.o: %.c $(CHEAD)
	gcc $(GCCFLAGS) -c $< -o $@

%.o: %.asm
	nasm $< -f elf32 -o $@

clean:
	rm $(COBJS) $(ASMOBJS) 
