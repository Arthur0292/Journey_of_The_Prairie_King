# a1 = x
# a2 = y
# a3 = largura
# a4 = altura

colisao:

la t0, MAPA_COLISAO_ATUAL	#carrega o endereco do mapa de colisao atual	
lw t6, 0(t0)          

mv t4, a2             # y atual
add t5, a2, a4        # y final

loop_y:

bge t4, t5, livre	

mv t1, a1             # x atual
add t2, a1, a3        # x final

loop_x:

bge t1, t2, proxima_linha

# endereço = mapa + y*320 + x
li t3, 320
mul t0, t4, t3
add t0, t0, t1
add t0, t0, t6

lbu t3, 0(t0)    #leio o byte

li t0, 1
beq t3, t0, bloqueado	#se t3 for = 1 bloqueado

addi t1, t1, 4        # senao próximo x
j loop_x

proxima_linha:

addi t4, t4, 4        # próximo y
j loop_y

livre:
li a0, 0	#retorna 0
ret

bloqueado:
li a0, 1	#retorna 1
ret
