##############################################################
#                   Função: Print                            #
#                                                            #
#   a0 = endereço do sprite (direto nos bytes, sem header)  #
#   a1 = x                                                  #
#   a2 = y                                                  #
#   a3 = frame (0 ou 1)                                     #
#   a4 = largura  (ex: 16)                                  #
#   a5 = altura   (ex: 21)                                  #
#                                                            #
#   t0 = endereço no Bitmap Display                         #
#   t1 = contador de linha                                  #
#   t2 = contador de coluna                                 #
#   t3 = largura                                            #
#   t4 = altura                                             #
#   t5 = byte de cor / auxiliar                             #
#   t6 = ponteiro no sprite                                 #
##############################################################

Print:
    # 1. Endereço base do frame
    li   t0, 0xFF0
    add  t0, t0, a3
    slli t0, t0, 20             # 0xFF000000 ou 0xFF100000

    # 2. Offset = y * 320 + x
    li   t1, 320
    mul  t1, t1, a2
    add  t0, t0, t1
    add  t0, t0, a1

    # 3. Largura e altura vêm de a4 e a5 (sem header no sprite)
    mv   t3, a4                 # largura
    mv   t4, a5                 # altura
    mv   t6, a0                 # ponteiro no sprite

    # 4. Contadores
    li   t1, 0                  # linha
    li   t2, 0                  # coluna

PrintLinha:
    lbu  t5, 0(t6)
    sb   t5, 0(t0)

    addi t0, t0, 1
    addi t6, t6, 1
    addi t2, t2, 1

    blt  t2, t3, PrintLinha     # coluna < largura?

    # fim de linha: pula restante do display
    li   t5, 320
    sub  t5, t5, t3
    add  t0, t0, t5

    li   t2, 0
    addi t1, t1, 1

    blt  t1, t4, PrintLinha     # linha < altura?

    ret
