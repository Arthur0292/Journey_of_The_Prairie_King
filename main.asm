##############################################################
#           Journey of The Prairie King - 2026		     #
#		Trabalho de ISC			             #
#							     #
#	Arthur Vitor Da Silva Nepomuceno - 261027267         #
#	João Pedro Oliveira Ventura dos Santos - 261032445   #
#	Simão de Almeida Silva - 261042325		     #
#							     #			     
##############################################################

.data

#####################
#	Musicas	    #
#####################

###   Musica Menu   ###

#Numero de notas
NUM:
.word 49
NOTAS:
60,1185,55,2073,60,296,60,296,62,296,64,296,65,296,67,2962,67,592,67,395,68,395,71,395,72,3160,72,395,72,395,71,395,68,395,71,790,68,395,67,2370,67,1185,65,592,65,296,67,296,68,2370,67,592,65,592,63,592,63,296,65,296,67,2370,65,592,63,592,62,592,62,296,64,296,66,2370,69,1185,67,592,55,296,55,296,55,592,55,296,55,296,55,592,55,296,55,296,55,592,55,592

MUSICA_NOTA_MENU:
.word 0

###  Musica Game Over  ###
NUM_GAME_OVER:
.word 38
NOTAS_GAME_OVER:
72,2610,76,261,74,261,72,522,79,522,77,261,76,261,77,1044,76,261,74,261,72,2610,76,261,74,261,72,522,83,522,81,261,79,261,77,1044,76,261,74,261,72,2610,76,261,74,261,72,522,79,522,77,261,76,261,77,1044,76,261,74,261,72,2610,76,261,74,261,72,522,83,522,81,261,79,261,77,1566
MUSICA_NOTA_GAME_OVER:
.word 0

###  Musica Game Win ###
NUM_GAME_WIN:
.word 7

NOTAS_GAME_WIN:
64,938,74,234,72,703,65,234,67,234,69,234,67,1172

MUSICA_NOTA_GAME_WIN:
.word 0

nivel:	#fase do jogo
.word 1

cor_fundo:	#cor de fundo do jogo
.word 118

OLD_PLAYER_POS: .half 180, 105	#Definir a posicao do player
PLAYER_POS: .half 180, 105

MAPA_COLISAO_ATUAL: #mapa de colisao atual
.word mapa_colisao1_dados

TIRO_POS: 	#posicoes atuias e antigas do tiro
.half 0, 0	
TIRO_OLD_POS:	
.half 0, 0

INIMIGO_SPAWN_POS: #posicao de sapwn do inimigo
.half 190,10, 296,110, 86,110, 190,200 
INIMIGO_POS: #posicao do inimigo
.half 195,10, 308,124, 86,124, 195,230 
INIMIGO_OLD_POS: 
.half 0,0, 0,0, 0,0, 0,0
INIMIGO_ATIVO: 
.word 0, 0, 0, 0	#Inimigo ativo ou nao
INIMIGO_DIR:
.word 0, 0, 0, 0

inimigo_kill:	#contador de kills para trocar de fase
.word 0

inimigo_sprite:	#label do sprite do inimigo e largura
.word sprite_inimigo_frente, 16, 20
.word sprite_inimigo_costas, 16, 20
.word sprite_inimigo_direita, 16, 20
.word sprite_inimigo_esquerda, 16, 20

MOVE_COUNTER: .word 0
MOVE_INTERVAL: .word 5  #inimigo so move a cada 5 frames

FRAME_COUNTER: 	#contador do tempo de spawn dos inimigos
.word 0
SPAWN_INTERVAL: 
.word 240   #Intervalo de spawner do inimigo

TIRO_DIR: 
.word 0
TIRO_ATIVO: 
.word 0

PLAYER_STATE: 
.word 0	# 0 = frente, 1 = costas, 2 = direita, 3 = esquerda

#vida do jogador
old_player_vida:
.word 3
player_vida: 
.word 3
placar_vida:
.word sprite_um_dados, 25, 25
.word sprite_dois_dados, 25, 25
.word sprite_tres_dados, 25, 25

PLAYER_INVENCIVEL:	#Invencibilidade do player ao encostar no inimigo
.word 0

player_state_sprite:	#definir o sprite do player e largura
.word sprite_frente_dados,   17, 17
.word sprite_costas_dados,   17, 17
.word sprite_direita_dados,  17, 17
.word sprite_esquerda_dados, 17, 17 

.text
main:
	li   t0, 0xFF200604	#Definir o frame inicial do display
	li   t1, 1
	sw   t1, 0(t0)

	#Armazeno posicao atual do jogador
	la t0, PLAYER_POS #Armazena em t0 o endereco do PLAYER_POS
	lh t1, 0(t0)	#Le o (offset 0) e armazena em t1
	lh t2, 2(t0)	#Le o (offset 2) e armazena em t2

	#Armazeno os valores de t1 e t2 na posicao antiga
	la t0, OLD_PLAYER_POS
	sh t1, 0(t0)	
	sh t2, 2(t0)


	la t0, TIRO_POS	#posicao do tiro
	sh t1, 0(t0)	#x
	sh t2, 2(t0)	#y

	la t0, TIRO_OLD_POS	#atualizo a posicao antiga
	sh t1, 0(t0)	#x
	sh t2, 2(t0)	#y

	li s0, 0	#defino o frame inicial para o menu

######################
#	Menu         #
######################

	la a0, MENU_DATA	#Carrega o endereco do menu
	li a1, 0		#carrega em a1 o frame do menu = 0

	addi sp, sp, -4		#salvar o ra e imprimir a imagem na tela
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4

	la a0, MENU_DATA	#Carrega o endereco do menu = 1
	li a1, 1		#carrega em a1 o frame do menu

	addi sp, sp, -4		#sslvar o ra e imprmir a imagem na tela
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4

menu:

	li t0, 0xFF200000	#Carregar em t0 o endereco do teclado
	lw t1, 0(t0)	#Armazenar em t1 o endereco do teclado

	andi t1, t1, 1	#Se for 0 entao and 0 + 0 = 0 mas se for 1 entao and 1 + 1 = 1

	beq t1, zero, tocar_nota_menu		#Se t0 = 0 entao nao apertou nenhuma tecla toc a musica

	lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereco da tecla em t2

	li t3, '1'
	beq t2, t3 , continua	#Se tecla = 1 continua

	li t3, '2'
	bne t2, t3, continua_menu	#Se for tecla 2 pula para o fim do jogo
	
	j fim
	
continua_menu:

