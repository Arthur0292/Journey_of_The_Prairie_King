##############################################################
#           Journey of The Prairie King - 2026
#		Trabalho de ISC	
#						     
##############################################################

.data

OLD_CHAR_POS: .half 150, 120	#Definir a posicao do player
CHAR_POS: .half 150, 120

TIRO_POS: 	#posicoes atuias e antigas do tiro
.half 0, 0	
TIRO_OLD_POS:	
.half 0, 0

INIMIGO_SPAWN_POS: #posicao de sapwn do inimigo
.half 190,10, 296,110, 86,110, 190,215 
INIMIGO_POS: #posicao do inimigo
.half 195,10, 308,124, 86,124, 195,230 
INIMIGO_OLD_POS: 
.half 0,0, 0,0, 0,0, 0,0
INIMIGO_ATIVO: 
.word 0, 0, 0, 0	#Inimigo ativo ou nao
INIMIGO_DIR:
.word 0, 0, 0, 0

inimigo_sprite:	#label do sprite do inimigo e largura
.word sprite_inimigo_frente, 16, 20
.word sprite_inimigo_costas, 16, 20
.word sprite_inimigo_direita, 16, 20
.word sprite_inimigo_esquerda, 16, 20

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
la t0, CHAR_POS #Armazena em t0 o endereco do CHAR_POS
lh t1, 0(t0)	#Le o (offset 0) e armazena em t1
lh t2, 2(t0)	#Le o (offset 2) e armazena em t2

#Armazeno os valores de t1 e t2 na posicao antiga
la t0, OLD_CHAR_POS
sh t1, 0(t0)	
sh t2, 2(t0)


la t0, TIRO_POS	#posicao do tiro
sh t1, 0(t0)	#x
sh t2, 2(t0)	#y

la t0, TIRO_OLD_POS	#atualizo a posicao antiga
sh t1, 0(t0)	#x
sh t2, 2(t0)	#y

li s0, 0	#defino o frame inicial para o menu

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

beq t1, zero, menu		#Se t0 = 0 entao nao apertou nenhuma tecla e pula

lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereco da tecla em t2

li t3, '1'
beq t2, t3 , continua	#Se tecla = 1 continua

li t3, '2'
beq t2, t3, fim		#Se for tecla 2 pula para o fim do jogo

continua:

la a0, CENARIO_DATA	#Carrega o endereco do cenario
li a1, 0		#Carrega em a1 o frame

addi sp, sp, -4		#salva o ra e imprimi
sw   ra, 0(sp)
call print_imagem
lw   ra, 0(sp)
addi sp, sp, 4


la a0, CENARIO_DATA	#Carrega o endereco do cenario
li a1, 1		#Carrega em a1 o frame

addi sp, sp, -4		#salva o ra e imprimi
sw   ra, 0(sp)
call print_imagem
lw   ra, 0(sp)
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

#Atualizar posicoes do jogador
la t0, OLD_CHAR_POS	#Carrego em t0 o OLD_CHAR_POS
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

la t0, OLD_CHAR_POS		#Carrega o endereco de old_char para t0
la t1, CHAR_POS			#carrega o endereco de char para t1
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
lh a2, 2(t0)		#aramzeno em a2 o y
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

j esquerda_tiro

cima_tiro:

la t0, TIRO_POS	#carrego o endereco
lh t1, 2(t0)	#leio o y
addi t1, t1, -3	#subtraio
li t4, 15		#Variavel para colisao
blt t1, t4, desativar_tiro
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

la t0, TIRO_POS	#carrego o endereco
lh t1, 2(t0)	#leio o y
addi t1, t1, 3	#adiciono
li t4, 215		#Variavel para colisao
bgt t1, t4, desativar_tiro
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

la t0, TIRO_POS	#carrego o endereco
lh t1, 0(t0)	#leio o x
addi t1, t1, 3	#adiciono
li t4, 300		#Variavel para colisao
bgt t1, t4, desativar_tiro
sh t1, 0(t0)		#Guarda a nova posicao no offset 2 = y

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

la t0, TIRO_POS	#carrego o endereco
lh t1, 0(t0)	#leio o x
addi t1, t1, -3	#adiciono
li t4, 90		#Variavel para colisao
blt t1, t4, desativar_tiro
sh t1, 0(t0)		#Guarda a nova posicao no offset 2 = y

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
beqz t1, game_over	#se for pula pro gamer over

addi sp, sp, -4	#chamo a funcao de imprimir a vida do player
sw ra, 0(sp)
call desenhar_vida
lw ra, 0(sp)
addi sp, sp, 4

addi sp, sp, -4	#chama a funcao de desenhar os inimigos
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
lw a0, 0(t0)		#Aramzena em a0 o sprite
lw a3, 4(t0)		#Aramzena em a3 a largura
lw a4, 8(t0)		#Aramzena em a4 a altura

#Funcao para printar o player na tela
la t0, CHAR_POS
lh a1, 0(t0)	#Aramzeno em a1 o x
lh a2, 2(t0)	#Aramzeno em a2 o y
mv a5, s3

addi sp, sp, -4	#Salvar o ra para o call a print
sw   ra, 0(sp)
call Print
lw   ra, 0(sp)
addi sp, sp, 4

#Alterna entre os frames 0 e 1 
li   t0, 0xFF200604		#Endereco nase
sw   s3, 0(t0)		#Leio o endereco e aramzeno em s3
mv   s0, s3		#Movo para s0 oque esta em s3 para alterna o frame no xori

j game_loop

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

