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

mover_x:
beq t1, t5, mover_y	#se os dois forem iguais
blt t1, t5, mais_x	#se x(palyer) < x(inimigo)
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
sh t1, 0(t0)	#grava os novos x e y do inimigo
sh t2, 2(t0)
sub a4, t5, a0
sub a5, t6, a1
bge a4, zero, calcula_y	#se a4 for maior que zero pulapara dx
sub a4, zero, a4    # se for negativo inverte

calcula_y:
sub a5, t6, a1      
bge a5, zero, calcula_maior	#se a5 for maior que 0 pula para calula_maior
sub a5, zero, a5    # se for negativo inverte

calcula_maior:
bge a5, a4, y #se y > x
j x	#senao pula para x

y:
blt a1, t6, dir_frente # se y do player era maior que do inimigo = frente
li t4, 1	#costas = 1
j dir	#pula para salvar direcao 

dir_frente:
li t4, 0	#frente = 0
j dir #pula para salvar direcao

x:
blt a0, t5, dir_esquerda # se y do player era maior que do inimigo = direita
li t4, 3	#direita = 3
j dir	#pula para salvar direcao 

dir_esquerda:
li t4, 2	#direita = 3
j dir #pula para salvar direcao

dir:
slli t3, s1, 2
la t5, INIMIGO_DIR 	#carrego o endereco do inimigo
add t5, t5, t3
sw t4, 0(t5)	#salvo a direcao

proximo_mover:
addi s1, s1, 1
j loop_mover

fim_mover:
lw s1, 0(sp)
addi sp, sp, 4
ret	#retorno