##################
# Musica do menu #
##################

tocar_nota_menu:
	la t0, MUSICA_NOTA_MENU	#Carrega nota musica atual	
	lw t1, 0(t0)

	la t2, NOTAS	#Carrega notas
	li t3, 8	#indice	
	mul t4, t1, t3	
	add t2, t2, t4

	lw a0, 0(t2)	#le o valor da nota
	lw a1, 4(t2)	#le a duracao das notas
	li a2, 6	#define o instrumento
	li a3, 120	#define o volume	
	li a7, 31	#define a chamada syscall
	ecall

	mv a0, a1	#passa a duracao da noa para a pausa
	li a7, 32	#define a chamada syscall
	ecall

	addi t1, t1, 1	#incrementa no musica nota atual
	la t5, NUM	
	lw t5, 0(t5)	#le o numero de notas
	blt t1, t5, salvar_indice_menu	#se contador for menor que o numero de notas salva
	li t1, 0	#senao zera o indice

salvar_indice_menu:
	sw t1, 0(t0)	#salva o indice

	j menu	#volta para o menu


continua:

#########################
#	Cenario		#
#########################


	la a0, CENARIO_DATA	#Carrega o endereco do cenario
	li a1, 0		#Carrega em a1 o frame

	addi sp, sp, -4		#salva o ra e imprimi
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4


	la a0, CENARIO_DATA	#Carrega o endereco do cenario
	li a1, 1		#Carrega em a1 o frame

	addi sp, sp, -4		#imprimi o cenario
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4

###########################
#	    HUD		  #
###########################

	la a0, sprite_coracao_dados	#Carrego o endereco do coracao
	li a1, 20
	li a2, 20
	li a3, 30
	li a4, 30
	li a5, 0

	addi sp, sp, -4		#salva o ra e imprimi o cenario
	sw   ra, 0(sp)
	call Print
	lw   ra, 0(sp)
	addi sp, sp, 4

	la t0, player_vida	#carrego o endereco do player_vida
	lw t1, 0(t0)		#achar a posicao da vida
	addi t3, t1, -1
	li t4, 12	
	mul t3, t3, t4

	la t5, placar_vida #carregar o endereco e os dados do sprite da vida
	add t5, t5, t3
	lw a0, 0(t5)
	lw a3, 4(t5)
	lw a4, 8(t5)
	li a1, 23
	li a2, 50

	li a5, 0	#imprimi a vida do player no frame 0
	addi sp, sp, -4
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

	li a5, 1	#imprimi a vida do player no frame 1
	addi sp, sp, -4
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

	#imprimir a coracao no HUD
	la a0, sprite_coracao_dados	#Carrego o endereco do coracao
	li a1, 20	#x e y
	li a2, 20
	li a3, 30	#largura e altura
	li a4, 30
	li a5, 1	#frame

	addi sp, sp, -4		#salva o ra e imprimi
	sw   ra, 0(sp)
	call Print
	lw   ra, 0(sp)
	addi sp, sp, 4

###########################
#	Game Loop	  #
###########################


game_loop:

	xori s3, s0, 1	#Alterna o frame se for 0 vira 1 e se for 1 vira 0

	la t0, FRAME_COUNTER	#verifica contador de frames
	la t1, SPAWN_INTERVAL
	lw t2, 0(t0)
	lw t3, 0(t1)
	addi t2, t2, 1	#adiciona ao contador
	sw t2, 0(t0)

	blt t2, t3, continuar2

	sw zero, 0(t0)

	addi sp, sp, -4	#Salvar o ra para o call de spawnar os inimigos
	sw   ra, 0(sp)
	call spawnar_inimigos
	lw   ra, 0(sp)
	addi sp, sp, 4


continuar2:

#############################################
#	Atualizar posicoes do jogador       #
#############################################

	la t0, OLD_PLAYER_POS	#Carrego em t0 o OLD_PLAYER_POS
	lh a1, 0(t0)		#Coloco em t0 o endereco do offset 0 = x
	lh a2, 2(t0)		#Coloco em t0 o endereco do offset 2 = y
	li a3, 17		#Coloque em a3 a alrgura
	li a4, 17		#Coloco em a4 a altura
	mv a5, s3		#Coloco em a5 o frame de trabalho

	addi sp, sp, -4	#Salvar o ra para o call apagar
	sw   ra, 0(sp)
	call Apagar
	lw   ra, 0(sp)
	addi sp, sp, 4

	la t0, OLD_PLAYER_POS		#Carrega o endereco de old_palyer para t0
	la t1, PLAYER_POS			#carrega o endereco de char para t1
	lh t2, 0(t1)		#Ler o  valor x de t1 
	sh t2, 0(t0)		#Armazena esse valor no old_char
	lh t2, 2(t1)		#Ler o  valor y de t1
	sh t2, 2(t0)		#Armazena esse valor no old_char


	addi sp, sp, -4	#Salvar o ra para o call a tecla
	sw   ra, 0(sp)
	call tecla
	lw   ra, 0(sp)
	addi sp, sp, 4


	#Tiro do player
	#verifico se tiro esta ativo ou nao
	la t0, TIRO_ATIVO
	lw t6, 0(t0)
	beq t6, zero, pula_tiro

	la t0, TIRO_OLD_POS	#carrego a posicao antiga do tiro
	lh a1, 0(t0)		#armazeno em a1 o x
	lh a2, 2(t0)		#armazeno em a2 o y
	mv a5, s3	#Armazeno o frame de trabalho

	addi sp, sp, -4	#Salvar o ra para o call a apagar_tiro
	sw   ra, 0(sp)
	call Apagar_tiro
	lw   ra, 0(sp)
	addi sp, sp, 4

	la t1, TIRO_POS	#carrego a posicao nova do tiro
	la t0, TIRO_OLD_POS	#carrego a posicao antiga 
	#Armazen a posicao nova na antiga
	lh t2, 0(t1)	
	sh t2, 0(t0)	
	lh t2, 2(t1)		
	sh t2, 2(t0)


	la t0, TIRO_DIR	#carrega direcao do tiro
	lw t2, 0(t0)

	beq t2, zero, cima_tiro	#se for 0 = cima

	li t3, 1
	beq t2, t3, baixo_tiro	#se for 1 = baixo

	li t3, 2
	beq t2, t3, direita_tiro	#se for 2 = direita

	j esquerda_tiro	#se nenhuma = esquerda


######################################
#	Movimentacao dos tiros       #
######################################


