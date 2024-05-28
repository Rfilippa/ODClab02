	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34
	.equ DUR_ANI_PLANETAS, 0x0
	.equ DUR_ANIMACION_TOTAL, 0x0

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
	mov x22, SCREEN_WIDTH 
	mov x23, SCREEN_HEIGH
	mul x22, x22, x23	// final ADDs

	movz x10, 0xf00, lsl 16     // color fondo
	movk x10, 0xf00, lsl 00

	mov x17,0

	movz x13, 0xccfe, lsl 00	// color ventana
	movk x13, 0x0002, lsl 16
	movz x29, 0xff0, lsl 16 

	mov x16, 240 		// start del objeto 
	mov x18, -190       // fin de movimiento

	mov x11, SCREEN_HEIGH // contador decreciente

	mov x6, 50
	mov x24, 240
	mov x8, 75
	mov x12, 0x200 // tiempo animacion planetas
	mov x25 , 240
	mov x27, xzr
	mov x28, 75
	mov x7, xzr
	mov x21, 0x40
	movz x25, 0x3300, lsl 16     // color fondo
	movk x25, 0x1c28, lsl 00
	//movz x25, 0x0000, lsl 16     // color fondo
	//movk x25, 0x0000, lsl 00

// NO USAR, SON GLOBALES: x0, x1, x2, x21, x18, x6, x8


inf:
	mov x0, x20 			// reset de direccion de x0
	mov x2, SCREEN_HEIGH         // Y Size
	movz x25, 0x0000, lsl 16     // color fondo
	movk x25, 0x00ff, lsl 00
	//add x25, x25 , 1
loop1:
	mov x1, SCREEN_WIDTH         // X Size
	sub x25, x25 , 1
	//movz x25, 0x0000, lsl 16     // color fondo
	//movk x25, 0x0000, lsl 00
	//add x25, x25 , 0xf
loop0:
	//add x25, x25 ,1
	stur w25,[x0]  			// Colorear el pixel N	
	
	b oPaint
oPaintRet:

	add x0,x0,4    			// Siguiente pixel
	sub x1,x1,1    			// Decrementar contador X
	cbnz x1,loop0  			// Si no terminó la fila, salto
	sub x2,x2,1    			// Decrementar contador Y
	cbnz x2,loop1  			// Si no es la última fila, salto
	
	add x16, x16, #1 		// aumenta un uno el centro en el eje y
	sub x11, x11, 1			// disminuye contador negativo
	add x19, x18, x16 		// guarda la suma del eje y actual y el valor de reinicio
	cmp x19, SCREEN_HEIGH   // compara la altura con el valor anterior
	b.eq restartmov 		// si son iguales reinicia el eje y
backinf:

	subs xzr, x11, 70
	sub x12, x12, 1 // decrece tiempo de animacion en planetas
	b.mi reducirtamPL
reducirtamRet:

	subs x21, x21, 1 //delay animacion blackhole
	b.pl skip2
	bl movBH
skip2:

	b inf

restartmov:
	mov x16, 240 			// reincia el eje y
	mov x11, SCREEN_HEIGH
	b backinf 				// vuelve al ciclo

reducirtamPL:
	add x27, x27, 120
	b reducirtamRet

movBH:
	b movHole1
movHole1Ret:
	b movHole2
movHole2Ret:
	b movHole3
movHole3Ret:
	ret

oPaint:
	b blackHole1
blackHole1Ret:
	BL llamas
llamasRet:	
	b nave
creturn:	
	b coheteatras
coheteRet:
	b planetas
planetasRet:

	b oPaintRet

movHole1:
	subs xzr, x17, 2
	b.ne movHole1Ret
	cbz x7, abajo1
	add x28, x28,1
	add x8, x8, 1
	add x6, x6, 1
	subs xzr, x28, 75
	b.ne movHole1Ret
	mov x7, 0
	mov x17, 0
	movz x21, 0x20, lsl 00 //delay 
	b movHole1Ret
abajo1:
	sub x28, x28, 1
	sub x8, x8, 1
	sub x6, x6, 1
	subs xzr, x28, 60
	b.ne movHole1Ret
	mov x7, 1
	b movHole1Ret

movHole2:
	subs xzr, x17, 1
	b.ne movHole2Ret
	cbz x7, abajo2
	add x8, x8, 1
	add x6, x6, 1
	subs xzr, x8, 75
	b.ne movHole2Ret
	mov x7, 0
	mov x17, 2
	b movHole2Ret
