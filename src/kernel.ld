OUTPUT_FORMAT("elf32-i386")
ENTRY(start)

SECTIONS 
{
	. = 0x100000;
	.setup : { *(.setup) }
	
	. += 0xC0000000;	
	.text : AT(ADDR(.text) - 0xC0000000) { *(.text) }
	.data ALIGN (0x1000) : AT(ADDR(.data) - 0xC0000000) { *(.data) *(.rodata) }
	.bss : AT(ADDR(.bss) - 0xC0000000) { sbss = .; *(COMMON*) *(.bss*) ebss = .; }
	end = .;
}

