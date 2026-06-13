##############################################################
#           Journey of The Prairie King - 2026
#			      Trabalho de ISC	
#						     
##############################################################


.data

OLD_CHAR_POS: .half 80, 80
CHAR_POS: .half 80, 80

PLAYER_STATE: .word 0	# 0 = frente, 1 = costas, 2 = direita, 3 = esquerda



.text
main:

#.half = 2 bytes
#Armazenar posição atual do jogador
la t0, CHAR_POS #Armazena em t0 o endereço do CHAR_POS
lh t1, 0(t0)	#Le o (offset 0) e aramazena em t1
lh t2, 2(t0)	#Le o (offset 2) e armazena em t2

#Armazenar os valores na posição antiga
la t0, OLD_CHAR_POS
sh t1, 0(t0)	
sh t2, 2(t0)


game_loop:

li t0, 0xFF200000	#Carregar em t0 o endereco do teclado
lw t1, 0(t0)	#Aramzenar em t1 o endereço do teclado

andi t1, t1, 1	#Se for 0 entao and 0 + 0 = 0 mas se for 1 entao and 1 + 1 = 1

beq t1, zero, sem_tecla		#Se t0 = 0 entao nao apertou nenhuma tecla e pula

lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereço da tecla em t2

li t3, 'w'
beq t2, t3 , mover_cima		#Se tecla = w pula para mover cima

li t3, 'a'
beq t2, t3 , mover_esquerda	#Se tecla = a pula para mover esquerda

li t3, 's'
beq t2, t3 , mover_baixo	#Se tecla = s pula para mover baixo

li t3, 'd'
beq t2, t3 , mover_direita	#Se tecla = d pula para mover direita

sem_tecla:

j game_loop

mover_cima:

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 2(t0)		#ler da memoria o offset 2 = y
addi t1, t1, -8		#Subtrai -8  pixels
blt t1, zero, sem_tecla	#Se y < 0 entao nao muda a posição 
sh t1, 2(t0)		#Guarda a nova posição no offset 2 = y

la t0, PLAYER_STATE	#Pegando o endereço do status do player
li t1, 1		#Guarda em t1 o valor 1
sw t1, 0(t0)		#Muda o valor do player state

j sem_tecla		#Volta para o game_loop

mover_esquerda:

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 0(t0)		#ler da memoria o offset 0 = x
addi t1, t1, -8
blt t1, zero, sem_tecla	#Se x<0 então não muda de posição
sh t1, 0(t0)		#Guarda a nova posição no offset 0 = x

la t0, PLAYER_STATE	
li t1, 3
sw t1, 0(t0)

j sem_tecla

mover_baixo:

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 2(t0)		#ler da memoria o offset 2 = y
addi t1, t1, 8		#Soma 8
li t4, 223		#Guarda 223 em t4
bgt t1, t4, sem_tecla	#Se t1>223 então não muda de posição
sh t1, 2(t0)		#Guarda a nova posição no offset 0 = x

la t0, PLAYER_STATE	
li t1, 0
sw t1, 0(t0)

j sem_tecla


mover_direita:

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 0(t0)		#ler da memoria o offset 0 = x
addi t1, t1, 8		#Soma 8
li t4, 303		#Guarda em t4 o valor 303
bgt t1, t4, sem_tecla	#Se t1 > 303 então não muda de posição
sh t1, 0(t0)		#Guarda a nova posição no offset 0 = x

la t0, PLAYER_STATE	
li t1, 2
sw t1, 0(t0)

j sem_tecla


.include "funcoes/print.asm"
.include "funcoes/apagar.asm"

.data
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/direita.asm"
.include "sprites/esquerda.asm"
