mover_inimigos:
	addi sp, sp, -28
	sw s1, 0(sp)
	sw s2, 4(sp)
	sw s3, 8(sp)
	sw s4, 12(sp)
	sw s5, 16(sp)
	sw s6, 20(sp)
	sw s7, 24(sp)
	li s1, 0
loop_mover:
	
	li t1, 4	#maximo de inimigos por spawn
	bge s1, t1, fim_mover
	slli t2, s1, 2
	la t3, INIMIGO_ATIVO	#verifica se o inimigo ainda esta ativo
	add t3, t3, t2
	lw t4, 0(t3)	#se ativo = 0 entao
	beqz t4, proximo_mover	#nao move

	la t0, PLAYER_POS	#le a posicao atual do jogador e guarda
	lh s4, 0(t0)	#x
	lh s5, 2(t0)	#y
	la t0, INIMIGO_POS	#carrega posicao do inimigo
	add t0, t0, t2
	mv s6, t0	#s6 = endereco do inimigo em INIMIGO_POS (sobrevive a call)
	lh t1, 0(t0)	#leio e guardo essas posicoes antigas
	lh t2, 2(t0)
	mv s2, t1
	mv s3, t2

	sub a4, s4, s2	#posicao do player - inimigo
	sub a5, s5, s3
	bge a4, zero, x_ok	#se for maior que > 0 entao x ok
	sub a4, zero, a4	#se for negativo inverte

x_ok:
	bge a5, zero, calcula_maior	#se for maior que > 0 entao y ok
	sub a5, zero, a5	#se for negativo inverte

calcula_maior:
	blt a5, a4, move_x	#se x < y entao eu movo x senao movo y
	j move_y

move_x:
	blt s2, s4, inc_x	#se pos_inimigo_x < pos_player_x entao incrementa
	addi s7, s2, -2		#diminui o x
	j checa_colisao_x

inc_x:
	addi s7, s2, 2	#aumento o x

checa_colisao_x:
	mv a1, s7	#x candidato
	mv a2, s3	#y (mesmo, nao mudou)
	li a3, 16	#largura do inimigo
	li a4, 20	#altura do inimigo

	addi sp, sp, -4
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4

	li t6, 1
	beq a0, t6, salvar_dir_x	#bloqueado: nao move, so direciona

	sh s7, 0(s6)	#salvo o x

salvar_dir_x:
	blt s2, s4, dir_esquerda
	li t4, 2	#esquerda
	j salvar_dir

dir_esquerda:
	li t4, 3	#direita
	j salvar_dir

move_y:
	blt s3, s5, inc_y	#se pos_inimigo_y < pos_player_y entao incrementa
	addi s7, s3, -2		#diminui o y
	j checa_colisao_y

inc_y:
	addi s7, s3, 2	#aumento o y

checa_colisao_y:
	mv a1, s2	#x (mesmo, nao mudou)
	mv a2, s7	#y candidato
	li a3, 16
	li a4, 20

	addi sp, sp, -4
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4

	li t6, 1
	beq a0, t6, salvar_dir_y

	sh s7, 2(s6)	#salvo o y

salvar_dir_y:
	blt s3, s5, dir_frente	#se posicao inimigo for menor que do player
	li t4, 1	#costas = 1
	j salvar_dir

dir_frente:
	li t4, 0	#frente = 0

salvar_dir:
	slli t3, s1, 2	#vejo qual inimigo é
	la t5, INIMIGO_DIR	#carrego a direcao
	add t5, t5, t3	#somo com o inimigo
	sw t4, 0(t5)

proximo_mover:
	addi s1, s1, 1
	j loop_mover

fim_mover:
	lw s1, 0(sp)
	lw s2, 4(sp)
	lw s3, 8(sp)
	lw s4, 12(sp)
	lw s5, 16(sp)
	lw s6, 20(sp)
	lw s7, 24(sp)
	addi sp, sp, 28
	ret	#retorno