abajo2:
	sub x8, x8, 1
	sub x6, x6, 1
	subs xzr, x8, 60
	b.ne movHole2Ret
	mov x7, 1
	b movHole2Ret

movHole3:
	subs xzr, x17, 0
	b.ne movHole3Ret
	cbz x7, abajo3
	add x6, x6, 1
	subs xzr, x6, 50
	b.ne movHole3Ret
	mov x7, 0
	mov x17, 1
//	movz x21, 0x60, lsl 00 //delay 
	b movHole3Ret
abajo3:
	sub x6, x6, 1
	subs xzr, x6, 30
	b.ne movHole3Ret
	mov x7, 1
	b movHole3Ret

planetas:
	cmp x12, xzr
	b.le skip1
	b planeta1 // duracion : 0x130
skip1:
	cbnz x12, restartTamPL
	mov x27, xzr
restartTamPL:
	b planeta2

//	b planeta3
//planeta3Ret:
//	b planeta4
//planeta4Ret:


planeta1:
	movz x10, 0xfff0, lsl 00	// color forma
	movk x10, 0x0080, lsl 16	
	add x3, x11, 300
	sub x3, x1, x3 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x2, x11			// setea x4 con el valor de Y actual
	mul x4, x4, x4			// (y-yi).(y-yi)
	add x4, x4, x3			// los suma
	movz x5, 0x700, lsl 0   // ancho del circulo 0x500
	sub x5, x5, x27 
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt planetasRet			// vuelve si es mayor 
	stur w10,[x0]			// pinta el pixel
	b planetasRet

planeta2: 
	movz x10, 0x8080, lsl 00	// color forma
	movk x10, 0xfff0, lsl 16	
	sub x3, x11, 400
	add x3, x1, x3 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x2, x11			// setea x4 con el valor de Y actual
	mul x4, x4, x4			// (y-yi).(y-yi)
	add x4, x4, x3			// los suma
	movz x5, 0x700, lsl 0   // ancho del circulo 0x500
	sub x5, x5, x27 
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt planetasRet			// vuelve si es mayor 
	stur w10,[x0]			// pinta el pixel
	b planetasRet


nave:
	movz x10, 0x8080, lsl 00	// color forma
	movk x10, 0x0080, lsl 16
	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x2, x16			// setea x4 con el valor de Y actual
	mul x4, x4, x4			// (y-yi).(y-yi)
	lsr x4, x4, 3			// divido por 3 (y-yi).(y-yi) puedo unir ->
	add x4, x4, x3			// los suma
	movz x5, 0x300, lsl 0   // ancho del circulo 0x500
	//sub x5, x5, x8 
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt creturn			// vuelve si es mayor 
	//bl and
	stur w10,[x0]			// pinta el pixel
	b ventana				// branch a ventana
ventanaRet:	
	bl cuadrado
cuadRet:
	b creturn				// vuelta al ciclo principal
//and:
//	sub x5, x16, 75
//	cmp x5, x2
//	b.gt creturn
//	ret


ventana:
	movz x10, 0xccfe, lsl 00	// color ventana
	movk x10, 0x0002, lsl 16
	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	add x23, x16, 25		// sube 35 pixels desde el centro relativo
	sub x4, x2, x23			// setea x4 con el valor de Y actual
	mul x4, x4, x4			// (y-yi).(y-yi)
	add x4, x4, x3			//suma X+Y
	movz x5, 0x150, lsl 0   // ancho del circulo
	//sub x5, x5, x12 		// descrece *x12 en tamaño
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt ventanaRet
	stur w10,[x0]			// pinta el pixel
	b ventanaRet

 //arreglar, idea de acicar para arriba descartada
 //q se lo coma el agujero negro
coheteatras:
	movz x10, 0x8b0, lsl 16 
	sub x3, x1, 320
	sub x14, x16, 90		// si quiero usar el valor de x16 y modificarlo, guardar en sp
   	sub x14, x2, x14		// centrar (0,0) en x16-105 aka x14
	sub x15, x1, 320        // 
	add x3, x14, x15		// X+Y
	b absoluto1				// |X+Y| absoluto
absRet1:
	movz x5, 27				// ancho de inervalo
	cmp x3, x5 				// comparo registros
	b.gt coheteRet			// si son menores al ancho sigo		
	sub x4, x14, x15		// X-Y
	b absoluto2				// |X-Y| absoluto
