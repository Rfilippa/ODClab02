	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xb2, lsl 16
	movk x10, 0xfff, lsl 00
	movz x17, 0xfff, lsl 00
	movk x17, 0xfff, lsl 16
	mov x16, -120 
	mov x18, -120

inf:
	mov x0, x20 // reset de direccion de x0
	mov x2, SCREEN_HEIGH         // Y Size

loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	b circulo
creturn:	
	add x0,x0,4    			// Siguiente pixel
	sub x1,x1,1    			// Decrementar contador X
	cbnz x1,loop0  			// Si no terminó la fila, salto
	sub x2,x2,1    			// Decrementar contador Y
	cbnz x2,loop1  			// Si no es la última fila, salto
	add x16, x16, #1 		// aumenta un uno el centro en el eje y
	add x19, x18, x16 		//guarda la suma del eje y actual y el valor de reinicio
	cmp x19, SCREEN_HEIGH   //compara la altura con el valor anterior
	b.eq restartmov 		// si son iguales reinicia el eje y
backinf:
	b inf

restartmov:
	mov x16, -120 			// reincia el eje y
	b backinf 				// vuelve al ciclo




circulo:
	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x2, x16			// setea x4 con el valor de Y actual
	mul x4, x4, x4			// (y-yi).(y-yi)
	add x4, x4, x3			// los suma
	movz x5, 0xf00, lsl 00  // ancho del circulo
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.le Colorear			// si estan en el conjunto los Colorear
returnC:
	b creturn
Colorear:
	stur w17,[x0]			// pinta el bit con x17
	b returnC	



	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
	// al inmediato se lo refiere como "máscara" en este caso:
	// - Al hacer AND revela el estado del bit 2
	// - Al hacer OR "setea" el bit 2 en 1
	// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
	and w11, w10, 0b00000010

	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado

	//---------------------------------------------------------------
	// Infinite Loop

