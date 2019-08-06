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
  movb 8(%esp),%cl	//Cargo el valor de la fila
  movb 12(%esp),%bl	//Cargo el offset de columnas
  cmp $0x00,%cl		// Si la fila es mayor a 0 calculo desde el inicio sino desde el final
  jl calcInicioDesdeFinal
  jmp calcInicioDesdeInicio
print2:
  movl 4(%esp),%ecx	//Cargo el inicio del string
  movl 16(%esp),%ebx     //Cargo el codigo de color 
go2:
  movb (%ecx), %dl      //cargo el caracter en %dl
  test %dl, %dl         //Verifico si %dl es fin de linea y salgo si lo es
  je  exit
  movb %dl,(%eax)       //Escribo la letra
  movl %ebx,1(%eax)     //seteo el color
  add $0x1, %ecx        //incremento el puntero del string
  add $0x2, %eax        //incremento la dir del buffer
  movb $0x00,%dl
  jmp go2 

// %cl contiene el numero de fila
// %bl el offset de columna
calcInicioDesdeFinal:
  neg %cl
  movb $0x19,%al	//Cargo el 25 (max filas)
  sub  %cl,%al          //Le resto el valor de las columnas
  movb %al,%cl          // Actualizo %cl con el nuevo valor de columna de inicio
calcInicioDesdeInicio:
  // En %cx ya se debe encontrar cargado
  // el numero de fila para iniciar 
  movl $0xb8000,%eax	//Cargo la direccion base
sumFilas:		//Mientras que %cl no sea 0, sumo una fila
  test %cl,%cl
  je sumColumnas
  add $0xA0,%eax        //Incremento una fila 80 celdas = 160 bytes
  dec %cl		//Decremento la cant de filas restantes
  jmp sumFilas		
sumColumnas:
  test %bl,%bl		//Sumo el offset de columnas
  je print2
  add $0x02,%eax
  dec %bl	
  jmp sumColumnas	//Vuelvo para imprimir

.globl vga3
vga3:
  movl 8(%esp),%ebx     // Obtengo el color y lo guardo en %ebx
  movl (%ebp),%eax      // Cargo el inicio del buffer donde escribir
  movl 4(%esp),%ecx     // cargo el inicio del string
go3:
  movb (%ecx), %dl      //cargo el caracter en %dl
  test %dl, %dl         //Verifico si %dl es fin de linea y salgo si lo es
  je  exit
  cmp $0x0A,%dl
  je saltoLinea
  movb %dl,(%eax)       //Escribo la letra
  movl %ebx,1(%eax)     //seteo el color
  add $0x2, %eax        //incremento la dir del buffer
incCaracter3:
  add $0x1, %ecx        //incremento el contador
  jmp go3

saltoLinea:
  add $0xA0, %eax
  jmp incCaracter3




// Para el arranque con QEMU.
.align 4
multiboot:
    .long 0x1BADB002
    .long 0
    .long -0x1BADB002
