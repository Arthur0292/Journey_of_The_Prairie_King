#a1 = x
#a2 = y
#a3 = largura
#a4 = altura

colisao:
la t0, MAPA_COLISAO_ATUAL	#carrego o mapa de colisao
lw t0, 0(t0)	
mv t6, t0	#movo o endereco para t6

mv t4, a1	#movo o x e y em t4 e t5
mv t5, a2

canto1:#(x, y)
li t1, 320
mul t1, t1, t5	#320 * y
add t1, t1, t4	#(320 * y) + x
add t2, t6, t1
lbu t3, 0(t2)	#leio o byte no mapa de colisao
li t0, 1
beq t3, t0, bloqueado	#se for = 1 bloqueado

canto2:#(x + largura - 1, y) 
add t1, t4, a3	# x + largura
addi t1, t1, -1	# -1
li t2, 320	# (320 * y) + x
mul t2, t5, t2	
add t2, t2, t1
add t2, t6, t2
lbu t3, 0(t2)
li t0, 1	#leio o byte no mapa
beq t3, t0, bloqueado

canto3:	#(x, y + altura - 1)
add t1, t5, a4
addi t1, t1, -1
li t2, 320	#(320 * y + x)	
mul t2, t2, t1
add t2, t2, t4
add t2, t6, t2
lbu t3, 0(t2)	#leio o byte no mapa
li t0, 1
beq t3, t0, bloqueado

canto4: #(x + largura - 1, y + altura - 1)
add t1, t4, a3	#x + largura
addi t1, t1, -1	# - 1
add t2, t5, a4	# y + altura
addi t2, t2, -1
li t3, 320
mul t3, t3, t2	#320 * y
add t3, t3, t1	# y + x
add t3, t6, t3
lbu t2, 0(t3)	#leio do mapa
li t0, 1
beq t0, t2, bloqueado

li a0, 0	#se todas falharem retorna 0
ret

bloqueado:
li a0, 1	#retorna 1

ret
