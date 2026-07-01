spawnar_inimigos:
addi sp, sp, -4
sw s1, 0(sp)
li s1, 0              # s1 = i (contador)
loop_spawn:

li t1, 4	#adiciono o max de inimigos
bge s1, t1, fim_spawn
slli t2, s1, 2	

la t3, INIMIGO_ATIVO	#Armazeno o endereco de inimigo ativo
add t3, t3, t2
lw t4, 0(t3)
bnez t4, proximo_slot      # se já está ativo pula esse slot

la t5, INIMIGO_SPAWN_POS	#Ler a posicao de spawn do inimigo
add t5, t5, t2
lh t6, 0(t5)	#leio a posicao x
lh t4, 2(t5)	#leio a posicao y

la t5, INIMIGO_POS
add t5, t5, t2
sh t6, 0(t5)
sh t4, 2(t5)

la t5, INIMIGO_OLD_POS          
add t5, t5, t2
sh t6, 0(t5)
sh t4, 2(t5)

la t5, INIMIGO_DIR           
add t5, t5, t2
sw zero, 0(t5)

li t5, 1                   
sw t5, 0(t3) # ativa o slot

mv a1, t6  # x
mv a2, t4  # y
la t0, inimigo_sprite    # offset 0 = frente, que é DIR=0
lw a0, 0(t0)	# qual frame
lw a3, 4(t0)	#largura e altura do inimigo
lw a4, 8(t0)


li a5, 0	#desenha inimigo no frame 0
addi sp, sp, -4
sw ra, 0(sp)
call Print
lw ra, 0(sp)
addi sp, sp, 4

li a5, 1	#desenha inimigo no frame 1
addi sp, sp, -4
sw ra, 0(sp)
call Print
lw ra, 0(sp)
addi sp, sp, 4

proximo_slot:
addi s1, s1, 1
j loop_spawn

fim_spawn:
lw s1, 0(sp)
addi sp, sp, 4
ret

