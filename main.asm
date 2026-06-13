
##############################################################
#           Journey of The Prairie King - 2026               #
#                                                            #
#   Trabalho de Introdução ao sistemas computacionais    #
#                                                            #
#   Uso de Double Buffering para animação suave              #
#   Sprites direcionais: frente, costas, esquerda, direita   #
##############################################################

.data

##############################################
#          Posição do personagem             #
##############################################
CHAR_POS:       .half 80, 80        # x, y  (posição atual)
OLD_CHAR_POS:   .half 80, 80        # x, y  (posição anterior — para apagar rastro)

##############################################
#    Estado do jogador (direção atual)       #
#    0 = frente  1 = costas                  #
#    2 = direita 3 = esquerda                #
##############################################
playerstate:    .word 0

##############################################
#          Tabela de sprites por direção     #
##############################################
player_state_sprite:
    .word frente_dados      # estado 0 → frente
    .word costas_dados      # estado 1 → costas
    .word direita_dados     # estado 2 → direita
    .word esquerda_dados    # estado 3 → esquerda

##############################################
#          Tile de fundo (apagar rastro)     #
##############################################
# snow_dados é o tile de chão que substitui  #
# a posição antiga do personagem             #
##############################################

.text

##############################################
#               INÍCIO DO PROGRAMA          #
##############################################

    # ----- Desenha o mapa nos dois frames -----
    la   a0, mapa_dados     # endereço do sprite do mapa
    li   a1, 0              # x = 0
    li   a2, 0              # y = 0
    li   a3, 0              # frame 0
    call Print

    li   a3, 1              # frame 1
    call Print

    # ----- Inicializa s0 como frame atual -----
    li   s0, 0              # s0 = frame atual (alterna entre 0 e 1)

    # ----- Posição inicial do personagem -----
    li   t5, 80
    li   t6, 80
    la   t0, CHAR_POS
    sh   t5, 0(t0)
    sh   t6, 2(t0)
    la   t0, OLD_CHAR_POS
    sh   t5, 0(t0)
    sh   t6, 2(t0)

    j    GAME_LOOP

##############################################
#           LOOP PRINCIPAL                  #
##############################################

GAME_LOOP:
    # ----- Lê teclado e atualiza posição -----
    call KEY                    # trata entrada → atualiza CHAR_POS e playerstate

    # ----- Alterna o frame (double buffering) -----
    xori s0, s0, 1              # s0 = 0 → 1 ou 1 → 0

    # =========================================
    # 1) DESENHA O PERSONAGEM no frame s0
    # =========================================
    lw   t2, playerstate        # t2 = estado atual (0..3)
    li   t3, 4
    mul  t2, t2, t3             # offset em bytes na tabela (cada word = 4 bytes)

    la   t1, player_state_sprite
    add  t1, t1, t2             # endereço da entrada correta na tabela
    lw   a0, 0(t1)              # a0 = endereço do sprite correspondente

    la   t0, CHAR_POS
    lh   a1, 0(t0)              # a1 = x atual
    lh   a2, 2(t0)              # a2 = y atual
    mv   a3, s0                 # a3 = frame atual
    call Print                  # desenha personagem

    # =========================================
    # 2) EXIBE o frame atual no bitmap display
    # =========================================
    li   t0, 0xFF200604         # endereço de troca de frame do bitmap display
    sw   s0, 0(t0)              # ativa o frame recém-desenhado

    # =========================================
    # 3) APAGA O RASTRO no frame ANTERIOR
    #    (posição antiga recebe tile de chão)
    # =========================================
    la   t0, OLD_CHAR_POS

    la   a0, snow_dados         # sprite de chão (apaga personagem antigo)
    lh   a1, 0(t0)              # x antigo
    lh   a2, 2(t0)              # y antigo

    # Apaga nos dois frames para não deixar "fantasma"
    mv   a3, s0
    xori a3, a3, 1              # frame oposto ao atual
    call Print
    mv   a3, s0                 # frame atual também
    call Print

    # =========================================
    # 4) Salva posição atual como "antiga"
    # =========================================
    la   t0, CHAR_POS
    lh   t5, 0(t0)
    lh   t6, 2(t0)

    la   t0, OLD_CHAR_POS
    sh   t5, 0(t0)
    sh   t6, 2(t0)

    j    GAME_LOOP              # repete o loop

