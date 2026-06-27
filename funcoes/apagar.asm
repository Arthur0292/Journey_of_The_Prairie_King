#Função Apagar
#a1 = x                    
#a2 = y                                                  
#a3 = largura                                            
#a4 = altura                                             
#a5 = frame (0 ou 1)                                    

Apagar:

li t0, 0xFF0	#Coloco em t0 o endereco base
add t0, t0, a5	#Adiciono com o frame se for 0 = 0xff0 se for 1 = 0xff1
slli t0, t0, 20	#Formato o endereco

#Calculo para achar o endereço = offset +(y * 320 + x)
li t4, 320		#Armazneo em t4 320
mul t2, a2, t4		#t2 = (320 * y)
add t2, t2, a1		#t2 + x
add t0, t0, t2		# endereco base + (320 * y + x)


sub t3, t4, a3	#Aramzeno em t3 o stride que e 320- 17

li t1, 0		#Contador para as linhas
li t2, 0		#Contador para as colunas

li t6, 118	#Coloco a cor do cenario para imprimir
Apagar_linha:

sb t6, 0(t0)	#Printo o pixel na tela
addi t0, t0, 1	#Adiciono mais 1 para os pixels pintados
addi t2, t2, 1	#colunas++

blt t2, a3, Apagar_linha	#enquanto t2 for menor que a largura

add t0, t0, t3		#Soma t0 + stride
li t2, 0		#Zero as colunas
addi t1, t1, 1		#linhas++

blt t1, a4, Apagar_linha	#enquanto t1 for menor que a altura

ret		#retorno






  
