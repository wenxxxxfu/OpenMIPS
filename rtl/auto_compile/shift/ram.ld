MEMORY
        {      
        ram(RW)    : ORIGIN = 0x00000000, LENGTH = 0x00001000
        }
SECTIONS
{
	  /*
	  For some reason the linker script can't see the _reset_vector symbol 
	  (even if we declare it global), so we explicitly set it. */
	.text :
        {
        *(.text)
        } > ram
        .data :
        {
        *(.data)
        } > ram
        .bss :
        {
        *(.bss)
        } > ram
        .stack  ALIGN(0x10) (NOLOAD):
        {
        *(.stack)
        _ram_end = .;
        } > ram
}
ENTRY (_start)