cima_tiro:

	la t0, TIRO_POS	#carrego o endereco
	lh t1, 2(t0)	#leio o y
	addi t1, t1, -3

	#checar as colisoes
	li a3, 5#largura e altura
	li a4, 5
	mv a2, t1	#movo o y 
	lh a1, 0(t0)	#leio x

	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1	#se retornar = 1 desativa o tiro
	beq a0, t6, desativar_tiro
	la t0, TIRO_POS       # recarrega o endereco
	lh t1, 2(t0)             # rele o y original
	addi t1, t1, -3
	sh t1, 2(t0)		#Guarda a nova posicao no offset 2 = y

	la a0, sprite_tiro_dados
	la t0, TIRO_POS	#carrega o posicao atual do tiro
	lh a1, 0(t0)    # x
	lh a2, 2(t0)    # y
	mv a3, s3       # frame

	addi sp, sp, -4	#salva o ra e chama o print
	sw   ra, 0(sp)
	call Print_tiro
	lw   ra, 0(sp)
	addi sp, sp, 4

	j pula_tiro

baixo_tiro:

	la t0, TIRO_POS	#carrego a posicao
	lh t1, 2(t0)	#leio o y
	addi t1, t1, 3	#adiciono

	#checar as colisoes
	li a3, 5#largura e altura
	li a4, 5
	mv a2, t1	#movo o y 
	lh a1, 0(t0)	#leio x

	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	li t6, 1

	beq a0, t6, desativar_tiro
	la t0, TIRO_POS       # recarrega o endereco
	lh t1, 2(t0)             # rele o y original
	addi t1, t1, 3
	sh t1, 2(t0)		#Guarda a nova posicao no offset 2 = y

	la a0, sprite_tiro_dados

	la t0, TIRO_POS	#carrega o posicao atual do tiro
	lh a1, 0(t0)    # x
	lh a2, 2(t0)    # y
	mv a3, s3       # frame

	addi sp, sp, -4	#salva o ra e chama o print
	sw   ra, 0(sp)
	call Print_tiro
	lw   ra, 0(sp)
	addi sp, sp, 4

	j pula_tiro

direita_tiro:

	la t0, TIRO_POS	#carrego a posicao
	lh t1, 0(t0)	#leio o x
	addi t1, t1, 3	#adiciono

	#checar as colisoes
	li a3, 5#largura e altura
	li a4, 5
	lh a2, 2(t0)	# y 
	mv a1, t1	#movo o x

	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1	#se retornar = 1 desativo
	beq a0, t6, desativar_tiro
	
	la t0, TIRO_POS       # recarrega o endereco
	lh t1, 0(t0)             # rele o y original
	addi t1, t1, 3
	sh t1, 0(t0)		#Guarda a nova posicao no offset 0 = x

	la a0, sprite_tiro_dados

	la t0, TIRO_POS	#carrega o posicao atual do tiro
	lh a1, 0(t0)    # x
	lh a2, 2(t0)    # y
	mv a3, s3       # frame

	addi sp, sp, -4	#salva o ra e chama o print
	sw   ra, 0(sp)
	call Print_tiro
	lw   ra, 0(sp)
	addi sp, sp, 4

	j pula_tiro

esquerda_tiro:

	la t0, TIRO_POS	#carrego a posicao
	lh t1, 0(t0)	#leio o x
	addi t1, t1, -3	#adiciono

	#checar as colisoes
	li a3, 5#largura e altura
	li a4, 5
	lh t2, 2(t0)	# y 
	mv a1, t1	#movo o x

	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1	#se retorna = 1 desativo
	beq a0, t6, desativar_tiro

	la t0, TIRO_POS       # recarrega o endereco
	lh t1, 0(t0)             # rele o y original
	addi t1, t1, -3
	sh t1, 0(t0)		#Guarda a nova posicao no offset 0 = x

	la a0, sprite_tiro_dados

	la t0, TIRO_POS	#carrega o posicao atual do tiro
	lh a1, 0(t0)    # x
	lh a2, 2(t0)    # y
	mv a3, s3       # frame

	addi sp, sp, -4	#salva o ra e chama o print
	sw   ra, 0(sp)
	call Print_tiro
	lw   ra, 0(sp)
	addi sp, sp, 4

	j pula_tiro


pula_tiro:

	la t0, player_vida	#verifico se a vida é igual a 0
	lw t1, 0(t0)
	beqz t1, game_over	#se for pula para o gamer over

	la t0, nivel	#verifico qual o nivel para o contador de kills
	lw t2, 0(t0)
	li t1, 1
	beq t2, t1, nivel_1
	
	la t0, nivel	#verifico qual o nivel para o contador de kills
	lw t2, 0(t0)
	li t1, 2
	beq t2, t1, nivel_2
	
	la t0, nivel	#verifico qual o nivel para o contador de kills
	lw t2, 0(t0)
	li t1, 3
	beq t2, t1, nivel_3

#############################################
#	Contador de kills de cada fase      #
#############################################

nivel_2:
	la t0, inimigo_kill	#verifico se o contador de kill >= 8
	li t2, 8
	lw t1, 0(t0)
	bge t1, t2, fase3	#se for verdadeiro pula para game win
	j continuar3	#se nao continua

nivel_1:

	la t0, inimigo_kill	#verifico se o contador de kill >= 8
	li t2, 8
	lw t1, 0(t0)
	bge t1, t2, fase2	#se for verdadeiro pula para fase 2
	j continuar3
	
nivel_3:

	la t0, inimigo_kill	#verifico se o contador de kill >= 8
	li t2, 8
	lw t1, 0(t0)
	bge t1, t2, game_win	#se for verdadeiro pula para fase 2

continuar3:

	addi sp, sp, -4	#chamo a funcao de imprimir a vida do player
	sw ra, 0(sp)
	call desenhar_vida
	lw ra, 0(sp)
	addi sp, sp, 4

	#contador de movimento
	la t0, MOVE_COUNTER
	la t1, MOVE_INTERVAL
	lw t2, 0(t0)
	lw t3, 0(t1)
	addi t2, t2, 1
	sw t2, 0(t0)
	blt t2, t3, pula_mover

	sw zero, 0(t0)	#chama o mover inimigos
	addi sp, sp, -4
	sw ra, 0(sp)
	call mover_inimigos
	lw ra, 0(sp)
	addi sp, sp, 4

pula_mover:

	#decrementa invencibilidade
	la t0, PLAYER_INVENCIVEL
	lw t1, 0(t0)
	beqz t1, pula_decremento
	addi t1, t1, -1
	sw t1, 0(t0)

