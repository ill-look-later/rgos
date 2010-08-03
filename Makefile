.SUFFIXES:
.PHONY: clean all

CFLAGS = -Wall -Wextra -Werror -nostartfiles -nodefaultlibs -nostdlib
S_SRCS := $(shell find src/ -iname '*.s')
C_SRCS := $(shell find src/ -iname '*.c')

all: rgos.iso
clean:
	-rm *.elf *.iso src/*.o src/*~

%.o: %.c
	@echo CC $<
	@gcc -o $@ -c $< $(CFLAGS)

%.o: %.s
	@echo AS $<
	@as -o $@ $<

kernel.elf: $(S_SRCS:.s=.o) $(C_SRCS:.c=.o)
	@echo LD $@
	@ld -T src/kernel.ld -o $@ $^

rgos.iso: kernel.elf
	@echo ISO $@
	@genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 \
	-boot-info-table -o $@ -graft-points \
	boot/kernel.elf=kernel.elf \
	boot/grub/menu.lst=src/menu.lst \
	boot/grub/stage2_eltorito=thirdparty/stage2_eltorito
	cp $@ ~/vm/
