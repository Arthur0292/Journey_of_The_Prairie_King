##############################################################
#            Journey of The Prairie King - 2026              #
##############################################################

.data

CHAR_POS:     .half 80, 80
OLD_CHAR_POS: .half 80, 80

playerstate: .word 0           # 0=frente 1=costas 2=direita 3=esquerda

player_state_sprite:
    .word sprite_frente_dados,   17, 17
    .word sprite_costas_dados,   17, 17
    .word sprite_direita_dados,  17, 17
    .word sprite_esquerda_dados, 17, 17

.text

    li   s0, 0                  # s0 = frame visível

    li   t5, 80
    li   t6, 80
    la   t0, CHAR_POS
    sh   t5, 0(t0)
    sh   t6, 2(t0)
    la   t0, OLD_CHAR_POS
    sh   t5, 0(t0)
    sh   t6, 2(t0)

    j    GAME_LOOP

##############################################################
# Registradores salvos (s):                                  #
#   s0 = frame visível                                       #
#   s3 = frame de trabalho (s0 XOR 1)                        #
# KEY usa internamente apenas t0..t6 e salva x/y em          #
# variáveis de memória, sem tocar em s0..s3                  #
##############################################################

GAME_LOOP:

    # 1) Define o frame de trabalho
    xori s3, s0, 1              # s3 = frame de trabalho

    # ========================================================
    # 2) APAGA A POSIÇÃO ANTIGA NO FRAME DE TRABALHO
    # ========================================================
    la   t0, OLD_CHAR_POS
    lh   a1, 0(t0)
    lh   a2, 2(t0)
    li   a3, 17                 # largura do boneco
    li   a4, 17                 # altura do boneco
    mv   a5, s3                 # frame de trabalho

    addi sp, sp, -4
    sw   ra, 0(sp)
    call Apagar
    lw   ra, 0(sp)
    addi sp, sp, 4

    # ========================================================
    # 3) O PULO DO GATO: Atualiza OLD_CHAR_POS ANTES do teclado alterar CHAR_POS
    # Dessa forma, OLD_CHAR_POS guarda exatamente o que está desenhado na tela
    # ========================================================
    la   t0, CHAR_POS
    lh   t5, 0(t0)
    lh   t6, 2(t0)
    la   t0, OLD_CHAR_POS
    sh   t5, 0(t0)
    sh   t6, 2(t0)

    # ========================================================
    # 4) LÊ O TECLADO (Agora sim, se mover, muda apenas CHAR_POS)
    # ========================================================
    addi sp, sp, -4
    sw   ra, 0(sp)
    call KEY
    lw   ra, 0(sp)
    addi sp, sp, 4

    # 5) Seleciona o sprite baseado no 'playerstate'
    lw   t2, playerstate
    li   t3, 12
    mul  t2, t2, t3
    la   t1, player_state_sprite
    add  t1, t1, t2
    lw   a0, 0(t1)              # endereço do sprite
    lw   a4, 4(t1)              # largura
    lw   a5, 8(t1)              # altura

    # ========================================================
    # 6) DESENHA O PLAYER NA NOVA POSIÇÃO
    # ========================================================
    la   t0, CHAR_POS
    lh   a1, 0(t0)
    lh   a2, 2(t0)
    mv   a3, s3                 # desenha no frame de trabalho

    addi sp, sp, -4
    sw   ra, 0(sp)
    call Print
    lw   ra, 0(sp)
    addi sp, sp, 4

    # ========================================================
    # 7) ATUALIZA O DISPLAY (Troca os frames)
    # ========================================================
    li   t0, 0xFF200604
    sw   s3, 0(t0)

    # O frame de trabalho vira o visível
    mv   s0, s3

    j    GAME_LOOP
KEY:
    li   t0, 0xFF200000
    lw   t1, 0(t0)
    andi t1, t1, 0x0001
    beq  t1, zero, KEY_FIM

    lw   t2, 4(t0)              # código da tecla

    la   t0, CHAR_POS
    lh   t3, 0(t0)              # x → t3
    lh   t4, 2(t0)              # y → t4

    li   t5, 'w'
    beq  t2, t5, MOVER_CIMA
    li   t5, 's'
    beq  t2, t5, MOVER_BAIXO
    li   t5, 'a'
    beq  t2, t5, MOVER_ESQUERDA
    li   t5, 'd'
    beq  t2, t5, MOVER_DIREITA
    j    KEY_FIM

MOVER_CIMA:
    addi t4, t4, -8
    blt  t4, zero, KEY_FIM
    la   t0, CHAR_POS
    sh   t4, 2(t0)
    li   t5, 1
    la   t6, playerstate
    sw   t5, 0(t6)
    j    KEY_FIM

MOVER_BAIXO:
    addi t4, t4, 8
    li   t5, 223
    bgt  t4, t5, KEY_FIM
    la   t0, CHAR_POS
    sh   t4, 2(t0)
    li   t5, 0
    la   t6, playerstate
    sw   t5, 0(t6)
    j    KEY_FIM

MOVER_ESQUERDA:
    addi t3, t3, -8
    blt  t3, zero, KEY_FIM
    la   t0, CHAR_POS
    sh   t3, 0(t0)
    li   t5, 3
    la   t6, playerstate
    sw   t5, 0(t6)
    j    KEY_FIM

MOVER_DIREITA:
    addi t3, t3, 8
    li   t5, 303
    bgt  t3, t5, KEY_FIM
    la   t0, CHAR_POS
    sh   t3, 0(t0)
    li   t5, 2
    la   t6, playerstate
    sw   t5, 0(t6)
    j    KEY_FIM

KEY_FIM:
    ret

.include "funcoes/print.asm"
.include "funcoes/apagar.asm"

.data
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/direita.asm"
.include "sprites/esquerda.asm"
