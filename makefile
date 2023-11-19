ASM=c:/nasm/nasm
DISC_IMG=build\bootable.img

.PHONY: all floppy_image bootloader kernel clean always

floppy_image: build/main_floppy.img
build/main_floppy.img: bootloader kernel
	echo. > .\build\main_floppy.img
	copy .\build\kernel.bin .\build\main_floppy.img

	type build\bootloader.bin > build\main_floppy.img

	trunc build/main_floppy.img 1474560
	./qemu/qemu-system-x86_64 -fda build/main_floppy.img

bootloader: build/bootloader.bin
build/bootloader.bin: always
	$(ASM) -f bin -o build/bootloader.bin src/bootloader/bootloader.asm

kernel: build/kernel.bin
build/kernel.bin: always
	$(ASM) -f bin -o build/kernel.bin src/kernel/kernel.asm

always:
	if not exist .\build mkdir .\build
clean:
	rmdir /s /q .\build\