.data
.align 2

# Inclui os dados binários do cenário diretamente aqui
CENARIO_DATA:
    .incbin "sprites/cenario.bin"

# Dados de controle do Jogador
player_x:  .word 152       
player_y:  .word 192       

# Armazena os sprites estáticos na memória
.align 2
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/esquerda.asm"
.include "sprites/direita.asm"

.text
.globl main

main:
    la s4, sprite_frente     # s4 = Sprite ativo inicial
    lw t0, player_x          # t0 = Posição X atual do jogador
    lw t1, player_y          # t1 = Posição Y atual do jogador
    li s0, 0                 # s0 = Frame atual de trabalho (começa no 0)

game_loop:
    # ---------------------------------------------------------
    # PASSO 1: INVERTER O FRAME DE TRABALHO (PING-PONG)
    # ---------------------------------------------------------
    xori s0, s0, 1           # Se s0 era 0 vira 1. Se era 1 vira 0.

    # ---------------------------------------------------------
    # PASSO 2: DESENHAR O CENÁRIO DE FUNDO NO FRAME ATUAL
    # ---------------------------------------------------------
    li a0, 0                 # X inicial = 0
    li a1, 0                 # Y inicial = 0
    la a2, CENARIO_DATA      # Endereço dos dados binários
    mv a3, s0                # Envia o frame atual (s0) para a função
    li a4, 320               # Largura do cenário
    li a5, 240               # Altura do cenário
    jal ra, desenhar_bitmap

    # ---------------------------------------------------------
    # PASSO 3: DESENHAR O PERSONAGEM POR CIMA NO MESMO FRAME
    # ---------------------------------------------------------
    mv a0, t0                # X atual do player
    mv a1, t1                # Y atual do player
    mv a2, s4                # Endereço do sprite do player
    mv a3, s0                # Mesmo frame atual (s0)
    li a4, 6                 # Largura do sprite (sprite_w)
    li a5, 7                 # Altura do sprite (sprite_h)
    jal ra, desenhar_bitmap

    # ---------------------------------------------------------
    # PASSO 4: EXIBIR O FRAME PRONTO NO MONITOR DO SIMULADOR
    # ---------------------------------------------------------
    li t2, 0xFF200604        # Endereço de controle de frame do RARS
    sw s0, 0(t2)             # Altera o frame exibido instantaneamente

    # ---------------------------------------------------------
    # PASSO 5: CONTROLADOR DE TIMING (DELAY) E TECLADO MMIO
    # ---------------------------------------------------------
    li a7, 32                # Syscall de sleep do RARS
    li a0, 16                # Mantém estável a ~60 quadros por segundo
    ecall

    # Checa entrada do teclado por MMIO
    li t2, 0xFFFF0000
    lw t3, 0(t2)
    andi t3, t3, 1
    beq t3, zero, game_loop  # Se não apertou nada, reinicia o frame

    # Processa a tecla apertada
    lw t4, 4(t2)

    li t5, 0x77              # Tecla 'w'
    beq t4, t5, mover_cima

    li t5, 0x73              # Tecla 's'
    beq t4, t5, mover_baixo

    li t5, 0x61              # Tecla 'a'
    beq t4, t5, mover_esquerda

    li t5, 0x64              # Tecla 'd'
    beq t4, t5, mover_direita

    j game_loop

# --- Blocos de movimentação ---
mover_cima:
    li t6, 8
    blt t1, t6, game_loop
    addi t1, t1, -8                
    la s4, sprite_costas
    j game_loop

mover_baixo:
    li t6, 204
    bgt t1, t6, game_loop
    addi t1, t1, 8
    la s4, sprite_frente
    j game_loop

mover_direita:
    li t6, 288
    bgt t0, t6, game_loop
    addi t0, t0, 8
    la s4, sprite_direita
    j game_loop

mover_esquerda:
    li t6, 8
    blt t0, t6, game_loop
    addi t0, t0, -8
    la s4, sprite_esquerda
    j game_loop

# Inclui a função genérica de impressão
.include "funcoes/print.asm"
