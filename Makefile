SHELL=/bin/bash

disk: stage1.bin stage2.bin
	touch disk.iso
	dd if=/dev/zero of=disk.iso bs=1M count=1 conv=notrunc
	dd if=stage1.bin of=disk.iso conv=notrunc
	dd if=stage2.bin of=disk.iso seek=1 conv=notrunc

stage1.bin: bootsect.asm
	nasm bootsect.asm -f bin -o stage1.bin

stage2.bin: 
	make -C stage2/
	mv stage2/stage2.bin ./stage2.bin

run-qemu:
	qemu-system-x86_64 -hda disk.iso

clean: 
	rm disk.iso stage2.bin stage1.bin
	make clean -C stage2/
