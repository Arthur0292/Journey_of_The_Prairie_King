# -------------------------------------------------------------------------
# FUNÇÃO GENÉRICA COM DOUBLE BUFFERING: desenhar_bitmap
# Argumentos:
#   a0 = Posição lógica X inicial na tela (0 a 319)
#   a1 = Posição lógica Y inicial na tela (0 a 240)
#   a2 = Endereço base dos dados binários (.bin)
#   a3 = FRAME ATUAL DE TRABALHO (0 para Frame 0, 1 para Frame 1)
#   a4 = Largura lógica da imagem (Ex: 320 para o cenário)
#   a5 = Altura lógica da imagem (Ex: 240 para o cenário)
# -------------------------------------------------------------------------
.globl desenhar_bitmap

desenhar_bitmap:
    # Salva os registradores na Pilha (Stack)
    addi sp, sp, -36
    sw ra, 32(sp)
    sw s1, 28(sp)
    sw s2, 24(sp)
    sw s3, 20(sp)
    sw s4, 16(sp)
    sw s5, 12(sp)
    sw s6, 8(sp)
    sw s7, 4(sp)

    mv s1, a0                # s1 = X atual de desenho
    mv s2, a1                # s2 = Y atual de desenho
    mv s3, a2                # s3 = Ponteiro dos dados (.bin)
    mv s4, a4                # s4 = Limite de Largura
    mv s5, a5                # s5 = Limite de Altura
    
    # --- CÁLCULO DA BASE DA VRAM POR FRAME ---
    # Se a3 == 0 -> Base = 0x10010000 (Frame 0)
    # Se a3 == 1 -> Base = 0x10110000 (Frame 1)
    li s7, 0x10010000        # Base padrão (Frame 0)
    beq a3, zero, fim_calc_frame
    li s7, 0x10110000        # Se a3 != 0, muda para a base do Frame 1
fim_calc_frame:

    li s6, 0                 # Contador de linhas processadas (Y: 0 até Altura)

linha_loop:
    li t0, 0                 # Contador de colunas processadas (X: 0 até Largura)

coluna_loop:
    # 1. Carrega a cor RGB de 24-bits do arquivo (Formato BGR)
    lbu t1, 0(s3)            # Azul
    lbu t2, 1(s3)            # Verde
    slli t2, t2, 8
    or t1, t1, t2
    lbu t2, 2(s3)            # Vermelho
    slli t2, t2, 16
    or t3, t1, t2            # t3 = Cor hexadecimal final (0x00RRGGBB)

    # 2. Calcula a posição física na tela considerando a Escala (4x4)
    add t4, s2, s6           # Y_logico_atual
    slli t4, t4, 2           # Y_fisico = Y_logico_atual * 4
    
    # Endereço da linha física = Linha * 512 * 4 -> (2048 bytes por linha física)
    li t5, 2048
    mul t4, t4, t5
    add t4, t4, s7           # Soma com a base dinâmica calculada (s7)

    # Adiciona o deslocamento do eixo X
    add t5, s1, t0           # X_logico_atual
    slli t5, t5, 2           # X_fisico = X_logico_atual * 4
    slli t5, t5, 2           # Converte pixels para bytes (X_fisico * 4)
    add t4, t4, t5           # t4 = Endereço exato do pixel inicial do bloco 4x4

    # 3. Desenha o bloco físico 4x4 na VRAM
    li t2, 0                 # Loop Y interno do bloco
bloco_y:
    li t5, 0                 # Loop X interno do bloco
bloco_x:
    sw t3, 0(t4)             # Plota o pixel físico
    addi t4, t4, 4           # Avança horizontalmente na VRAM
    addi t5, t5, 1
    li a7, 4                 # SCALE
    blt t5, a7, bloco_x

    # Avança para a próxima linha do bloco físico
    addi t4, t4, 2048        # Pula uma linha física inteira para baixo
    addi t4, t4, -16         # Retorna os 4 pixels avançados para alinhar a coluna
    
    addi t2, t2, 1
    li a7, 4                 # SCALE
    blt t2, a7, bloco_y

    # 4. Atualiza os ponteiros e loops
    addi s3, s3, 3           # Avança 3 bytes no binário (.bin)
    addi t0, t0, 1           # Próxima coluna
    blt t0, s4, coluna_loop

    addi s6, s6, 1           # Próxima linha
    blt s6, s5, linha_loop

    # Recupera os registradores salvos na Pilha e finaliza
    lw ra, 32(sp)
    lw s1, 28(sp)
    lw s2, 24(sp)
    lw s3, 20(sp)
    lw s4, 16(sp)
    lw s5, 12(sp)
    lw s6, 8(sp)
    lw s7, 4(sp)
    addi sp, sp, 36
    jr ra
