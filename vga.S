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
  movl 8(%esp),%eax	//Cargo el valor de la columna de inicio
  cmp %eax, 0x00	// Si es mayor a 0 calculo desde el inicio sino desde el final
  jge calcInicioDesdeInicio
  jl calcInicioDesdeFinal

print:
  movl $0x642F,(%eax)
  movl $0xb8165,%eax
  ret


calcInicioDesdeInicio:
  // En %eax ya se debe encontrar cargado
  // el numero de fila para iniciar 
  movl $0x50,%ecx	//Cargo el 50 (80 en DEC) por %ECX
  mul %ecx		//multiplico la fila para obtener el inicio
  movl 9(%esp),%ebx 	//Cargo la columna
  add %ebx, %eax	//Sumo el offset de columnas
  add 0xb8000, %eax	//Sumo la direccion de inicio del buffer
  jmp print 		//Vuelvo para imprimir

calcInicioDesdeFinal:
  add $0x19,%eax	//Le sumo 25 al numero negativo para que me de la fila de inicio
  jmp calcInicioDesdeInicio


.globl vga3
vga3:
  ret

// Para el arranque con QEMU.
.align 4
multiboot:
    .long 0x1BADB002
    .long 0
    .long -0x1BADB002
