# a1 = x 
# a2 = y
# a3 = largura
# a4 = altura
colisao_inimigo:
	addi sp, sp, -4
	sw s1, 0(sp)

	li s1, 0	#contador de inimigos
loop_colisao_inimigo:
	li t4, 4
	bge s1, t4, inimigo_livre	#se passou de 4 inimigos, esta livre

	slli t2, s1, 2		#offset = indice * 4
	la t3, INIMIGO_ATIVO
	add t3, t3, t2
	lw t5, 0(t3)
	beqz t5, proximo_colisao_inimigo	#se inimigo inativo pula

	la t0, INIMIGO_POS
	add t0, t0, t2
	lh t1, 0(t0)	#x do inimigo
	lh t6, 2(t0)	#y do inimigo

	add a7, a1, a3		#player_x + largura
	ble a7, t1, proximo_colisao_inimigo	#se player_x+largura <= inimigo_x, sem colisao no x

	addi a7, t1, 16		#inimigo_x + 16
	bge a1, a7, proximo_colisao_inimigo	#se player_x >= inimigo_x+16, sem colisao no x

	add a7, a2, a4		#player_y + altura
	ble a7, t6, proximo_colisao_inimigo	#se player_y+altura <= inimigo_y, sem colisao no y

	addi a7, t6, 20		#inimigo_y + 20
	bge a2, a7, proximo_colisao_inimigo	#se player_y >= inimigo_y+20, sem colisao no y

	j colidiu_inimigo	#colisao nos dois eixos

proximo_colisao_inimigo:
	addi s1, s1, 1
	j loop_colisao_inimigo

inimigo_livre:
	li a0, 0	#retorna livre
	lw s1, 0(sp)
	addi sp, sp, 4
	ret

colidiu_inimigo:
	#verifica invencibilidade antes de tirar vida
	la t0, PLAYER_INVENCIVEL
	lw t1, 0(t0)
	bnez t1, retorna_bloqueado	#se ainda invencivel, so bloqueia sem tirar vida

	la t0, player_vida
	lw t1, 0(t0)
	beqz t1, retorna_bloqueado	#seguranca, nao deixa negativo

	addi t1, t1, -1
	sw t1, 0(t0)

	la t0, PLAYER_INVENCIVEL
	li t1, 60		#frames de invencibilidade apos tomar dano
	sw t1, 0(t0)

retorna_bloqueado:
	li a0, 1	#retorna bloqueado
	lw s1, 0(sp)
	addi sp, sp, 4
	ret
