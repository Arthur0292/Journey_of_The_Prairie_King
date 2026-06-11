.eqv DISPLAY_BASE,    0xFF000000
.eqv GAME_WIDTH,      320        # largura lógica do jogo
.eqv GAME_HEIGHT,     240        # altura lógica do jogo

.data

.align 2
player_x:  .word 152        
player_y:  .word 192        
player_w:  .word 17              
player_h:  .word 17              

.text
.globl main

main:
    lw t0, player_x
    lw t1, player_y

    # Desenha o jogador parado na posição inicial ao abrir o jogo
    la a0, sprite_frente_dados   
    mv a1, t0                    
    mv a2, t1                    
    li a3, 0                     
    jal Print

game_loop:
    # Salva na memória RAM para atualizar a posição real do jogo
    sw t0, player_x
    sw t1, player_y

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
    addi t1, t1, -8               # Altera coordenada Y do jogador

    # Carimba o sprite andando para cima (Costas)
    la a0, sprite_costas_dados    
    mv a1, t0                     
    mv a2, t1                     
    li a3, 0                      
    jal Print
    j game_loop

mover_baixo:
    li t6, 223                    # 240 - 16 = 224
    bge t1, t6, game_loop         # Se Y >= 224, não desce mais
    addi t1, t1, 8                # Altera coordenada Y do jogador

    # Carimba o sprite andando para baixo (Frente)
    la a0, sprite_frente_dados    
    mv a1, t0                     
    mv a2, t1                     
    li a3, 0                      
    jal Print
    j game_loop

mover_direita:
    li t6, 303                    # 320 - 16 = 304
    bge t0, t6, game_loop         # Se X >= 304, não vai mais para a direita
    addi t0, t0, 8                # Altera coordenada X do jogador

    # Carimba o sprite andando para a direita
    la a0, sprite_direita_dados   
    mv a1, t0                     
    mv a2, t1                     
    li a3, 0                      
    jal Print
    j game_loop

mover_esquerda:
    li t6, 0
    ble t0, t6, game_loop         # Se X <= 0, não vai mais para a esquerda
    addi t0, t0, -8               # Altera coordenada X do jogador

    # Carimba o sprite andando para a esquerda
    la a0, sprite_esquerda_dados  
    mv a1, t0                     
    mv a2, t1                     
    li a3, 0                      
    jal Print
    j game_loop

# #################################################
# FUNÇÃO PRINT
# #################################################
Print:
    # Cálculo do endereço base do frame usando shift
    li t0, 0xFF0            
    add t0, t0, a3          
    slli t0, t0, 20         # t0 = 0xFF000000 ou 0xFF100000
    
    # Aplica a fórmula: DISPLAY_BASE + (Y * 320) + X
    li t1, 320              
    mul t1, t1, a2          # t1 = Y * 320
    add t0, t0, t1          
    add t0, t0, a1          # t0 = Endereço do pixel exato na tela
    
    mv t1, zero             # Contador de linha (Y) = 0
    mv t6, a0               # t6 = Ponteiro dos bytes da imagem
    
    li t3, 17               # t3 = largura fixada em 17
    li t4, 17               # t4 = altura fixada em 17
    
PrintLinha:
    mv t2, zero             # Reseta o contador de colunas

PrintColuna:
    lbu t5, 0(t6)           # Carrega a cor do pixel do sprite
    sb t5, 0(t0)            # Escreve a cor na tela
    
    addi t0, t0, 1          # Anda para o próximo pixel à direita na tela
    addi t6, t6, 1          # Avança na memória do sprite
    addi t2, t2, 1          # Incrementa coluna
    blt t2, t3, PrintColuna # Se coluna < 16, continua a linha
    
    # Próxima linha da tela
    addi t0, t0, 320        
    sub t0, t0, t3          # Reposiciona o ponteiro horizontal da tela
    
    addi t1, t1, 1          # Incrementa linha
    blt t1, t4, PrintLinha  # Se linha < 16, repete para a próxima linha
    ret                     
    
.include "sprites/frente.asm"
.include "sprites/costas.asm"
.include "sprites/esquerda.asm"
.include "sprites/direita.asm"
