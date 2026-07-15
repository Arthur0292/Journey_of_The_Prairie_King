desenhar_inimigos:
	addi sp, sp, -8
	sw s1, 0(sp)
	sw s2, 4(sp)
	li s1, 0                  # s1 = i

loop_desenhar:
	li t1, 4
	bge s1, t1, fim_desenhar

	slli s2, s1, 2             #s2 = offset (i * 4)

	la t3, INIMIGO_ATIVO
	add t3, t3, s2
	lw t4, 0(t3)
	beqz t4, proximo_desenhar

	la t5, INIMIGO_OLD_POS
	add t5, t5, s2
	lh a1, 0(t5)               # x antigo
	lh a2, 2(t5)               # y antigo
	li a3, 16		#largura e altura do inimigo
	li a4, 20
	mv a5, s3                  # frame
    
	la t0, INIMIGO_OLD_POS	#checar se a posicao do inimigo mudou ou nao
	add t0, t0, s2
	lh t1, 0(t0)
	lh t2, 2(t0)
    
	la t0, INIMIGO_POS
	add t0, t0, s2
	lh t5, 0(t0)
	lh t6, 2(t0)
    
	bne t1, t5, mudou
	bne t2, t6, mudou
    
	j proximo_desenhar

mudou:

	la t5, INIMIGO_OLD_POS	#carrego o endereco da posicao antiga
	add t5, t5, s2	#somo t5 com offset
	lh a1, 0(t5)	#x
	lh a2, 2(t5)	#y
	li a3, 16	#largura e altura do inimigo
	li a4, 20
	li a5, 0	#frame 0

	addi sp, sp, -4	#salva o ra e chama o apagar para o frame 0
	sw ra, 0(sp)
	call Apagar
	lw ra, 0(sp)
	addi sp, sp, 4

	la t5, INIMIGO_OLD_POS	#carrego o endereco da posicao antiga
	add t5, t5, s2	#somo t5 com offset
	lh a1, 0(t5)	#x
	lh a2, 2(t5)	#y
	li a3, 16
	li a4, 20
	li a5, 1	#frame 1

	addi sp, sp, -4	#salva o ra e chama o apagar para o frame 1
	sw ra, 0(sp)
	call Apagar
	lw ra, 0(sp)
	addi sp, sp, 4

	la t5, INIMIGO_POS	#muda as posicoes antigas e novas
	add t5, t5, s2
	lh t6, 0(t5)               # x atual
	lh t4, 2(t5)               # y atual
	la t5, INIMIGO_OLD_POS #carrego o endereco da pos antiga
	add t5, t5, s2	
	sh t6, 0(t5)
	sh t4, 2(t5)

	#troco as posicoes 
	la t5, INIMIGO_POS
	add t5, t5, s2
	lh a1, 0(t5)               # x
	lh a2, 2(t5)               # y

	slli t3, s1, 2
	la t4, INIMIGO_DIR
	add t4, t4, t3
	lw t3, 0(t4)        # t3 = INIMIGO_DIR[i]
	li t1, 12
	mul t2, t3, t1      # offset = dir * 12

	la t0, inimigo_sprite
	add t0, t0, t2
	lw a0, 0(t0)
	lw a3, 4(t0)
	lw a4, 8(t0)
	li a5, 0

	addi sp, sp, -4	#imprimo no frame 0
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

	la t0, inimigo_sprite
	add t0, t0, t2
	lw a0, 0(t0)
	lw a3, 4(t0)
	lw a4, 8(t0)
	li a5, 1

	addi sp, sp, -4	#imprimo no frame 1
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

proximo_desenhar:
	addi s1, s1, 1
	j loop_desenhar

fim_desenhar:
	lw s1, 0(sp)
	lw s2, 4(sp)
	addi sp, sp, 8
	ret
