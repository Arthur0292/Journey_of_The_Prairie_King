#a1 = x
#a2 = y
#a3 = largura
#a4 = altura
colisao_tiro:
	addi sp, sp, -4
	sw s1, 0(sp)
	li s1, 0	#contador

loop_colisao_tiro:
	li t4, 4	
	bge s1, t4, fim_colisao_tiro	#se n inimigo > 4 fim

	slli t2, s1, 2	#acho qual o offset

	la t3, INIMIGO_ATIVO	#carrego o inimigo ativo
	add t3, t3, t2	#somo com o offset
	lw t5, 0(t3)	#se inimigo ativo for = 0 pula para o proximo
	beqz t5, proximo_colisao

	la t0, INIMIGO_POS	#carrego posicao do inimigo
	add t0, t0, t2
	lh t1, 0(t0)	#x do inimigo
	lh t6, 2(t0)	#y do inimigo

	add a7, a1, a3	#se x + largura <= x do inimigo desativa
	ble a7, t1, proximo_colisao

	addi a7, t1, 16	#se x tiro >= inimigo x + 16
	bge a1, a7, proximo_colisao

	add a7, a2, a4	#se tiro y + altura <= inimigo y
	ble a7, t6, proximo_colisao

	addi a7, t6, 20	#se tiro y >= inimigo y + altura
	bge a2, a7, proximo_colisao


desativar_inimigo:

	la t4, INIMIGO_ATIVO	#carrego o inimigo ativo
	add t4, t4, t2	#Adiciono com o offset
	sw zero, 0(t4)	#desativo o inimigo

	la t6, INIMIGO_OLD_POS	#carrego a posicao antiga
	add t6, t6, t2	#sommo com o offset
	lh a1, 0(t6)               # x antigo
	lh a2, 2(t6)               # y antigo
	li a3, 16		#largura e altura do inimigo
	li a4, 20
	li a5, 0                  # frame

	addi sp, sp, -4	#salva o ra e chama o apagar para o frame 0
	sw ra, 0(sp)
	call Apagar
	lw ra, 0(sp)
	addi sp, sp, 4

	li a5, 1                 # frame

	addi sp, sp, -4	#salva o ra e chama o apagar para o frame 1
	sw ra, 0(sp)
	call Apagar
	lw ra, 0(sp)
	addi sp, sp, 4

	la t0, inimigo_kill	#carrego o contador de kills
	lw t3, 0(t0)
	addi t3, t3, 1	#adiciono 1
	sw t3, 0(t0)

proximo_colisao:
	addi s1, s1, 1	#contador++
	j loop_colisao_tiro

fim_colisao_tiro:
	lw s1, 0(sp)
	addi sp, sp, 4
	ret
