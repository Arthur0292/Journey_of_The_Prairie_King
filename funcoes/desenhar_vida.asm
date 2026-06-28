desenhar_vida:

la t0, player_vida	#ler a vida antiga e nova do player e compara
lw t1, 0(t0)
la t0, old_player_vida
lw t2, 0(t0)

beq t1, t2, fim_desenhar_vida	#se forem iguais vai para o fim
beqz t2, pula_apagar	#se t2 = 0 pula o apagar

#carrega os dados para o apagar_vida
li a1, 23
li a2, 50
li a3, 25
li a4, 25
li a5, 0

addi sp, sp, -4	#salva o ra e chama o apagar_vida
sw ra, 0(sp)
call Apagar_vida
lw ra, 0(sp)
addi sp, sp, 4

li a1, 23
li a2, 50
li a3, 25
li a4, 25
li a5, 1

addi sp, sp, -4	#salva o ra e chama o apagar_vida
sw ra, 0(sp)
call Apagar_vida
lw ra, 0(sp)
addi sp, sp, 4

pula_apagar:

la t0, player_vida
lw t1, 0(t0)

addi t3, t1, -1#achar posicao da vida 
li t4, 12
mul t3, t3, t4

la t5, placar_vida #carrego endereco de placar_vida e os dados
add t5, t5, t3
lw a0, 0(t5)
lw a3, 4(t5)
lw a4, 8(t5)

li a1, 23	#x
li a2, 50	#y
li a5, 0	#frame
addi sp, sp, -4
sw ra, 0(sp)
call Print
lw ra, 0(sp)
addi sp, sp, 4

li a1, 23	#x
li a2, 50	#y
li a5, 1	#frame
addi sp, sp, -4
sw ra, 0(sp)
call Print
lw ra, 0(sp)
addi sp, sp, 4

la t0, old_player_vida	#atualizo o old player vida
sw t1, 0(t0)

fim_desenhar_vida:
ret