pula_decremento:

	#checa colisao do player parado com os inimigos (causa dano se encostado)
	la t0, PLAYER_POS
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 17
	li a4, 17

	addi sp, sp, -4
	sw ra, 0(sp)
	call colisao_inimigo
	lw ra, 0(sp)
	addi sp, sp, 4

	addi sp, sp, -4	#chamo a funcao de desenhar os inimigos
	sw   ra, 0(sp)
	call desenhar_inimigos
	lw   ra, 0(sp)
	addi sp, sp, 4

	#Ler o status atual do player
	lw t2 , PLAYER_STATE	#Le o status do player atual e aramzzena em t2
	li t3, 12	#Variavel 12
	mul t4, t3, t2	#Multiplica o status por 12

	#De acordo com status selecione o frame a ser carregado armazenado o offset 0, 4, 8
	la t0, player_state_sprite	#Carrega em t0 o endereco de player_state_sprite
	add t0, t0, t4
	lw a0, 0(t0)		#Armazena em a0 o sprite
	lw a3, 4(t0)		#Armazena em a3 a largura
	lw a4, 8(t0)		#Armazena em a4 a altura

	#Funcao para printar o player na tela
	la t0, PLAYER_POS
	lh a1, 0(t0)	#Armazeno em a1 o x
	lh a2, 2(t0)	#Armazeno em a2 o y
	mv a5, s3

	addi sp, sp, -4	#Salvar o ra para o call a print
	sw   ra, 0(sp)
	call Print
	lw   ra, 0(sp)
	addi sp, sp, 4

	#Alterna entre os frames 0 e 1 
	li   t0, 0xFF200604		#Endereco base
	sw   s3, 0(t0)		#Leio o endereco e aramzeno em s3
	mv   s0, s3		#Movo para s0 oque esta em s3 para alterna o frame no xori

	j game_loop

###################################
#	Logica do teclado	  #
###################################

tecla:

	li t0, 0xFF200000	#Carregar em t0 o endereco do teclado
	lw t1, 0(t0)	#Aramzenar em t1 o endereco do teclado

	andi t1, t1, 1	#Se for 0 entao and 0 + 0 = 0 mas se for 1 entao and 1 + 1 = 1

	beq t1, zero, tecla_fim		#Se t0 = 0 entao nao apertou nenhuma tecla e pula

	lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereco da tecla em t2

	li t5, 'i'	#Se tecla for i pra cima pula para tiro_cima
	beq t2, t5, tiro_cima

	li t5, 'k'	#se tecla for k pula para tiro_baixo
	beq t2, t5, tiro_baixo

	li t5, 'j'	#se tecla for j pula para tiro_esquerda
	beq t2, t5, tiro_esquerda

	li t5, 'l'	#se tecla for l pula pra tiro_direita
	beq t2, t5,tiro_direita


	li t3, 'w'
	beq t2, t3 , mover_cima		#Se tecla = w pula para mover cima

	li t3, 'a'
	beq t2, t3 , mover_esquerda	#Se tecla = a pula para mover esquerda

	li t3, 's'
	beq t2, t3 , mover_baixo	#Se tecla = s pula para mover baixo

	li t3, 'd'
	beq t2, t3 , mover_direita	#Se tecla = d pula para mover direita

	li t3, 'n'
	beq t2, t3 , troca_fase	#Se tecla = n pula de fase

	ret			#Retorna para a funcao game_loop

####################################
#	Movimentacao do player     #
####################################

mover_cima:

	la t0, PLAYER_POS		#Pegando o endereco da posicao do jogador
	lh t1, 2(t0)		#ler da memoria o offset 2 = y
	addi t1, t1, -8		#Subtrai -8  pixels

	#checar as colisoes
	li a3, 17	#largura e altura
	li a4, 17
	mv a2, t1	#movo o y 
	lh a1, 0(t0)	#leio x
	
	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1	#se retorna = 1 pula para tecla_fim
	beq a0, t6, tecla_fim
	
	#checa colisao com inimigo
	la t0, PLAYER_POS
	lh t1, 2(t0)
	addi t1, t1, -8	
	li a3, 17
	li a4, 17
	mv a2, t1
	lh a1, 0(t0)

	addi sp, sp, -4		#salva o ra e chama a colisao
	sw ra, 0(sp)
	call colisao_inimigo
	lw ra, 0(sp)
	addi sp, sp, 4

	li t6, 1
	beq a0, t6, tecla_fim	#se colidiu com inimigo nao move

	la t0, PLAYER_POS       # recarrega o endereco
	lh t1, 2(t0)             # rele o y original
	addi t1, t1, -8
	sh t1, 2(t0)		#Guarda a nova posicao no offset 2 = y

	la t0, PLAYER_STATE	#Pegando o endereco do status do player
	li t1, 1		#Guarda em t1 o valor 1
	sw t1, 0(t0)		#Muda o valor do player state

	ret

mover_esquerda:

	la t0, PLAYER_POS		#Pegando o endereco da posicao do jogador
	lh t1, 0(t0)		#ler da memoria o offset 0 = x
	addi t1, t1, -8		#Mudar o x

	#checo as colisoes
	li a3, 17	#largura e altura
	li a4, 17
	mv a1, t1	#x
	lh a2, 2(t0)	#y
	
	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1	#se retorna = 1 pula pra tecla_fim
	beq a0, t6, tecla_fim
	
	la t0, PLAYER_POS		#Pegando o endereco da posicao do jogador
	lh t1, 0(t0)		#ler da memoria o offset 0 = x
	addi t1, t1, -8		#Mudar o x

	#checo as colisoes com o inimigo
	li a3, 17	#largura e altura
	li a4, 17
	mv a1, t1	#x
	lh a2, 2(t0)	#y
	
	addi sp, sp, -4		#salva o ra e chama a colisao
	sw ra, 0(sp)
	call colisao_inimigo
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1
	beq a0, t6, tecla_fim	#se colidiu com inimigo nao move

	la t0, PLAYER_POS       # recarrega o endereco
	lh t1, 0(t0)             # rele o y original
	addi t1, t1, -8
	sh t1, 0(t0)		#Guarda a nova posicao no offset 0 = x

	la t0, PLAYER_STATE	#muda o status do player para direcao	
	li t1, 3
	sw t1, 0(t0)

	ret

