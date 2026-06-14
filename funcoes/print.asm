#Função Print
#a0 = endereço do sprite/imagem
#a1 = x                    
#a2 = y                                                  
#a3 = largura                                            
#a4 = altura                                             
#a5 = frame (0 ou 1)                                    


Print:

li t0, 0xFF0	#Coloco em t0 o endereço base
add t0, t0, a5	#Adiciono com o frame se for 0 = 0xff0 se for 1 = 0xff1
slli t0, t0, 20	#Formato o endereço

#Calculo para achar o endereço = offset +(y * 320 + x)
li t1, 320		#Armazneo em t4 320
mul t1, a2, t1		#t1 = (320 * y)
add t1, t1, a1		#t2 + x
add t0, t0, t1		# endereco base + (320 * y + x)

mv t6, a0	#Movo para t6 o endereco base do sprite

li t5, 320
sub t3, t5, a3	#Aramzeno em t3 o stride que e 320 - 17

li t1, 0	#Contador de linha e coluna
li t2, 0

PrintLinha:

lbu t5, 0(t6)	#le o byte dentro do sprite
sb t5, 0(t0)	#Imprimir o sprite
addi t0, t0, 1
addi t2, t2, 1	#Colunas++
addi t6, t6, 1	#Pulo para o proximo byte

blt t2, a3, PrintLinha

add t0, t0, t3	#Movendo t0 = t0 + stride
li t2, 0	#Colunas = 0
addi t1, t1, 1	#Linhas++

blt t1, a4, PrintLinha

ret







