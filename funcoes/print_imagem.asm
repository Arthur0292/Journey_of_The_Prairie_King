#Função Print_imagem
#a0 = endereço da imagem
#a1 = frame                                                                
                                  

print_imagem:
li t0, 0xFF0	#Coloco em t0 o endereço base
add t0, t0, a1	#Adiciono com o frame se for 0 = 0xff0 se for 1 = 0xff1
slli t0, t0, 20	#Formato o endereço

mv t6, a0	#Movo para t6 o endereco base da imagem
addi t6, t6, 8
li a3, 320
li a4, 240

li t1, 76800	#Numero de pixels

loop_imagem:

lbu t5, 0(t6)	#le o byte dentro da imagem
sb t5, 0(t0)	#Imprimir a imagem
addi t0, t0, 1
addi t6,t6, 1
addi t1, t1, -1	#numero de pixels--

bgt t1, zero, loop_imagem	#Se for = 0 encerra

ret