mover_baixo:

	la t0, PLAYER_POS		#Pegando o endereco da posicao do jogador
	lh t1, 2(t0)		#ler da memoria o offset 2 = y
	addi t1, t1, 8		#Soma 8

	#checo as colisoes
	li a3, 17	#largura e altura
	li a4, 17
	mv a2, t1	#movo o y 
	lh a1, 0(t0)	#leio x
	

	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1	#se retorna = 1 pula pra tecla _fim
	beq a0, t6, tecla_fim
	
	la t0, PLAYER_POS		#Pegando o endereco da posicao do jogador
	lh t1, 2(t0)		#ler da memoria o offset 2 = y
	addi t1, t1, 8		#Soma 8

	#checo as colisoes com inimigo
	li a3, 17	#largura e altura
	li a4, 17
	mv a2, t1	#movo o y 
	lh a1, 0(t0)	#leio x
	
	addi sp, sp, -4		#salva o ra e chama a colisao
	sw ra, 0(sp)
	call colisao_inimigo
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1
	beq a0, t6, tecla_fim	#se colidiu com inimigo nao move

	la t0, PLAYER_POS       # recarrega o endereco
	lh t1, 2(t0)             # rele o y original
	addi t1, t1, 8
	sh t1, 2(t0)		#Guarda a nova posicao no offset 2 = y

	la t0, PLAYER_STATE	#muda o status do player para direcao
	li t1, 0
	sw t1, 0(t0)

	ret	#retorna


mover_direita:

	la t0, PLAYER_POS		#Pegando o endereco da posicao do jogador
	lh t1, 0(t0)		#ler da memoria o offset 0 = x
	addi t1, t1, 8		#Soma 8

	#checo as colisoes
	li a3, 17	#largura e altura
	li a4, 17
	mv a1, t1	#x
	lh a2, 2(t0)	#y
	
	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1	#se retorna = 1 pula pra tecla_fim
	beq a0, t6, tecla_fim
	
	la t0, PLAYER_POS		#Pegando o endereco da posicao do jogador
	lh t1, 0(t0)		#ler da memoria o offset 0 = x
	addi t1, t1, 8		#Soma 8

	#checo as colisoes com inimigo
	li a3, 17	#largura e altura
	li a4, 17
	mv a1, t1	#x
	lh a2, 2(t0)	#y
	
	addi sp, sp, -4		#salva o ra e chama a colisao
	sw ra, 0(sp)
	call colisao_inimigo
	lw ra, 0(sp)
	addi sp, sp, 4
	
	li t6, 1
	beq a0, t6, tecla_fim	#se colidiu com inimigo nao move

	la t0, PLAYER_POS       # recarrega o endereco
	lh t1, 0(t0)             # rele o y original
	addi t1, t1, 8
	sh t1, 0(t0)		#Guarda a nova posicao no offset 0 = x

	la t0, PLAYER_STATE	#muda o status do player para direcao
	li t1, 2
	sw t1, 0(t0)

	ret

#########################################
#	Direcao e posicao do tiro 	#
#########################################
tiro_cima:

	la t0, PLAYER_POS	#Pegar a posicao atual do jogador
	lh t1, 0(t0)	#pegar o x
	lh t2, 2(t0)	#pegar o y

	la t0, TIRO_POS		#troca de acordo com a posicao do player o x e y
	sh t1, 0(t0)
	sh t2, 2(t0)

	la t0, TIRO_DIR	#defino a posicao do tiro
	li t1, 0
	sw t1, 0(t0)

	la t0, TIRO_ATIVO	#defino se o tiro esta ativo
	li t1, 1
	sw t1, 0(t0)

	#Verifico a colisao com o inimigo
	la t0, TIRO_POS
	lh a1, 0(t0)	#x
	lh a2, 2(t0)	#y
	li a3, 5
	li a4, 5
	
	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao_tiro
	lw ra, 0(sp)
	addi sp, sp, 4

	#efeito sonoro do tiro
	li a0, 60      # pitch
	li a1, 100     # duracao em ms
	li a2, 127     # instrumento = gunshot
	li a3, 127     # volume
	li a7, 31      # MidiOut
	ecall

	j tecla_fim

tiro_baixo:

	la t0, PLAYER_POS	#Pegar a posicao atual do jogador
	lh t1, 0(t0)	#pegar o x
	lh t2, 2(t0)	#pegar o y

	la t0, TIRO_POS		#troca de acordo com a posicao do player o x e y
	sh t1, 0(t0)
	sh t2, 2(t0)

	la t0, TIRO_DIR	#defino a posicao do tiro
	li t1, 1
	sw t1, 0(t0)

	la t0, TIRO_ATIVO	#defino se o tiro esta ativo
	li t1, 1
	sw t1, 0(t0)

	#Verifico a colisao com o inimigo
	la t0, TIRO_POS
	lh a1, 0(t0)	#x
	lh a2, 2(t0)	#y
	li a3, 5
	li a4, 5
	
	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao_tiro
	lw ra, 0(sp)
	addi sp, sp, 4

	#efeito sonoro do tiro
	li a0, 60      # pitch
	li a1, 100     # duracao em ms
	li a2, 127     # instrumento = gunshot
	li a3, 127     # volume
	li a7, 31      # MidiOut
	ecall

	j tecla_fim

tiro_direita:

	la t0, PLAYER_POS	#Pegar a posicao atual do jogador
	lh t1, 0(t0)	#pegar o x
	lh t2, 2(t0)	#pegar o y

	la t0, TIRO_POS		#troca de acordo com a posicao do player o x e y
	sh t1, 0(t0)
	sh t2, 2(t0)

	la t0, TIRO_DIR	#defino a posicao do tiro
	li t1, 2
	sw t1, 0(t0)

	la t0, TIRO_ATIVO	#defino se o tiro esta ativo
	li t1, 1
	sw t1, 0(t0)

	#Verifico a colisao com o inimigo
	la t0, TIRO_POS
	lh a1, 0(t0)	#x
	lh a2, 2(t0)	#y
	li a3, 5
	li a4, 5
	
	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao_tiro
	lw ra, 0(sp)
	addi sp, sp, 4

	#efeito sonoro do tiro
	li a0, 60      # pitch
	li a1, 100     # duracao em ms
	li a2, 127     # instrumento = gunshot
	li a3, 127     # volume
	li a7, 31      # MidiOut
	ecall

	j tecla_fim

