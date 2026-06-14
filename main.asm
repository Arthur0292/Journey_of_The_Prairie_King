##############################################################
#           Journey of The Prairie King - 2026
#		Trabalho de ISC	
#						     
##############################################################


.data

OLD_CHAR_POS: .half 80, 80
CHAR_POS: .half 80, 80

PLAYER_STATE: .word 0	# 0 = frente, 1 = costas, 2 = direita, 3 = esquerda

player_state_sprite:
    .word sprite_frente_dados,   17, 17
    .word sprite_costas_dados,   17, 17
    .word sprite_direita_dados,  17, 17
    .word sprite_esquerda_dados, 17, 17

.text
main:

#.half = 2 bytes
#Armazenar posição atual do jogador
la t0, CHAR_POS #Armazena em t0 o endereço do CHAR_POS
lh t1, 0(t0)	#Le o (offset 0) e armazena em t1
lh t2, 2(t0)	#Le o (offset 2) e armazena em t2

#Armazenar os valores na posição antiga
la t0, OLD_CHAR_POS
sh t1, 0(t0)	
sh t2, 2(t0)

li s0, 0

la a0, CENARIO_DATA	#Carrega o endereco do cenario
li a1, 0		#Carrega em a1 o frame
call print_imagem

la a0, CENARIO_DATA	#Carrega o endereco do cenario
li a1, 1		#Carrega em a1 o frame
call print_imagem


game_loop:

xori s3, s0, 1	#Alterna o frame 



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

la t0, OLD_CHAR_POS		#Carrega o endereço de old_char para t0
la t1, CHAR_POS			#carrega o endereço de char para t1
lh t2, 0(t1)		#Ler o o valor x de t1 
sh t2, 0(t0)		#Armazena esse valor no old_char
lh t2, 2(t1)		#Ler o o valor y de t1
sh t2, 2(t0)		#Armazena esse valor no old_char


addi sp, sp, -4	#Salvar o ra para o call a tecla
sw   ra, 0(sp)
call tecla
lw   ra, 0(sp)
addi sp, sp, 4


#Ler o status atual do player
lw t2 , PLAYER_STATE	#Le o status do player atual e aramzzena em t2
li t3, 12	#Variavel 12
mul t4, t3, t2	#Multiplica o staus por 12

#De acordo com staus selecione o frame a ser carregado armazenado o offset 0, 4, 8
la t0, player_state_sprite	#Carrega em t0 o endereço de player_state_sprite
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
lw t1, 0(t0)	#Aramzenar em t1 o endereço do teclado

andi t1, t1, 1	#Se for 0 entao and 0 + 0 = 0 mas se for 1 entao and 1 + 1 = 1

beq t1, zero, tecla_fim		#Se t0 = 0 entao nao apertou nenhuma tecla e pula

lw t2, 4(t0)	#Como t0 aramzena 4 bytes eu pulo e armazeno o endereço da tecla em t2

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

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 2(t0)		#ler da memoria o offset 2 = y
addi t1, t1, -8		#Subtrai -8  pixels
blt t1, zero, tecla_fim	#Se y < 0 entao nao muda a posição 
sh t1, 2(t0)		#Guarda a nova posição no offset 2 = y

la t0, PLAYER_STATE	#Pegando o endereço do status do player
li t1, 1		#Guarda em t1 o valor 1
sw t1, 0(t0)		#Muda o valor do player state

ret

mover_esquerda:

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 0(t0)		#ler da memoria o offset 0 = x
addi t1, t1, -8
blt t1, zero, tecla_fim	#Se x<0 então não muda de posição
sh t1, 0(t0)		#Guarda a nova posição no offset 0 = x

la t0, PLAYER_STATE	
li t1, 3
sw t1, 0(t0)

ret

mover_baixo:

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 2(t0)		#ler da memoria o offset 2 = y
addi t1, t1, 8		#Soma 8
li t4, 223		#Guarda 223 em t4
bgt t1, t4, tecla_fim	#Se t1>223 então não muda de posição
sh t1, 2(t0)		#Guarda a nova posição no offset 0 = x

la t0, PLAYER_STATE	
li t1, 0
sw t1, 0(t0)

ret	#retorna


mover_direita:

la t0, CHAR_POS		#Pegando o endereço da posição do jogador
lh t1, 0(t0)		#ler da memoria o offset 0 = x
addi t1, t1, 8		#Soma 8
li t4, 303		#Guarda em t4 o valor 303
bgt t1, t4, tecla_fim	#Se t1 > 303 então não muda de posição
sh t1, 0(t0)		#Guarda a nova posição no offset 0 = x

la t0, PLAYER_STATE	
li t1, 2
sw t1, 0(t0)

ret

tecla_fim:

ret	#Retorna para o game_loop


.include "funcoes/print.asm"
.include "funcoes/apagar.asm"
.include "funcoes/print_imagem.asm"

.data
.include "sprites/cenario1.asm"
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/direita.asm"
.include "sprites/esquerda.asm"
