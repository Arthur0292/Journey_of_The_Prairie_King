# -------------------------------------------------------------------------
# FUNÇÃO GENÉRICA COM DOUBLE BUFFERING: desenhar_bitmap
# Argumentos de Entrada:
#   a0 = Posição lógica X inicial de desenho (0 a 319)
#   a1 = Posição lógica Y inicial de desenho (0 a 240)
#   a2 = Endereço de memória dos dados de cor (.bin ou rótulo de bytes)
#   a3 = FRAME DE TRABALHO ATUAL (0 para o Frame 0, 1 para o Frame 1)
#   a4 = Largura da imagem em pixels lógicos
#   a5 = Altura da imagem em pixels lógicos
#
# Registradores internos usados:
#   s1=X_inicial  s2=Y_inicial  s3=ponteiro_pixels
#   s4=largura    s5=altura     s6=linha_logica  s7=base_vram
#   t0=col_logica t1=B  t2=linha_bloco  t3=cor_final
#   t4=addr       t5=col_bloco   t6=constante_escala/2048
# -------------------------------------------------------------------------
.globl desenhar_bitmap

desenhar_bitmap:
    addi sp, sp, -36
    sw ra, 32(sp)
    sw s1, 28(sp)
    sw s2, 24(sp)
    sw s3, 20(sp)
    sw s4, 16(sp)
    sw s5, 12(sp)
    sw s6,  8(sp)
    sw s7,  4(sp)

    mv s1, a0                # s1 = X inicial
    mv s2, a1                # s2 = Y inicial
    mv s3, a2                # s3 = ponteiro nos dados de pixel
    mv s4, a4                # s4 = largura lógica
    mv s5, a5                # s5 = altura lógica

    # Seleciona a base de VRAM conforme o frame
    li s7, 0x10010000        # Frame 0
    beq a3, zero, frame_pronto
    li s7, 0x10110000        # Frame 1
frame_pronto:

    li s6, 0                 # s6 = contador de linha lógica

linha_loop:
    li t0, 0                 # t0 = contador de coluna lógica

coluna_loop:
    # --- Extração de cor BGR (3 bytes) ---
    lbu t1, 0(s3)            # Azul  (B)
    lbu t3, 1(s3)            # Verde (G)  — FIX: usa t3 direto, não t2
    slli t3, t3, 8
    or  t1, t1, t3
    lbu t3, 2(s3)            # Vermelho (R)
    slli t3, t3, 16
    or  t3, t1, t3           # t3 = 0x00RRGGBB (cor final, não será mais tocado)

    # --- Cálculo do endereço base do bloco 4x4 ---
    # Linha física = (s2 + s6) * 4
    add  t4, s2, s6
    slli t4, t4, 2
    # Offset de linha = linha_fisica * 2048  (512 px * 4 bytes)
    li   t5, 2048
    mul  t4, t4, t5
    add  t4, t4, s7          # t4 = base_vram + offset_linha

    # Coluna física = (s1 + t0) * 4 * 4  (scale * bytes_por_pixel)
    add  t5, s1, t0
    slli t5, t5, 4           # *16 = *4 (escala) * 4 (bytes) em um só shift
    add  t4, t4, t5          # t4 = endereço exato do canto superior esquerdo do bloco

    # --- Renderiza bloco 4x4 ---
    # t2 = linha interna do bloco (0..3)
    # t5 = coluna interna do bloco (0..3)
    # t3 = cor — nunca sobrescrito neste trecho
    li t2, 0
bloco_y:
    li t5, 0
bloco_x:
    sw t3, 0(t4)             # Escreve pixel
    addi t4, t4, 4           # Avança 1 pixel para a direita
    addi t5, t5, 1
    # FIX BUG 1: era "li a7, 4" — a7 é o registrador de syscall!
    # Corrigido para t6 em todas as ocorrências.
    li t6, 4
    blt t5, t6, bloco_x      # Repete para as 4 colunas do bloco

    # Avança uma linha física para baixo e volta para a coluna inicial do bloco
    # Usar li+add pois 2048 > limite de 12 bits do addi
    li   t6, 2048
    add  t4, t4, t6          # Desce uma linha física (+2048 bytes)
    addi t4, t4, -16         # Recua 4 pixels para alinhar na coluna de início

    addi t2, t2, 1
    li t6, 4                 # FIX BUG 1: era "li a7, 4"
    blt t2, t6, bloco_y      # Repete para as 4 linhas do bloco

    # --- Avança para o próximo pixel lógico ---
    addi s3, s3, 3           # Próximo pixel BGR (+3 bytes)
    addi t0, t0, 1
    blt  t0, s4, coluna_loop

    addi s6, s6, 1
    blt  s6, s5, linha_loop

    # Restaura registradores e retorna
    lw ra, 32(sp)
    lw s1, 28(sp)
    lw s2, 24(sp)
    lw s3, 20(sp)
    lw s4, 16(sp)
    lw s5, 12(sp)
    lw s6,  8(sp)
    lw s7,  4(sp)
    addi sp, sp, 36
    jr ra