tiro_esquerda:

	la t0, PLAYER_POS	#Pegar a posicao atual do jogador
	lh t1, 0(t0)	#pegar o x
	lh t2, 2(t0)	#pegar o y

	la t0, TIRO_POS		#troca de acordo com a posicao do player o x e y
	sh t1, 0(t0)
	sh t2, 2(t0)

	la t0, TIRO_DIR	#defino a posicao do tiro
	li t1, 3
	sw t1, 0(t0)

	la t0, TIRO_ATIVO	#defino se o tiro esta ativo
	li t1, 1
	sw t1, 0(t0)

	#Verifico a colisao com o inimigo
	la t0, TIRO_POS
	lh a1, 0(t0)	#x
	lh a2, 2(t0)	#y
	li a3, 5
	li a4, 5
	
	addi sp, sp, -4	#salvo o ra e checo as colisoes
	sw ra, 0(sp)
	call colisao_tiro
	lw ra, 0(sp)
	addi sp, sp, 4

	#efeito sonoro do tiro
	li a0, 60      # pitch
	li a1, 100     # duracao em ms
	li a2, 127    # instrumento = gunshot
	li a3, 120     # volume
	li a7, 31      # MidiOut
	ecall

	j tecla_fim

tecla_fim:

	ret	#Retorna para o game_loop

desativar_tiro:

	la t0, TIRO_ATIVO	#muda o status do tiro
	sw zero, 0(t0)
    
	# apaga no frame 0
	la t0, TIRO_POS
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a5, 0
	call Apagar_tiro
    
	# apaga no frame 1
	li a5, 1
	call Apagar_tiro
	j pula_tiro	#pula para pula_tiro


troca_fase:

	#verifico em qual fase esta
	la t0, nivel
	lw t2, 0(t0)
	li t1, 1	#se for = 1 troca pra fase 2
	beq t1, t2, fase2
	li t1, 2
	beq t1, t2, fase3	

#############################
#          FASE 1         #
#############################

fase1:

	la t0, OLD_PLAYER_POS	#mudo para a posicao de spawn do old pos
	li t1, 180	#x
	sh t1, 0(t0)
	li t1, 105	#y
	sh t1, 2(t0)

	la t0, PLAYER_POS	#mudo para a posicao de spawn do player pos
	li t1, 180	#x
	sh t1, 0(t0)
	li t1, 105	#y
	sh t1, 2(t0)

	la t0, MAPA_COLISAO_ATUAL	#carrego mapa atual e mudo
	la t1, mapa_colisao1_dados
	sw t1, 0(t0)

	la t0, cor_fundo	#mudo a cor de fundo
	li t6, 118
	sw t6, 0(t0)	#salvo a cor

	la t0, nivel	#mudo o nivel
	li t1, 1
	sw t1, 0(t0)

	la t0, FRAME_COUNTER	#zero o frame_counter
	sw zero, 0(t0)

	addi sp, sp, -4	#chamo a funcao de apagar os inimigos
	sw ra, 0(sp)
	call tirar_inimigos
	lw ra, 0(sp)
	addi sp, sp, 4

	la t0, inimigo_kill	#zero o contador de kills na fase 1
	li t1, 0
	sw t1, 0(t0)

	la t0, player_state_sprite	#carrego os sprites do player
	la t1, sprite_frente_dados	#troco o sprite da frente
	sw t1, 0(t0)	#salvo o novo sprite
	la t1, sprite_costas_dados
	sw t1, 12(t0)	
	la t1, sprite_direita_dados
	sw t1, 24(t0)	
	la t1, sprite_esquerda_dados
	sw t1, 36(t0)	

	la t0, inimigo_sprite	#carrego os sprites do inimigo
	la t1, sprite_inimigo_frente	#troco o sprite da frente
	sw t1, 0(t0)	#salvo o novo sprite
	la t1, sprite_inimigo_costas
	sw t1, 12(t0)	
	la t1, sprite_inimigo_direita
	sw t1, 24(t0)	
	la t1, sprite_inimigo_esquerda
	sw t1, 36(t0)	

	j continua

#############################
#          FASE 2           #
#############################

fase2:

	la t0, OLD_PLAYER_POS	#mudo para a posicao de spawn do old pos
	li t1, 180	#x
	sh t1, 0(t0)
	li t1, 105	#y
	sh t1, 2(t0)

	la t0, PLAYER_POS	#mudo para a posicao de spawn do player pos
	li t1, 180	#x
	sh t1, 0(t0)
	li t1, 105	#y
	sh t1, 2(t0)

	la t0, MAPA_COLISAO_ATUAL	#carrego mapa atual e mudo
	la t1, mapa_colisao2_dados	
	sw t1, 0(t0)

	la t0, cor_fundo	#mudo a cor de fundo
	li t6, 255
	sw t6, 0(t0)	#salvo a cor branca do fundo

	la t0, nivel	#mudo o nivel
	li t1, 2
	sw t1, 0(t0)

	la t0, FRAME_COUNTER	#zero o frame_counter
	sw zero, 0(t0)

	addi sp, sp, -4	#chamo a funcao de apagar os inimigos
	sw ra, 0(sp)
	call tirar_inimigos
	lw ra, 0(sp)
	addi sp, sp, 4

	la t0, inimigo_kill	#zero o contador de kills na fase 2
	li t1, 0
	sw t1, 0(t0)

	la t0, player_state_sprite	#carrego os sprites do player
	la t1, sprite_frente_dados_2	#troco o sprite da frente
	sw t1, 0(t0)	#salvo o novo sprite
	la t1, sprite_costas_dados_2
	sw t1, 12(t0)	
	la t1, sprite_direita_dados_2
	sw t1, 24(t0)	
	la t1, sprite_esquerda_dados_2
	sw t1, 36(t0)	

	la t0, inimigo_sprite	#carrego os sprites do inimigo
	la t1, sprite_inimigo_frente_2	#troco o sprite da frente
	sw t1, 0(t0)	#salvo o novo sprite
	la t1, sprite_inimigo_costas_2
	sw t1, 12(t0)	
	la t1, sprite_inimigo_direita_2
	sw t1, 24(t0)	
	la t1, sprite_inimigo_esquerda_2
	sw t1, 36(t0)	

	la a0, CENARIO_2_DATA	#carrego o cenario 2
	li a1, 0	#frame
	
	addi sp, sp, -4	#salvo o ra e imprimo
	sw ra, 0(sp)
	call print_imagem
	lw ra, 0(sp)
	addi sp, sp, 4

	li a1, 1
	
	addi sp, sp, -4	#salvo o ra e imprimo
	sw ra, 0(sp)
	call print_imagem
	lw ra, 0(sp)
	addi sp, sp, 4


	la a0, sprite_coracao_dados	#Carrego o endereco do coracao
	li a1, 20
	li a2, 20
	li a3, 30
	li a4, 30
	li a5, 0

	addi sp, sp, -4		#salva o ra e imprimi
	sw   ra, 0(sp)
	call Print
	lw   ra, 0(sp)
	addi sp, sp, 4

	la t0, player_vida	#carrego o endereco do player_vida
	lw t1, 0(t0)		#achar a posicao da vida
	addi t3, t1, -1
	li t4, 12	
	mul t3, t3, t4

	la t5, placar_vida #carregar o endereco e os dados do sprite da vida
	add t5, t5, t3
	lw a0, 0(t5)
	lw a3, 4(t5)
	lw a4, 8(t5)
	li a1, 23
	li a2, 50

	li a5, 0	#imprimi a vida do player no frame 0
	addi sp, sp, -4
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

	li a5, 1	#imprimi a vida do player no frame 1
	
	addi sp, sp, -4
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

	#imprimir a coracao no HUD
	la a0, sprite_coracao_dados	#Carrego o endereco do coracao
	li a1, 20	#x e y
	li a2, 20
	li a3, 30	#largura e altura
	li a4, 30
	li a5, 1	#frame

	addi sp, sp, -4		#salva o ra e imprimi
	sw   ra, 0(sp)
	call Print
	lw   ra, 0(sp)
	addi sp, sp, 4

	j continuar3
	
	
