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
# VERSÃO .incbin  (RARS customizado — comentada):
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

    # FIX BUG 4: t0/t1 são caller-saved e serão destruídos por desenhar_bitmap.
    # Posição X e Y do jogador ficam em s2/s3 (callee-saved), que a função
    # salva e restaura corretamente via pilha.
    lw s2, player_x          # s2 = Posição X atual do jogador (protegido)
    lw s3, player_y          # s3 = Posição Y atual do jogador (protegido)

    # FIX BUG 5: começar s0 em 1 para que o xori logo abaixo produza 0
    # no primeiro frame, evitando flash de lixo do buffer 1 não inicializado.
    li s0, 1                 # s0 = começa em 1, vira 0 no primeiro xori

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
    mv a3, s0                # Frame ativo atual
    li a4, 320               # GAME_WIDTH (Largura lógica)
    li a5, 240               # GAME_HEIGHT (Altura lógica)
    jal ra, desenhar_bitmap
    # ATENÇÃO: t0–t6 são lixo após o jal. Usar apenas s-regs daqui em diante.

    # ---------------------------------------------------------
    # PASSO 3: DESENHAR O PERSONAGEM POR CIMA NO MESMO BUFFER
    # ---------------------------------------------------------
    mv a0, s2                # FIX BUG 4: posição X vem de s2 (não t0)
    mv a1, s3                # FIX BUG 4: posição Y vem de s3 (não t1)
    mv a2, s4                # Endereço do sprite de direção do jogador
    mv a3, s0                # Frame ativo atual
    li a4, 6                 # sprite_w
    li a5, 7                 # sprite_h
    jal ra, desenhar_bitmap

    # ---------------------------------------------------------
    # PASSO 4: CONTROLE DE FLUIDEZ (DELAY DE ~60 FPS)
    # FIX BUG 2: removido sw s0, 0(0xFF200604) — endereço DE1-SoC,
    # não existe no RARS. Double buffering já funciona pelas bases
    # 0x10010000/0x10110000 gerenciadas dentro de desenhar_bitmap.
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
    beq t3, zero, game_loop  # Nenhuma tecla: próximo frame

    lw t4, 4(t2)             # Lê o caractere ASCII da tecla

    li t5, 0x77              # 'w' (Cima)
    beq t4, t5, mover_cima

    li t5, 0x73              # 's' (Baixo)
    beq t4, t5, mover_baixo

    li t5, 0x61              # 'a' (Esquerda)
    beq t4, t5, mover_esquerda

    li t5, 0x64              # 'd' (Direita)
    beq t4, t5, mover_direita

    j game_loop

# ---------------------------------------------------------
# BLOCOS DE MOVIMENTAÇÃO
# FIX BUG 4: todos usam s2/s3 no lugar de t0/t1
# ---------------------------------------------------------
mover_cima:
    li t6, 8
    blt s3, t6, game_loop    # Borda superior
    addi s3, s3, -8
    la s4, sprite_costas
    j game_loop

mover_baixo:
    li t6, 204
    bgt s3, t6, game_loop    # Borda inferior
    addi s3, s3, 8
    la s4, sprite_frente
    j game_loop

mover_direita:
    li t6, 288
    bgt s2, t6, game_loop    # Borda direita
    addi s2, s2, 8
    la s4, sprite_direita
    j game_loop

mover_esquerda:
    li t6, 8
    blt s2, t6, game_loop    # Borda esquerda
    addi s2, s2, -8
    la s4, sprite_esquerda
    j game_loop

.include "funcoes/print.asm"
