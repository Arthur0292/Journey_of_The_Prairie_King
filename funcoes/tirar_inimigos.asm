tirar_inimigos:
addi sp, sp, -4
sw s1, 0(sp)
li s1, 0	#contador de inimigos

loop_limpar:

li t2, 4	#se inimigos >= 4 pula pro fim
bge s1, t2, fim_limpar	

slli t3, s1, 2 #calculo o offset  

la t4, INIMIGO_ATIVO	#carrego o inimigo ativo
add t4, t4, t3	#Adiciono com o offset
lw t5, 0(t4)
beq t5, zero, proximo_limpar	#se = 0 entao pulo para o proximo inimigo

la t6, INIMIGO_OLD_POS	#carrego a posicao antiga
add t6, t6, t3	#sommo com o offset
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

sw zero, 0(t4)	#desativo o inimigo

proximo_limpar:
addi s1, s1, 1	#adiciono 1 ao contador
j loop_limpar	#volto pro loop

fim_limpar:
lw s1, 0(sp)
addi sp, sp, 4
ret


