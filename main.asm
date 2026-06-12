.data
.align 2

# Dados de controle do Jogador
player_x:  .word 152
player_y:  .word 192

# ---------------------------------------------------------
# CARGA DOS SPRITES E CENÁRIO
# ---------------------------------------------------------
.align 2
# FIX BUG 3: .incbin não é suportado no RARS padrão.
# Use .include com o arquivo .asm equivalente.
# Se você tiver o RARS customizado com .incbin, troque pelas linhas comentadas abaixo.
#
# VERSÃO .incbin  (RARS customizado):
# CENARIO_DATA: .incbin "sprites/cenario.bin"
#
# VERSÃO .include (RARS padrão — ATIVA):
CENARIO_DATA:
.include "sprites/cenario.asm"

.align 2
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/esquerda.asm"
.include "sprites/direita.asm"

.text
.globl main

main:
    la s4, sprite_frente     # s4 = Sprite ativo inicial do jogador
    lw t0, player_x          # t0 = Posição X atual do jogador
    lw t1, player_y          # t1 = Posição Y atual do jogador
    li s0, 0                 # s0 = Frame atual de trabalho (começa no Frame 0)

game_loop:
    # ---------------------------------------------------------
    # PASSO 1: ALTERNAR O BUFFER DE TRABALHO (DOUBLE BUFFERING)
    # ---------------------------------------------------------
    xori s0, s0, 1           # Alterna s0 entre 0 e 1 (Ping-Pong)

    # ---------------------------------------------------------
    # PASSO 2: DESENHAR O CENÁRIO DE FUNDO NO BUFFER ESCONDIDO
    # ---------------------------------------------------------
    li a0, 0                 # X inicial = 0
    li a1, 0                 # Y inicial = 0
    la a2, CENARIO_DATA      # Endereço dos dados de pixels do cenário
    mv a3, s0                # Envia o frame ativo atual (s0)
    li a4, 320               # GAME_WIDTH (Largura lógica)
    li a5, 240               # GAME_HEIGHT (Altura lógica)
    jal ra, desenhar_bitmap

    # ---------------------------------------------------------
    # PASSO 3: DESENHAR O PERSONAGEM POR CIMA NO MESMO BUFFER
    # ---------------------------------------------------------
    mv a0, t0                # Posição X atual do jogador
    mv a1, t1                # Posição Y atual do jogador
    mv a2, s4                # Endereço do sprite de direção do jogador
    mv a3, s0                # Envia o mesmo frame ativo atual (s0)
    li a4, 6                 # sprite_w (Largura do sprite)
    li a5, 7                 # sprite_h (Altura do sprite)
    jal ra, desenhar_bitmap

    # ---------------------------------------------------------
    # PASSO 4: CONTROLE DE FLUIDEZ (DELAY DE ~60 FPS)
    # FIX BUG 2: o "sw s0, 0(0xFF200604)" foi REMOVIDO.
    # Esse endereço é do hardware DE1-SoC (Altera), não existe no RARS.
    # No RARS o double buffering é feito escrevendo diretamente nas
    # bases 0x10010000 (frame 0) / 0x10110000 (frame 1), o que já
    # acontece corretamente dentro de desenhar_bitmap via s7.
    # ---------------------------------------------------------
    li a7, 32                # Syscall de Sleep do RARS
    li a0, 16                # Aguarda 16 milissegundos
    ecall

    # ---------------------------------------------------------
    # PASSO 5: LEITURA DO TECLADO POR MMIO
    # ---------------------------------------------------------
    li t2, 0xFFFF0000        # Endereço de controle do teclado
    lw t3, 0(t2)             # Lê o status do teclado
    andi t3, t3, 1           # Isola o bit de tecla pressionada
    beq t3, zero, game_loop  # Se nenhuma tecla foi pressionada, vai pro próximo frame

    # Processa o caractere ASCII da tecla
    lw t4, 4(t2)

    li t5, 0x77              # Código ASCII para 'w' (Cima)
    beq t4, t5, mover_cima

    li t5, 0x73              # Código ASCII para 's' (Baixo)
    beq t4, t5, mover_baixo

    li t5, 0x61              # Código ASCII para 'a' (Esquerda)
    beq t4, t5, mover_esquerda

    li t5, 0x64              # Código ASCII para 'd' (Direita)
    beq t4, t5, mover_direita

    j game_loop              # Outra tecla: continua o loop

# ---------------------------------------------------------
# BLOCOS DE MOVIMENTAÇÃO E SELEÇÃO DE SPRITE
# ---------------------------------------------------------
mover_cima:
    li t6, 8
    blt t1, t6, game_loop    # Impede de sair pelas bordas superiores
    addi t1, t1, -8
    la s4, sprite_costas     # Muda o visual para costas
    j game_loop

mover_baixo:
    li t6, 204
    bgt t1, t6, game_loop    # Impede de sair pelas bordas inferiores
    addi t1, t1, 8
    la s4, sprite_frente     # Muda o visual para frente
    j game_loop

mover_direita:
    li t6, 288
    bgt t0, t6, game_loop    # Impede de sair pela extrema direita
    addi t0, t0, 8
    la s4, sprite_direita    # Muda o visual para direita
    j game_loop

mover_esquerda:
    li t6, 8
    blt t0, t6, game_loop    # Impede de sair pela extrema esquerda
    addi t0, t0, -8
    la s4, sprite_esquerda   # Muda o visual para esquerda
    j game_loop

# Inclui o arquivo de funções de renderização
.include "funcoes/print.asm"
