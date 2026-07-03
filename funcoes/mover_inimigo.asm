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
    
la t0, PLAYER_POS	#le a posicao atual do jogador e guarda
lh t5, 0(t0)	#x
lh t6, 2(t0)	#y

la t0, INIMIGO_POS	#carrega posicao do inimigo
add t0, t0, t2
lh t1, 0(t0)	#leio e guardo esses posicoes antigas
lh t2, 2(t0)
mv a0, t1
mv a1, t2

sub a4, t5, a0	#posicao do player - iniimigo
sub a5, t6, a1	

bge a4, zero, x_ok	#se for maior que > 0 entao x ok
sub a4, zero, a4    # se for negativo inverte

x_ok:
bge a5, zero, calcula_maior	#se for maior que > 0 entao y ok
sub a5, zero, a5    # se for negativo inverte

calcula_maior:
blt a5, a4, move_x	#se x < y entao eu movo x senao movo y
j move_y

move_x:
blt t1, t5, inc_x	#se t2 for menor que t6 entao incrementa
addi t1, t1, -1		#diminui o x

j salvar_x
inc_x:
addi t1, t1, 1	#aumento o x
j salvar_x

move_y:
blt t2, t6, inc_y	#se t2 for menor que t6 entao incrementa
addi t2, t2, -1		#diminui o y
j salvar_y

inc_y:
addi t2, t2, 1	#aumento o y
	
salvar_y:
sh t2, 2(t0)	#salvo o y
blt a1, t6, dir_frente	#se posicao inimigo for menor que do player
li t4, 1	#costas = 1
j salvar_dir

dir_frente:
li t4, 0	#frente = 0
j salvar_dir

salvar_x:
sh t1, 0(t0)	#salvo o x
blt a0, t5, dir_esquerda	
li t4, 2	#esquerda
j salvar_dir

dir_esquerda:
li t4, 3	#direita

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
addi sp, sp, 4
ret	#retorno
