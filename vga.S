.globl vga1

//Para lograr imprimir correctamente se debe imprimir
//El caracter en la posicion y en la posicion +1 el
//codigo del color. Ej: 8000 la H y 8001 "2F"
vga1:
  movl 8(%esp),%eax 	// Obtengo el color y lo guardo en %eax
  movl $0xb8000,%ebx    // Cargo el inicio del buffer donde escribir
  movl 4(%esp),%ecx     // cargo el inicio del string
go1:
  movb (%ecx), %dl	//cargo el caracter en %dl
  test %dl, %dl		//Verifico si %dl es fin de linea y salgo si lo es
  je  exit
  movb %dl,(%ebx)       //Escribo la letra
  movl %eax,1(%ebx)	//seteo el color
  add $0x1, %ecx        //incremento el contador
  add $0x2, %ebx	//incremento la dir del buffer
  jmp go1
exit:
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
