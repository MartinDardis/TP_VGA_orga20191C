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
  movl $0x00,%ebx
  movw 8(%esp),%cx	//Cargo el valor de la fila
  movw 10(%esp),%bx
  cmp %eax,0x00		// Si la fila es mayor a 0 calculo desde el inicio sino desde el final
  jl calcInicioDesdeFinal
  jmp calcInicioDesdeInicio
print2:
  movl 4(%esp),%edx	//Cargo el inicio del string
  movl 16(%esp),%ebx     //Cargo el codigo de color
go2:
  movb (%edx), %dl      //cargo el caracter en %dl
  test %dl, %dl         //Verifico si %dl es fin de linea y salgo si lo es
  je  exit
  movb %dl,(%eax)       //Escribo la letra
  movb %ebx,1(%eax)     //seteo el color
  add $0x1, %edx        //incremento el contador
  add $0x2, %eax        //incremento la dir del buffer
  jmp go2 

calcInicioDesdeFinal:
  not %cx
  inc %cx
  movl $25,%ecx
  sub  %ax,%cx
calcInicioDesdeInicio:
  // En %eax ya se debe encontrar cargado
  // el numero de fila para iniciar 
  movl $0xb8000,%eax
mult:
  test %cx,%cx
  jz sal
  add $80,%eax        //Cargo el 50 (80 en DEC) por %ECX
  dec %cx
  jmp mult		//multiplico la fila para obtener el inicio
sal:
  add %bx,%ax	//Sumo el offset de columnas
  jmp print2 		//Vuelvo para imprimir

.globl vga3
vga3:
  ret

// Para el arranque con QEMU.
.align 4
multiboot:
    .long 0x1BADB002
    .long 0
    .long -0x1BADB002
