
inst_rom.om:     file format elf32-tradbigmips


Disassembly of section .text:

00000000 <_start>:
   0:	34011100 	li	at,0x1100
   4:	34020020 	li	v0,0x20
   8:	3403ff00 	li	v1,0xff00
   c:	3404ffff 	li	a0,0xffff

Disassembly of section .reginfo:

00000010 <.reginfo>:
  10:	0000001e 	0x1e
	...

Disassembly of section .MIPS.abiflags:

00000028 <_ram_end-0x18>:
  28:	00002001 	movf	a0,zero,$fcc0
  2c:	01010001 	movt	zero,t0,$fcc0
	...
  38:	00000001 	movf	zero,zero,$fcc0
  3c:	00000000 	nop

Disassembly of section .gnu.attributes:

00000000 <.gnu.attributes>:
   0:	41000000 	0x41000000
   4:	0f676e75 	jal	d9db9d4 <_ram_end+0xd9db994>
   8:	00010000 	sll	zero,at,0x0
   c:	00070401 	0x70401