#############################
#          FASE 3           #
#############################

fase3:

	la t0, OLD_PLAYER_POS	#mudo para a posicao de spawn do old pos
	li t1, 180	#x
	sh t1, 0(t0)
	li t1, 105	#y
	sh t1, 2(t0)

	la t0, PLAYER_POS	#mudo para a posicao de spawn do player pos
	li t1, 180	#x
	sh t1, 0(t0)
	li t1, 105	#y
	sh t1, 2(t0)

	la t0, MAPA_COLISAO_ATUAL	#carrego mapa atual e mudo
	la t1, mapa_colisao3_dados	
	sw t1, 0(t0)

	la t0, cor_fundo	#mudo a cor de fundo
	li t6, 108
	sw t6, 0(t0)	#salvo a cor branca do fundo

	la t0, nivel	#mudo o nivel
	li t1, 3
	sw t1, 0(t0)

	la t0, FRAME_COUNTER	#zero o frame_counter
	sw zero, 0(t0)

	addi sp, sp, -4	#chamo a funcao de apagar os inimigos
	sw ra, 0(sp)
	call tirar_inimigos
	lw ra, 0(sp)
	addi sp, sp, 4

	la t0, inimigo_kill	#zero o contador de kills na fase 2
	li t1, 0
	sw t1, 0(t0)

	la t0, player_state_sprite	#carrego os sprites do player
	la t1, sprite_frente_dados_3	#troco o sprite da frente
	sw t1, 0(t0)	#salvo o novo sprite
	la t1, sprite_costas_dados_3
	sw t1, 12(t0)	
	la t1, sprite_direita_dados_3
	sw t1, 24(t0)	
	la t1, sprite_esquerda_dados_3
	sw t1, 36(t0)	

	la t0, inimigo_sprite	#carrego os sprites do inimigo
	la t1, sprite_inimigo_frente_3	#troco o sprite da frente
	sw t1, 0(t0)	#salvo o novo sprite
	la t1, sprite_inimigo_costas_3
	sw t1, 12(t0)	
	la t1, sprite_inimigo_direita_3
	sw t1, 24(t0)	
	la t1, sprite_inimigo_esquerda_3
	sw t1, 36(t0)	

	la a0, CENARIO_3_DATA	#carrego o cenario 2
	li a1, 0	#frame
	
	addi sp, sp, -4	#salvo o ra e imprimo
	sw ra, 0(sp)
	call print_imagem
	lw ra, 0(sp)
	addi sp, sp, 4

	li a1, 1
	
	addi sp, sp, -4	#salvo o ra e imprimo
	sw ra, 0(sp)
	call print_imagem
	lw ra, 0(sp)
	addi sp, sp, 4

	la a0, sprite_coracao_dados	#Carrego o endereco do coracao
	li a1, 20
	li a2, 20
	li a3, 30
	li a4, 30
	li a5, 0

	addi sp, sp, -4		#salva o ra e imprimi
	sw   ra, 0(sp)
	call Print
	lw   ra, 0(sp)
	addi sp, sp, 4

	la t0, player_vida	#carrego o endereco do player_vida
	lw t1, 0(t0)		#achar a posicao da vida
	addi t3, t1, -1
	li t4, 12	
	mul t3, t3, t4

	la t5, placar_vida #carregar o endereco e os dados do sprite da vida
	add t5, t5, t3
	lw a0, 0(t5)
	lw a3, 4(t5)
	lw a4, 8(t5)
	li a1, 23
	li a2, 50

	li a5, 0	#imprimi a vida do player no frame 0
	addi sp, sp, -4
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

	li a5, 1	#imprimi a vida do player no frame 1
	
	addi sp, sp, -4
	sw ra, 0(sp)
	call Print
	lw ra, 0(sp)
	addi sp, sp, 4

	#imprimir a coracao no HUD
	la a0, sprite_coracao_dados	#Carrego o endereco do coracao
	li a1, 20	#x e y
	li a2, 20
	li a3, 30	#largura e altura
	li a4, 30
	li a5, 1	#frame

	addi sp, sp, -4		#salva o ra e imprimi
	sw   ra, 0(sp)
	call Print
	lw   ra, 0(sp)
	addi sp, sp, 4

	j continuar3

##############################
#	 Game win	     #
############################## 

game_win:

	la t0, cor_fundo	#mudo a cor de fundo
	li t6, 0
	sw t6, 0(t0)	#salvo a cor do fundo

	addi sp, sp, -4	#chamo a funcao de apagar os inimigos
	sw ra, 0(sp)
	call tirar_inimigos
	lw ra, 0(sp)
	addi sp, sp, 4

	la a0, GAME_WIN_DATA #carrega o game_over
	li a1, 0	#frame 0

	addi sp, sp, -4	#Salvar o ra para o call a print_imagem
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4

	li a1, 1	#frame 1

	addi sp, sp, -4	#Salvar o ra para o call a print_imagem
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4

