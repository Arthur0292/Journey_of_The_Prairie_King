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
lh t5, 0(t0)
lh t6, 2(t0)

la t0, INIMIGO_POS
add t0, t0, t2




proximo_mover:

fim_mover:

