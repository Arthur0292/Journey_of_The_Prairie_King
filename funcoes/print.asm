##############################################################
#                   Função: Print                            #
#                                                            #
#   Desenha um sprite no Bitmap Display do RARS             #
#   usando Double Buffering.                                 #
#                                                            #
#   Formato do sprite na memória:                           #
#       word 0  → largura  (em pixels)                      #
#       word 4  → altura   (em pixels)                      #
#       bytes seguintes → cores (1 byte por pixel, RGB332)  #
#                                                            #
##############################################################
#   Parâmetros de entrada:                                  #
#       a0 = endereço do sprite (label do .data)            #
#       a1 = x  (coluna de destino no display)              #
#       a2 = y  (linha  de destino no display)              #
#       a3 = frame  (0 ou 1 — double buffering)             #
#                                                            #
##############################################################
#   Registradores usados internamente (preservados pelo     #
#   chamador via convenção de chamada RISC-V):               #
#       t0 = endereço base no Bitmap Display                #
#       t1 = contador de linha                              #
#       t2 = contador de coluna                             #
#       t3 = largura do sprite                              #
#       t4 = altura do sprite                               #
#       t5 = byte de cor atual                              #
#       t6 = ponteiro na memória do sprite                  #
##############################################################
#                                                            #
#   Bitmap Display (RARS):                                  #
#       Frame 0 → base 0xFF000000                           #
#       Frame 1 → base 0xFF100000                           #
#       Cada frame tem 320 bytes de largura (320 colunas)   #
#                                                            #
#   Cálculo do endereço de destino:                         #
#       base = 0xFF0 | frame  → shift 20 → 0xFF0_0000       #
#       offset = y * 320 + x                                #
#       endereço = base + offset                            #
##############################################################

Print:
    #-----------------------------------------------------------
    # 1. Calcula o endereço base do frame correto no Display
    #-----------------------------------------------------------
    li   t0, 0xFF0              # 0xFF0 (parte alta do endereço)
    add  t0, t0, a3             # + frame (0 → 0xFF0, 1 → 0xFF1)
    slli t0, t0, 20             # desloca 20 bits: vira 0xFF000000 ou 0xFF100000

    #-----------------------------------------------------------
    # 2. Aplica offset (y * 320 + x)
    #    320 = largura total do Bitmap Display em bytes/pixels
    #-----------------------------------------------------------
    li   t1, 320
    mul  t1, t1, a2             # t1 = y * 320
    add  t0, t0, t1             # t0 += linha
    add  t0, t0, a1             # t0 += coluna (x)
    # t0 agora aponta para o pixel (x, y) no frame escolhido

    #-----------------------------------------------------------
    # 3. Lê cabeçalho do sprite: largura e altura
    #-----------------------------------------------------------
    mv   t6, a0                 # t6 = ponteiro no sprite (não altera a0)
    lw   t3, 0(t6)              # t3 = largura  (width)
    lw   t4, 4(t6)              # t4 = altura   (height)
    addi t6, t6, 8              # t6 aponta para o primeiro byte de cor

    #-----------------------------------------------------------
    # 4. Zera contadores de linha e coluna
    #-----------------------------------------------------------
    li   t1, 0                  # t1 = contador de linha  (linha atual)
    li   t2, 0                  # t2 = contador de coluna (coluna atual)

##############################################################
#   Loop de impressão pixel a pixel                         #
#                                                            #
#   Para cada pixel:                                        #
#     - Lê 1 byte do sprite                                 #
#     - Escreve 1 byte no Bitmap Display                    #
#     - Avança os ponteiros                                  #
#   Ao fim de cada linha:                                   #
#     - Pula (320 - largura) bytes no Display               #
#       para chegar ao início da próxima linha do sprite    #
##############################################################

PrintLinha:
    #-----------------------------------------------------------
    # 5a. Copia um pixel (1 byte)
    #-----------------------------------------------------------
    lbu  t5, 0(t6)              # t5 = cor do pixel atual (unsigned byte)
    sb   t5, 0(t0)              # escreve no Bitmap Display

    #-----------------------------------------------------------
    # 5b. Avança ponteiros e contadores
    #-----------------------------------------------------------
    addi t0, t0, 1              # próximo pixel no Display
    addi t6, t6, 1              # próximo byte no sprite
    addi t2, t2, 1              # incrementa coluna

    #-----------------------------------------------------------
    # 5c. Chegou ao fim da linha do sprite?
    #-----------------------------------------------------------
    blt  t2, t3, PrintLinha     # coluna < largura → continua na mesma linha

    #-----------------------------------------------------------
    # 6. Fim de linha: pula o restante da linha do Display
    #    O Display tem 320 colunas; o sprite tem t3 colunas.
    #    Faltam (320 - t3) bytes para chegar à próxima linha.
    #-----------------------------------------------------------
    li   t5, 320
    sub  t5, t5, t3             # t5 = 320 - largura_sprite
    add  t0, t0, t5             # avança t0 para o início da próxima linha

    #-----------------------------------------------------------
    # 7. Reinicia contador de coluna, incrementa linha
    #-----------------------------------------------------------
    li   t2, 0                  # zera contador de coluna
    addi t1, t1, 1              # incrementa contador de linha

    #-----------------------------------------------------------
    # 8. Ainda há linhas? (height > linha_atual)
    #-----------------------------------------------------------
    blt  t1, t4, PrintLinha     # linha < altura → próxima linha

    #-----------------------------------------------------------
    # 9. Todos os pixels desenhados → retorna
    #-----------------------------------------------------------
    ret