##############################################
#       PROCEDIMENTO: KEY (Teclado)         #
##############################################
# Lê o teclado MMIO e move o personagem.    #
# Atualiza CHAR_POS e playerstate.          #
# Usa t0..t4 internamente.                  #
##############################################

KEY:
    li   t0, 0xFF200000         # endereço do controlador de teclado MMIO
    lw   t1, 0(t0)              # lê registrador de status
    andi t1, t1, 0x0001         # bit 0 = tecla disponível?
    beq  t1, zero, KEY_FIM      # nenhuma tecla → sai

    lw   t2, 4(t0)              # lê o código da tecla

    # ------ Limites do mapa (em pixels) ------
    # Supondo mapa 160x160, sprite 16x16
    # x: [0 .. 144]   y: [0 .. 144]

    la   t0, CHAR_POS
    lh   t3, 0(t0)              # t3 = x atual
    lh   t4, 2(t0)              # t4 = y atual

    li   t5, 'w'
    beq  t2, t5, MOVE_UP
    li   t5, 's'
    beq  t2, t5, MOVE_DOWN
    li   t5, 'a'
    beq  t2, t5, MOVE_LEFT
    li   t5, 'd'
    beq  t2, t5, MOVE_RIGHT

    # Teclas de seta também funcionam
    li   t5, 0x41               # seta cima (código RARS)
    beq  t2, t5, MOVE_UP
    li   t5, 0x42               # seta baixo
    beq  t2, t5, MOVE_DOWN
    li   t5, 0x44               # seta esquerda
    beq  t2, t5, MOVE_LEFT
    li   t5, 0x43               # seta direita
    beq  t2, t5, MOVE_RIGHT

    j    KEY_FIM

MOVE_UP:
    li   t5, 8                  # velocidade de movimento (pixels por frame)
    sub  t4, t4, t5             # y -= 8
    blt  t4, zero, KEY_FIM     # não ultrapassa borda superior
    sh   t4, 2(t0)              # salva novo y
    li   t5, 1                  # estado = costas (olhando para cima)
    la   t0, playerstate
    sw   t5, 0(t0)
    j    KEY_FIM

MOVE_DOWN:
    li   t5, 8
    add  t4, t4, t5             # y += 8
    li   t5, 144
    bgt  t4, t5, KEY_FIM       # não ultrapassa borda inferior
    sh   t4, 2(t0)
    li   t5, 0                  # estado = frente
    la   t0, playerstate
    sw   t5, 0(t0)
    j    KEY_FIM

MOVE_LEFT:
    li   t5, 8
    sub  t3, t3, t5             # x -= 8
    blt  t3, zero, KEY_FIM
    sh   t3, 0(t0)
    li   t5, 3                  # estado = esquerda
    la   t0, playerstate
    sw   t5, 0(t0)
    j    KEY_FIM

MOVE_RIGHT:
    li   t5, 8
    add  t3, t3, t5             # x += 8
    li   t5, 144
    bgt  t3, t5, KEY_FIM
    sh   t3, 0(t0)
    li   t5, 2                  # estado = direita
    la   t0, playerstate
    sw   t5, 0(t0)
    j    KEY_FIM

KEY_FIM:
    ret

##############################################
#       Inclui função Print                  #
##############################################
.include "funcoes/print.asm"

##############################################
#       Inclui dados dos sprites             #
##############################################
.data
.include "sprites/frente.asm"       # frente_dados
.include "sprites/costas.asm"       # costas_dados
.include "sprites/direita.asm"      # direita_dados
.include "sprites/esquerda.asm"     # esquerda_dados
.include "sprites/cenario.asm"      # mapa_dados  (tile de chão: snow_dados)
