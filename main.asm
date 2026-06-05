.eqv DISPLAY_BASE    0x10010000
.eqv DISPLAY_STRIDE  512        # largura da janela física
.eqv GAME_WIDTH      320        # largura lógica do jogo
.eqv GAME_HEIGHT     240        # altura lógica do jogo
.eqv SCALE           4          # Fator de escala (cada pixel do sprite vira 4x4 na tela)

.data

.align 2
sprite_w: .word 6
sprite_h: .word 7

sprite_costas:
.byte 16, 14, 14, 14, 14, 16
.byte 14, 14, 14, 14, 14, 14
.byte 16, 17, 17, 17, 17, 16
.byte 16, 17, 17, 17, 17, 16
.byte 3, 3, 3, 3, 3, 3
.byte 17, 3, 3, 3, 3, 11
.byte 16, 14, 16, 16, 14, 16

sprite_frente:
.byte 16, 14, 14, 14, 14, 16
.byte 14, 14, 14, 14, 14, 14
.byte 16, 7, 17, 17, 7, 16
.byte 16, 17, 17, 17, 17, 16
.byte 3, 3, 3, 3, 3, 3
.byte 17, 3, 3, 3, 3, 11
.byte 16, 14, 16, 16, 14, 11

sprite_esquerda:
.byte 16, 14, 14, 14, 14, 16
.byte 14, 14, 14, 14, 14, 14
.byte 16, 7, 17, 17, 17, 16
.byte 16, 17, 17, 17, 17, 16
.byte 3, 3, 3, 3, 3, 3
.byte 11, 11, 3, 3, 3, 17
.byte 16, 14, 16, 16, 14, 11

sprite_direita:
.byte 16, 14, 14, 14, 14, 16
.byte 14, 14, 14, 14, 14, 14
.byte 16, 17, 17, 17, 7, 16
.byte 16, 17, 17, 17, 17, 16
.byte 3, 3, 3, 3, 3, 3
.byte 17, 3, 3, 3, 11, 11
.byte 16, 14, 16, 16, 14, 11

# Cores do jogo
paleta:
    .word 0x00000000   # 0  = preto
    .word 0x00FFFFFF   # 1  = branco
    .word 0x00FF0000   # 2  = vermelho
    .word 0x0000FF00   # 3  = verde
    .word 0x000000FF   # 4  = azul
    .word 0x00FFFF00   # 5  = amarelo
    .word 0x00FF00FF   # 6  = magenta
    .word 0x0000FFFF   # 7  = ciano
    .word 0x00FF8000   # 8  = laranja
    .word 0x00102040   # 9  = azul noturno (céu)
    .word 0x00204010   # 10 = verde escuro (grama)
    .word 0x00606060   # 11 = cinza médio
    .word 0x00C0C0C0   # 12 = cinza claro
    .word 0x00E04020   # 13 = vermelho-laranja (personagem)
    .word 0x00804000   # 14 = marrom
    .word 0x005080FF   # 15 = azul céu claro
    .word 0x00EACBA5   # 16 - cor de fundo
    .word 0x00D4B392   # 17 - cor personagem

player_x:  .word 152       
player_y:  .word 192       
player_w:  .word 6
player_h:  .word 7


.text
.globl main

main:
    la s4, sprite_frente
    lw t0, player_x
    lw t1, player_y

game_loop:
    # Desenha o sprite ampliado na posição atual
    mv a0, t0
    mv a1, t1
    mv a2, s4
    jal ra, desenhar_sprite

    # Checa o teclado MMIO
    li t2, 0xFFFF0000
    lw t3, 0(t2)
    andi t3, t3, 1

    beq t3, zero, game_loop 

    # Processa a tecla apertada
    lw t4, 4(t2)

    li t5, 0x77
    beq t4, t5, mover_cima

    li t5, 0x73
    beq t4, t5, mover_baixo

    li t5, 0x61
    beq t4, t5, mover_esquerda

    li t5, 0x64
    beq t4, t5, mover_direita

    j game_loop

mover_cima:
    li t6, 0
    blt t1, t6, game_loop         # Se altura < 8 não altera a posicao do jogador
    addi t1, t1, -8               
    la s4, sprite_costas
    j game_loop

mover_baixo:
    li t6, 203                    # Se altura > 203 não altera a posicao do jogador
    bgt t1, t6, game_loop
    addi t1, t1, 8
    la s4, sprite_frente
    j game_loop

mover_direita:
    li t6, 277                    # Se altura > 277 não altera a posicao do jogador
    bgt t0, t6, game_loop
    addi t0, t0, 8
    la s4, sprite_direita
    j game_loop

mover_esquerda:
    li t6, 0
    blt t0, t6, game_loop         # Se altura < 8 não altAera a posicao do jogador
    addi t0, t0, -8
    la s4, sprite_esquerda
    j game_loop
    
    
.include "cenario.asm"
