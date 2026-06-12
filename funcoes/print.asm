# -------------------------------------------------------------------------
# FUNÇÃO GENÉRICA COM DOUBLE BUFFERING: desenhar_bitmap
# Argumentos de Entrada:
#   a0 = Posição lógica X inicial de desenho (0 a 319)
#   a1 = Posição lógica Y inicial de desenho (0 a 240)
#   a2 = Endereço de memória dos dados de cor (.bin ou rótulo de bytes)
#   a3 = FRAME DE TRABALHO ATUAL (0 para o Frame 0, 1 para o Frame 1)
#   a4 = Largura da imagem em pixels lógicos
#   a5 = Altura da imagem em pixels lógicos
# -------------------------------------------------------------------------
.globl desenhar_bitmap

desenhar_bitmap:
    # Reserva espaço na Pilha (Stack Pointer) e preserva os registradores salvos
    addi sp, sp, -36
    sw ra, 32(sp)
    sw s1, 28(sp)
    sw s2, 24(sp)
    sw s3, 20(sp)
    sw s4, 16(sp)
    sw s5, 12(sp)
    sw s6, 8(sp)
    sw s7, 4(sp)

    mv s1, a0                # s1 = Coordenada X inicial do desenho
    mv s2, a1                # s2 = Coordenada Y inicial do desenho
    mv s3, a2                # s3 = Ponteiro de varredura dos dados de pixels
    mv s4, a4                # s4 = Limite total de colunas (Largura)
    mv s5, a5                # s5 = Limite total de linhas (Altura)
    
    # --- GERENCIAMENTO DE BUFFER DUPLO ---
    # RARS Frame 0 Base: 0x10010000
    # RARS Frame 1 Base: 0x10110000
    li s7, 0x10010000        # Assume por padrão a VRAM do Frame 0
    beq a3, zero, frame_pronto
    li s7, 0x10110000        # Caso a3 seja 1, redireciona para a VRAM do Frame 1
frame_pronto:

    li s6, 0                 # Contador de controle de Linhas Lógicas (Y)

linha_loop:
    li t0, 0                 # Contador de controle de Colunas Lógicas (X)

coluna_loop:
    # 1. Extração da cor de 24 bits (Padrão de arquivos binários BGR)
    lbu t1, 0(s3)            # Componente Azul (B)
    lbu t2, 1(s3)            # Componente Verde (G)
    slli t2, t2, 8
    or t1, t1, t2
    lbu t2, 2(s3)            # Componente Vermelho (R)
    slli t2, t2, 16
    or t3, t1, t2            # t3 = Cor compactada final (0x00RRGGBB)

    # 2. Mapeamento matemático de pixels lógicos para pixels físicos (Escala 4x4)
    # Linha física = (Y_inicial + Y_atual) * SCALE (4)
    add t4, s2, s6           
    slli t4, t4, 2           # t4 = Linha física final
    
    # Avanço em bytes na tela física = Linha física * 512 pixels de largura * 4 bytes por pixel
    # 512 * 4 = 2048 bytes por linha da janela do RARS
    li t5, 2048
    mul t4, t4, t5
    add t4, t4, s7           # Soma o offset da linha física com a base da VRAM (s7)

    # Coluna física = (X_inicial + X_atual) * SCALE (4)
    add t5, s1, t0           
    slli t5, t5, 2           # t5 = Coluna física final
    slli t5, t5, 2           # Converte a coluna física para escala de bytes (* 4)
    add t4, t4, t5           # t4 = Endereço exato de memória para iniciar o bloco 4x4

    # 3. Renderização física do bloco ampliado de 4x4 pixels na tela
    li t2, 0                 # Loop vertical interno do bloco 4x4
bloco_y:
    li t5, 0                 # Loop horizontal interno do bloco 4x4
bloco_x:
    sw t3, 0(t4)             # Plota o pixel físico na memória de vídeo
    addi t4, t4, 4           # Anda 1 pixel físico para a direita (+4 bytes)
    addi t5, t5, 1
    li a7, 4                 # SCALE = 4
    blt t5, a7, bloco_x

    # --- RESOLUÇÃO DO ADDI OVERFLOW ---
    # Para avançar uma linha física para baixo, carregamos o valor grande (2048) 
    # em t6 usando 'li' para contornar o limite de 12 bits assinalados do 'addi' (máx 2047)
    li t6, 2048              
    add t4, t4, t6           # Pula o equivalente a uma linha inteira física para baixo
    addi t4, t4, -16         # Recua 16 bytes (4 pixels) para alinhar o cursor na mesma coluna
    
    addi t2, t2, 1
    li a7, 4                 # SCALE = 4
    blt t2, a7, bloco_y

    # 4. Incremento e processamento dos loops de dados
    addi s3, s3, 3           # Avança 3 bytes nos dados brutos do arquivo (Próximo pixel BGR)
    addi t0, t0, 1           # Incrementa o contador de coluna
    blt t0, s4, coluna_loop

    addi s6, s6, 1           # Incrementa o contador de linha
    blt s6, s5, linha_loop

    # Restaura o estado original dos registradores salvos na pilha
    lw ra, 32(sp)
    lw s1, 28(sp)
    lw s2, 24(sp)
    lw s3, 20(sp)
    lw s4, 16(sp)
    lw s5, 12(sp)
    lw s6, 8(sp)
    lw s7, 4(sp)
    addi sp, sp, 36
    jr ra                    # Retorna com segurança absoluta para o fluxo do programa
