# #################################################
# FUNÇÃO PRINT ADAPTADA DO OUTRO PROJETO
# #################################################
#	a0 = endereço imagem			
#	a1 = x					
#	a2 = y					
#	a3 = frame (0 ou 1)			
# #################################################

Print:
    # Cálculo genial do endereço base usando shift
    li t0, 0xFF0            # Carrega 0xFF0
    add t0, t0, a3          # Adiciona o frame (0xFF0 ou 0xFF1)
    slli t0, t0, 20         # Desloca 20 bits -> 0xFF000000 ou 0xFF100000
    
    # Aplica a fórmula (Y * 320) + X
    add t0, t0, a1          # Adiciona X ao endereço base
    li t1, 320              
    mul t1, t1, a2          # t1 = Y * 320
    add t0, t0, t1          # t0 = Endereço exato do pixel inicial na tela
    
    mv t1, zero             # Contador de linha = 0
    mv t2, zero             # Contador de coluna = 0
    mv t6, a0               # t6 = Ponteiro dos dados da imagem
    
    # Como seu arquivo binário possui apenas os pixels, definimos o tamanho fixo aqui:
    li t3, 16               # t3 = largura (16 pixels)
    li t4, 16               # t4 = altura (16 pixels)
    
PrintLinha:
    lbu t5, 0(t6)           # Carrega 1 byte (cor do pixel) do arquivo
    sb t5, 0(t0)            # Desenha no Bitmap Display
    addi t0, t0, 1          # Avança o endereço da tela
    addi t6, t6, 1          # Avança o endereço da imagem
    addi t2, t2, 1          # Incrementa contador de coluna
    blt t2, t3, PrintLinha  # Se coluna < largura, continua desenhando a linha
    
    # Pula para a próxima linha da tela
    addi t0, t0, 320        
    sub t0, t0, t3          # Ajusta o ponteiro para o início da nova linha
    mv t2, zero             # Reseta o contador de coluna
    addi t1, t1, 1          # Incrementa contador de linha
    blt t1, t4, PrintLinha  # Se contador de linha < altura, desenha a próxima linha
    ret                     # Retorna