absRet2:
	cmp x4, x5				// comparo
	b.gt coheteRet			// si son menores al ancho sigo
	cmp x14, xzr			// si X' (relativo) > 0 seguir
	b.le coheteRet			// 
	stur w10,[x0]			// si ambas condiciones se dan => colorear
	b coheteRet				// volver al caller
	
//naranja movz x10, 0x810, lsl 00	// color forma
//		  movk x10, 0xefb, lsl 16

llamas:
	movz x10, 0xc300, lsl 00	// color forma
	movk x10, 0xff, lsl 16

	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x16, 120
	sub x4, x2, x4			// setea x4 con el valor de Y actual
	mul x4, x4, x4			// (y-yi).(y-yi)
//	lsr x4, x4, 3			// divido por 3 (y-yi).(y-yi) puedo unir ->
	add x4, x3, x4, lsr 4	// los suma
	movz x5, 0x90, lsl 0   // ancho del circulo 0x500
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt llamasRet			// vuelve si es mayor 
	stur w10,[x0]			// pinta el pixel
		b llamaMenor
llamaMRet:
	ret 

cuadrado:
	movz x10, 0x8b0, lsl 16 
	sub x3, x1, 320
	mul x3, x3, x3			// (x-320).(x-320)
	movz x5, 0x400, lsl 0
	//sub x5, x5, x18
	cmp x3, x5
	b.gt cuadRet
	add x26, x16, 83
	sub x3, x2, x26
	mul x3, x3, x3
	cmp x3, x5
	b.gt cuadRet
	str w10,[x0]
	ret

absoluto1: 
	cmp x3, xzr
	b.pl absRet1
	sub x3, xzr, x3
	b absRet1

absoluto2: 
	cmp x4, xzr
	b.pl absRet2
	sub x4, xzr, x4
	b absRet2

llamaMenor:
	movz x10, 0x000, lsl 00	// color forma
	movk x10, 0xfff, lsl 16
	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x16, 115
	sub x4, x2, x4			// setea x4 con el valor de Y actual
	mul x4, x4, x4			// (y-yi).(y-yi)
							// divido por 4 (y-yi).(y-yi) puedo unir ->
	add x4, x3, x4, lsr 4	// los suma
	movz x5, 0x35, lsl 0   // ancho del circulo 0x500
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt llamaMRet			// vuelve si es mayor 
	stur w10,[x0]
	b llamaMRet

blackHole1:
	movz x10, 0x4200, lsl 00	// color forma
	movk x10, 0x0ff7, lsl 16
	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x2, x28			// 75-20
	mul x4, x4, x4			// (y-yi).(y-yi)
							// divido por 4 (y-yi).(y-yi) puedo unir ->
	add x4, x4, x3, lsr 4	// los suma
	movz x5, 0xf00, lsl 0   // ancho del circulo 0x500
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt blackHole1Ret			// vuelve si es mayor 
	stur w10,[x0]
	b blackHole2
blackHole2Ret:
	b blackHole1Ret

blackHole2:
	movz x10, 0xf000, lsl 00	// color forma
	movk x10, 0x0fff, lsl 16
	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x2, x8			// 75-20
	mul x4, x4, x4			// (y-yi).(y-yi)
							// divido por 4 (y-yi).(y-yi) puedo unir ->
	add x4, x4, x3, lsr 4	// los suma
	movz x5, 0x900, lsl 0   // ancho del circulo 0x500
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt blackHole2Ret			// vuelve si es mayor 
	stur w10,[x0]
	b blackHole3
blackHole3Ret:
	b blackHole2Ret

blackHole3:
	movz x10, 0x0000, lsl 00	// color forma
	movk x10, 0x0000, lsl 16
	sub x3, x1, 320 		// setea x3 con el valor de X-320 
	mul x3, x3, x3			// (x-320).(x-320)
	sub x4, x2, x6			// 75-20
	mul x4, x4, x4			// (y-yi).(y-yi)
							// divido por 4 (y-yi).(y-yi) puedo unir ->
	add x4, x4, x3, lsr 4	// los suma y divide 4
	movz x5, 0x500, lsl 0   // ancho del circulo 0x500
	cmp x4, x5				// chequea los valores que forman parte del circulo
	b.gt blackHole3Ret			// vuelve si es mayor 
	stur w10,[x0]
	b blackHole3Ret
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

