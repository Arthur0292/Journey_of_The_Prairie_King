mover_inimigos:
addi sp, sp, -4
sw s1, 0(sp)
li s1, 0
loop_mover:
li t1, 4	#maximo de inimigos por spawn
bge s1, t1, fim_mover
slli t2, s1, 2

la t3, INIMIGO_ATIVO	#verifica se o inimigo ainda esta ativo
add t3, t3, t2
lw t4, 0(t3)	#se ativo = 0 entao
beqz t4, proximo_mover     # nao move 
    
la t0, CHAR_POS	#le a posicao atual do jogador e guarda
lh t5, 0(t0)	#x
lh t6, 2(t0)	#y

la t0, INIMIGO_POS	#carrega posicao do inimigo
add t0, t0, t2
lh t1, 0(t0)	#leio e guardo esses posicoes antigas
lh t2, 2(t0)
mv a0, t1
mv a1, t2

mover_x:
beq t1, t5, mover_y	#se os dois forem iguais
blt t5, t1, mais_x	#se x(inimigo) < x(player)
addi t1, t1, -3
j mover_y

mais_x:
addi t1, t1, 3

mover_y:
beq t2, t6, fim_mover_xy	#se os dois forem iguais
blt t2, t6, mais_y
addi t2, t2, -3
j fim_mover_xy

mais_y:
addi t2, t2, 3

fim_mover_xy:
sh t1 0(t0)	#grava os novos x w y do inimigo
sh t2, 2(t0)



proximo_mover:

fim_mover:

