.eqv DISPLAY_BASE,    0xFF000000
.eqv GAME_WIDTH,      320        # largura lógica do jogo
.eqv GAME_HEIGHT,     240        # altura lógica do jogo

.data

.align 2
player_x:  .word 152        
player_y:  .word 192        
player_w:  .word 16              # Atualizado para 16
player_h:  .word 16              # Atualizado para 16

.text
.globl main

main:
    lw t0, player_x
    lw t1, player_y

game_loop:
    # Salva na memória RAM para atualizar a posição real do jogo
    sw t0, player_x
    sw t1, player_y

    # Prepara os argumentos padrões antes de checar o teclado
    mv a1, t0
    mv a2, t1

    # Checa o teclado MMIO
    li t2, 0xFFFF0000
    lw t3, 0(t2)
    andi t3, t3, 1

    beq t3, zero, game_loop # Se nenhuma tecla for pressionada, repete o loop

    # Processa a tecla apertada
    lw t4, 4(t2)

    li t5, 0x77        # 'w'
    beq t4, t5, mover_cima

    li t5, 0x73        # 's'
    beq t4, t5, mover_baixo

    li t5, 0x61        # 'a'
    beq t4, t5, mover_esquerda

    li t5, 0x64        # 'd'
    beq t4, t5, mover_direita

    j game_loop

mover_cima:
    li t6, 0
    ble t1, t6, game_loop         # Se Y <= 0, não sobe mais
    addi t1, t1, -8               
    j game_loop

mover_baixo:
    li t6, 224                    # 240 - 16 = 224
    bge t1, t6, game_loop         # Se Y >= 224, não desce mais
    addi t1, t1, 8
    j game_loop

mover_direita:
    li t6, 304                    # 320 - 16 = 304
    bge t0, t6, game_loop         # Se X >= 304, não vai mais para a direita
    addi t0, t0, 8
    j game_loop

mover_esquerda:
    li t6, 0
    ble t0, t6, game_loop         # Se X <= 0, não vai mais para a esquerda
    addi t0, t0, -8
    j game_loop
    
    
.include "sprites/cenario.asm"
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/esquerda.asm"
.include "sprites/direita.asm"
