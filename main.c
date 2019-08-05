#include <stdint.h>

// vga1() escribe una cadena al comienzo del buffer VGA. La
// cadena no debe tener ni saltos de línea ni tabuladores (solo
// caracteres ASCII imprimibles).
void vga1(const char *msg, uint8_t color);

// vga2() escribe una cadena en posición indicada (línea y
// columna), y devuelve un puntero a la siguiente posición
// del buffer VGA (la primera no escrita). La línea puede
// ser un número negativo, en cuyo caso se debe contar desde
// la última línea hacia arriba.
void *vga2(const char *msg, int8_t linea, uint8_t col, uint8_t color);

// vga3() escribe una cadena en dirección de memoria marcada
// por la variable global VGAPOS, actualizando esta variable
// tras escribir. La función maneja los saltos de línea así:
// se añade una nueva línea y se alinea el texto con la anterior.
void vga3(const char *msg, uint8_t color);

// La variable global para vga3().
char *VGAPOS;

void _start(void) {
    vga1("Hola desde vga1(). Se imprime al comienzo del buffer VGA.", 0x2F);

    char *pos1 = vga2("Hola desde vga2(5, 20).", 5, 20, 0x4F);

    char *pos2 = vga2("Hola desde vga2(-16, 10).", -16, 10, 0x4F);

    VGAPOS = pos1;
    vga3("Hola,\nciao.", 0xE0);
    vga3("Falta poco para terminar.", 0x3F);

    VGAPOS = pos2 + 162;
    vga3("Byeeee!", 0xD0);

    __asm__("hlt");
}
