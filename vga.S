.globl vga1
vga1:
  ret


.globl vga2
vga2:
  ret


.globl vga3
vga3:
  ret


// Para el arranque con QEMU.
.align 4
multiboot:
    .long 0x1BADB002
    .long 0
    .long -0x1BADB002