ret			#Retorna para a funcao chamadora o game_loop


mover_cima:

la t0, CHAR_POS		#Pegando o endereco da posicao do jogador
lh t1, 2(t0)		#ler da memoria o offset 2 = y
addi t1, t1, -8		#Subtrai -8  pixels
li t4, 16		#Variavel para colisao
blt t1, t4, tecla_fim	#Se y < 16 entao nao muda a posicao 
sh t1, 2(t0)		#Guarda a nova posicao no offset 2 = y

la t0, PLAYER_STATE	#Pegando o endereco do status do player
li t1, 1		#Guarda em t1 o valor 1
sw t1, 0(t0)		#Muda o valor do player state

ret

mover_esquerda:

la t0, CHAR_POS		#Pegando o endereco da posicao do jogador
lh t1, 0(t0)		#ler da memoria o offset 0 = x
addi t1, t1, -8		#Mudar o x
li t4, 80		#variavel para colisao	
blt t1, t4, tecla_fim	#Se x<80 entao nao muda de posicao
sh t1, 0(t0)		#Guarda a nova posicao no offset 0 = x

la t0, PLAYER_STATE	
li t1, 3
sw t1, 0(t0)

ret

mover_baixo:

la t0, CHAR_POS		#Pegando o endereco da posicao do jogador
lh t1, 2(t0)		#ler da memoria o offset 2 = y
addi t1, t1, 8		#Soma 8
li t4, 215		#Guarda 215 em t4 para colisao
bgt t1, t4, tecla_fim	#Se t1>215 entao nao muda de posicao
sh t1, 2(t0)		#Guarda a nova posicao no offset 0 = x

la t0, PLAYER_STATE	
li t1, 0
sw t1, 0(t0)

ret	#retorna


mover_direita:

la t0, CHAR_POS		#Pegando o endereco da posicao do jogador
lh t1, 0(t0)		#ler da memoria o offset 0 = x
addi t1, t1, 8		#Soma 8
li t4, 286	#Guarda em t4 o valor 286 para colisao
bgt t1, t4, tecla_fim	#Se t1 > 286 entao nao muda de posicao
sh t1, 0(t0)		#Guarda a nova posicao no offset 0 = x

la t0, PLAYER_STATE	
li t1, 2
sw t1, 0(t0)

ret

tiro_cima:

la t0, CHAR_POS	#Pegar a posicao atual do jogador
lh t1, 0(t0)	#pegar o x
lh t2, 2(t0)	#pegar o y

la t0, TIRO_POS	#trocar de acordo com a posicao do player o x e y
sh t1, 0(t0)
sh t2, 2(t0)

la t0, TIRO_DIR	#defino a posicao do tiro
li t1, 0
sw t1, 0(t0)

la t0, TIRO_ATIVO	#defino se o tiro esta ativo
li t1, 1
sw t1, 0(t0)

j tecla_fim

tiro_baixo:

la t0, CHAR_POS	#Pegar a posicao atual do jogador
lh t1, 0(t0)	#pegar o x
lh t2, 2(t0)	#pegar o y

la t0, TIRO_POS	#trocar de acordo com a posicao do player o x e y
sh t1, 0(t0)
sh t2, 2(t0)

la t0, TIRO_DIR	#defino a posicao do tiro
li t1, 1
sw t1, 0(t0)

la t0, TIRO_ATIVO	#defino se o tiro esta ativo
li t1, 1
sw t1, 0(t0)

j tecla_fim

tiro_direita:

la t0, CHAR_POS	#Pegar a posicao atual do jogador
lh t1, 0(t0)	#pegar o x
lh t2, 2(t0)	#pegar o y

la t0, TIRO_POS	#trocar de acordo com a posicao do player o x e y
sh t1, 0(t0)
sh t2, 2(t0)

la t0, TIRO_DIR	#defino a posicao do tiro
li t1, 2
sw t1, 0(t0)

la t0, TIRO_ATIVO	#defino se o tiro esta ativo
li t1, 1
sw t1, 0(t0)

j tecla_fim

tiro_esquerda:

la t0, CHAR_POS	#Pegar a posicao atual do jogador
lh t1, 0(t0)	#pegar o x
lh t2, 2(t0)	#pegar o y

la t0, TIRO_POS	#trocar de acordo com a posicao do player o x e y
sh t1, 0(t0)
sh t2, 2(t0)

la t0, TIRO_DIR	#defino a posicao do tiro
li t1, 3
sw t1, 0(t0)

la t0, TIRO_ATIVO	#defino se o tiro esta ativo
li t1, 1
sw t1, 0(t0)

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


game_over:

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

li t0, 0xFF200000	#Carregar em t0 o endereco do teclado
lw t1, 0(t0)	#Armazenar em t1 o endereco do teclado

andi t1, t1, 1	#Se for 0 entao and 0 + 0 = 0 mas se for 1 entao and 1 + 1 = 1

beq t1, zero, game_over		#Se t0 = 0 entao nao apertou nenhuma tecla e pula

lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereco da tecla em t2

li t3, '1'
beq t2, t3 , atualizar_vida	#Se tecla = 1 muda a vida para 3

li t3, '2'
beq t2, t3, fim		#Se for tecla 2 pula para o fim do jogo

atualizar_vida:
la t0, player_vida	#atualizo a vida do player	
li t1, 3
lw t1, 0(t0)

la t0, old_player_vida	#atualizo a old vida do player
lw t1, 0(t0)

j menu	# volto para o menu

fim:

li a7, 10	#Encerra o jogo
ecall


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

.data
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
