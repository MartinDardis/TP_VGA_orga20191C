.globl vga1

//Para lograr imprimir correctamente se debe imprimir
//El caracter en la posicion y en la posicion +1 el
//codigo del color. Ej: 8000 la H y 8001 "2F"
vga1:
  movl 8(%esp),%eax 	// Obtengo el color y lo guardo en %eax
  movl $0xb8000,%ebx
  movl 4(%esp),%ecx //cargo el inicio del string
  movl (%ecx),%edx	//Obtengo la primer letra en la posicion con el valor de %edx
go1:
  cmp %edx,0x00		//Si es null voy a la salida
  je  exit
  movl %edx,(%ebx)	//Escribo la letra
  movl %eax,1(%ebx)	//seteo el color
  add $0x1, %ecx    //incremento el contador
  add $0x2, %ebx	//incremento la dir del buffer
  movl (%ecx),%edx	//Obtengo la letra en la posicion con el valor de %edx
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
