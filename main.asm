.eqv DISPLAY_BASE    0xFF000000
.eqv GAME_WIDTH      320        # largura lógica do jogo
.eqv GAME_HEIGHT     240        # altura lógica do jogo

.data

.align 2
sprite_w: .word 6
sprite_h: .word 7

player_x:  .word 152       
player_y:  .word 192       
player_w:  .word 18
player_h:  .word 21

.text
.globl main

main:
    lw t0, player_x
    lw t1, player_y

game_loop:
    mv a0, t0
    mv a1, t1

    # Checa o teclado MMIO
    li t2, 0xFFFF0000
    lw t3, 0(t2)
    andi t3, t3, 1

    beq t3, zero, game_loop #Se tecla == 0 volta para o loop

    # Processa a tecla apertada
    lw t4, 4(t2)

    li t5, 0x77		#Se tecla == w 
    beq t4, t5, mover_cima

    li t5, 0x73		#Se tecla == s
    beq t4, t5, mover_baixo

    li t5, 0x61		#Se tecla == a
    beq t4, t5, mover_esquerda

    li t5, 0x64		#Se tecla == d
    beq t4, t5, mover_direita

    j game_loop

mover_cima:
    li t6, 0
    ble t1, t6, game_loop         # Se altura <= 8 não altera a posicao do jogador
    addi t1, t1, -8               
    j game_loop

mover_baixo:
    li t6, 219                    # Se altura >= 203 não altera a posicao do jogador
    bge t1, t6, game_loop
    addi t1, t1, 8
    j game_loop

mover_direita:
    li t6, 302                    # Se altura >= 277 não altera a posicao do jogador
    bge t0, t6, game_loop
    addi t0, t0, 8
    j game_loop

mover_esquerda:
    li t6, 0
    ble t0, t6, game_loop         # Se altura <= 8 não altAera a posicao do jogador
    addi t0, t0, -8
    j game_loop
    
    
.include "sprites/cenario.asm"
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/esquerda.asm"
.include "sprites/direita.asm"

