.data
#Numero de notas
NUM:
.word

NOTAS:

.text

la s0, NUM	#define o endereco das notas
lw s1, 0(s0)	#le o numero de notas
la s0, NOTAS	#define o endereco das notas
li t0, 0	#contador
li a2, 0	#instrumento
li a3, 120	#volume

loop:
beq t0,s1, fim	#fim do loop
lw a0, 0(s0)	#le o valor da nota
lw a1, 4(s0)	#le a duracao das notas
li a7, 31	#define a chamada syscall
ecall
mv a0, a1	#passa a duracao da nota para a pausa
li a7, 32	#define a chamada syscall
ecall
addi s0, s0, 8	#incrementa para o endereco da proxima nota
addi t0, t0, 1	#incrementa o contador de notas
j loop		#volta para o loop

fim:
li a7, 10	#fim
ecalls