game_win_tecla:

	li t0, 0xFF200000	#Carregar em t0 o endereco do teclado
	lw t1, 0(t0)	#Armazenar em t1 o endereco do teclado

	andi t1, t1, 1	#Se for 0 entao and 0 + 0 = 0 mas se for 1 entao and 1 + 1 = 1

	beq t1, zero, tocar_nota_game_over	#Se t0 = 0 entao nao apertou nenhuma tecla toc a musica

	lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereco da tecla em t2

	li t3, '2'
	beq t2, t3, fim		#Se for tecla 2 pula para o fim do jogo

tocar_nota_game_win:

	la t0, MUSICA_NOTA_GAME_WIN #Carrega nota musica atual	
	lw t1, 0(t0)

	la t2, NOTAS_GAME_WIN	#Carrega notas
	li t3, 8	#indice	
	mul t4, t1, t3	
	add t2, t2, t4

	lw a0, 0(t2)	#le o valor da nota
	lw a1, 4(t2)	#le a duracao das notas
	li a2, 1	#define o instrumento
	li a3, 120	#define o volume	
	li a7, 31	#define a chamada syscall
	ecall

	mv a0, a1	#passa a duracao da noa para a pausa
	li a7, 32	#define a chamada syscall
	ecall

	addi t1, t1, 1	#incrementa no musica nota atual
	la t5, NUM_GAME_WIN	
	lw t5, 0(t5)	#le o numero de notas
	blt t1, t5, salvar_indice_game_win	#se contador for menor que o numero de notas salva
	li t1, 0	#senao zera o indice

salvar_indice_game_win:

	sw t1, 0(t0)	#salva o indice
	j game_win_tecla	#volta para o musica

##############################
#	 Game over	     #
############################## 

game_over:

	la t0, cor_fundo	#mudo a cor de fundo
	li t6, 0
	sw t6, 0(t0)	#salvo a cor do fundo

	addi sp, sp, -4	#chamo a funcao de apagar os inimigos
	sw ra, 0(sp)
	call tirar_inimigos
	lw ra, 0(sp)
	addi sp, sp, 4

	la a0, GAME_OVER_DATA #carrega o game_over
	li a1, 0	#frame 0

	addi sp, sp, -4	#Salvar o ra para o call a print_imagem
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4

	li a1, 1	#frame 1

	addi sp, sp, -4	#Salvar o ra para o call a print_imagem
	sw   ra, 0(sp)
	call print_imagem
	lw   ra, 0(sp)
	addi sp, sp, 4

game_over_tecla:

	li t0, 0xFF200000	#Carregar em t0 o endereco do teclado
	lw t1, 0(t0)	#Armazenar em t1 o endereco do teclado

	andi t1, t1, 1	#Se for 0 entao and 0 + 0 = 0 mas se for 1 entao and 1 + 1 = 1

	beq t1, zero, tocar_nota_game_over	#Se t0 = 0 entao nao apertou nenhuma tecla toc a musica

	lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereco da tecla em t2

	li t3, '2'
	beq t2, t3, fim		#Se for tecla 2 pula para o fim do jogo

tocar_nota_game_over:

	la t0, MUSICA_NOTA_GAME_OVER #Carrega nota musica atual	
	lw t1, 0(t0)

	la t2, NOTAS_GAME_OVER	#Carrega notas
	li t3, 8	#indice	
	mul t4, t1, t3	
	add t2, t2, t4

	lw a0, 0(t2)	#le o valor da nota
	lw a1, 4(t2)	#le a duracao das notas
	li a2, 6	#define o instrumento
	li a3, 120	#define o volume	
	li a7, 31	#define a chamada syscall
	ecall

	mv a0, a1	#passa a duracao da noa para a pausa
	li a7, 32	#define a chamada syscall
	ecall

	addi t1, t1, 1	#incrementa no musica nota atual
	la t5, NUM_GAME_OVER	
	lw t5, 0(t5)	#le o numero de notas
	blt t1, t5, salvar_indice_game_over	#se contador for menor que o numero de notas salva
	li t1, 0	#senao zera o indice

salvar_indice_game_over:

	sw t1, 0(t0)	#salva o indice
	j game_over_tecla	#volta para o musica

fim:

	li a7, 10	#Encerra o jogo
	ecall

.include "funcoes/colisao_inimigo.asm"
.include "funcoes/print_tiro.asm"
.include "funcoes/apagar_tiro.asm"
.include "funcoes/print.asm"
.include "funcoes/apagar.asm"
.include "funcoes/print_imagem.asm"
.include "funcoes/spawnar_inimigos.asm"
.include "funcoes/desenhar_inimigos.asm"
.include "funcoes/desenhar_vida.asm"
.include "funcoes/apagar_vida.asm"
.include "funcoes/mover_inimigo.asm"
.include "funcoes/tirar_inimigos.asm"
.include "funcoes/colisao.asm"
.include "funcoes/colisao_tiro.asm"

.data
.include "sprites/game_win.asm"
.include "sprites/mapa_colisao3.asm"
.include "sprites/fase_3/cenario3.asm"
.include "sprites/fase_3/frente_3.asm"
.include "sprites/fase_3/costas_3.asm"
.include "sprites/fase_3/direita_3.asm"
.include "sprites/fase_3/esquerda_3.asm"
.include "sprites/fase_3/inimigo_frente_3.asm"
.include "sprites/fase_3/inimigo_costas_3.asm"
.include "sprites/fase_3/inimigo_direita_3.asm"
.include "sprites/fase_3/inimigo_esquerda_3.asm"
.include "sprites/mapa_colisao1.asm"
.include "sprites/mapa_colisao2.asm"
.include "sprites/fase_2/cenario2.asm"
.include "sprites/fase_2/frente_2.asm"
.include "sprites/fase_2/costas_2.asm"
.include "sprites/fase_2/direita_2.asm"
.include "sprites/fase_2/esquerda_2.asm"
.include "sprites/fase_2/inimigo_frente_2.asm"
.include "sprites/fase_2/inimigo_costas_2.asm"
.include "sprites/fase_2/inimigo_direita_2.asm"
.include "sprites/fase_2/inimigo_esquerda_2.asm"
.include "sprites/game_over.asm"
.include "sprites/HUD/um.asm"
.include "sprites/HUD/dois.asm"
.include "sprites/HUD/tres.asm"
.include "sprites/HUD/coracao.asm"
.include "sprites/inimigo_frente.asm"
.include "sprites/inimigo_costas.asm"
.include "sprites/inimigo_esquerda.asm"
.include "sprites/inimigo_direita.asm"
.include "sprites/menu.asm"
.include "sprites/tiro.asm"
.include "sprites/cenario1.asm"
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/direita.asm"
.include "sprites/esquerda.asm"
