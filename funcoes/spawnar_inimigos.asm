spawnar_inimigos:
	li t0, 0	#contador de spawn

loop_spawn:

	li t1, 4	#adiciono o max de inimigos
	bge t0, t1, fim_spawn
	slli t2, t0, 2	

	la t3, INIMIGO_ATIVO	#Armazeno o endereco de inimigo ativo
	add t3, t3, t2
	lw t4, 0(t3)
	bnez t4, proximo_slot      # se jÃ¡ estÃ¡ ativo pula

	la t5, INIMIGO_SPAWN_POS	#Ler a posicao de spawn do inimigo
	add t5, t5, t2
	lh t6, 0(t5)	#leio a posicao x
	lh t4, 2(t5)	#leio a posicao y

	la t5, INIMIGO_POS
	add t5, t5, t2
	sh t6, 0(t5)
	sh t4, 2(t5)

	la t5, INIMIGO_OLD_POS
	add t5, t5, t2
	sh t6, 0(t5)
	sh t4, 2(t5)

	li t6, 1
	sw t6, 0(t3)    # ativa o slot

proximo_slot:
	addi t0, t0, 1
	j loop_spawn


fim_spawn:

	ret


