##############################################################
#                   Função: Apagar                           #
#                                                            #
#   Apaga região em UM frame específico (o de trabalho).    #
#                                                            #
#   a1 = x                                                  #
#   a2 = y                                                  #
#   a3 = largura                                            #
#   a4 = altura                                             #
#   a5 = frame (0 ou 1)                                     #
#                                                            #
#   t0 = endereço no frame                                  #
#   t1 = contador de linha                                  #
#   t2 = contador de coluna                                 #
#   t3 = stride restante (320 - largura)                    #
#   t4 = auxiliar                                           #
##############################################################

Apagar:
    # 1. Endereço base do frame (mesmo cálculo do Print)
    li   t0, 0xFF0
    add  t0, t0, a5             # 0xFF0 + frame
    slli t0, t0, 20             # 0xFF000000 ou 0xFF100000

    # 2. Offset = y * 320 + x
    li   t4, 320
    mul  t4, t4, a2
    add  t0, t0, t4
    add  t0, t0, a1

    # 3. stride = 320 - largura
    li   t3, 320
    sub  t3, t3, a3

    li   t1, 0                  # linha
    li   t2, 0                  # coluna

ApagarLinha:
    sb   zero, 0(t0)

    addi t0, t0, 1
    addi t2, t2, 1

    blt  t2, a3, ApagarLinha    # coluna < largura?

    add  t0, t0, t3             # pula resto da linha
    li   t2, 0
    addi t1, t1, 1

    blt  t1, a4, ApagarLinha    # linha < altura?

    ret
