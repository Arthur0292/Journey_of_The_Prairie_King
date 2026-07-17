#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char nomeJogo[33] = "ONIBUS";  //variaveis globais de nickname e nome do jogo e pontuacao
char nickname[33];
int pontuacao = 0;
int cont = 0;   //contador de fases

void mainJogo();

typedef struct{     //Struct de dados de cada fase
    int quantOnibus;
    int quantLinhas;
    int quantColunas;
    char onibus;
    char termino;
    char ordemOnibus[100];
}fase;

FILE *arq; //Variavel global para o entrada.txt
fase lista[1000];   //Variaveis globais de fase
char linhaMatriz[1000][1000];
char lixo[100];

void limparTela() { //Funcao para limpar a tela
#ifdef _WIN32
    system("cls");
#else
    system("clear");
#endif
}

void telaInicial(){
    limparTela();

    printf("Bem vindo(a) ao Jogo do %s", nomeJogo);
    printf("\n");
    printf("\n");
    printf("Informe seu Nickname: "); // ler o nickname
    scanf("%32s", nickname);
}

int menuPrincipal(){
    limparTela();

    int opcao;  //Variavel de opcao

    printf("*** JOGO DO %s ***\n", nomeJogo);
    printf("\n");
    printf("Bem vindo(a) %s\n", nickname);
    printf("\n");

    printf("1 - Jogar\n");
    printf("2 - Configuracões\n");
    printf("3 - Instrucoes\n");
    printf("4 - Raking\n");
    printf("5 - Sair\n");
    printf("\n");

    printf("Digite a opcao desejada: ");
    scanf("%d", &opcao); //Ler a opcao

    return opcao;   //retorna a opcao digitada
}

void telaInstrucoes(){
    limparTela();

    printf("Instrucoes sobre o jogo do %s\n", nomeJogo);    //Mostra as intrucoes sobre o jogo
    printf("\n");
    printf("aaaa\n");
    printf("\n");

    printf("Tecle <enter> para prosseguir\n");

    getchar();  //Espera a tecla enter ser digitada 
    getchar();

}

void carregarFase(){    //Funcao de carrega o dados da fase

    char c;    
    if(cont == 0){   //Abro o entrada.txt
        arq = fopen("entrada.txt", "r");
    }

    fscanf(arq, "%d", &lista[cont].quantOnibus);  //Quantidade de onibus
    fscanf(arq, "%d", &lista[cont].quantLinhas);  //Quantidade de linhas
    fscanf(arq, "%d", &lista[cont].quantColunas);  //Quantidaade de colunas
    fscanf(arq, "%s", lixo);

    for(int i = 0; i<lista[cont].quantLinhas; i++){ //Leio cada linha da matriz
        fscanf(arq, "%s", linhaMatriz[i]);
    }

    fscanf(arq, "%s", lista[cont].ordemOnibus); //Leio a ordem dos onibus

    fscanf(arq, " %c", &lista[cont].termino); //Leio o F ou U

    
}

void venceu(){  //Funcao quando venceu
    limparTela();

    printf("*** JOGO DO %s ***\n", nomeJogo);
    printf("\n");
    
    printf("**************************************\n");
    printf("**      PARABENS VOCE VENCEU        **\n");
    printf("**                                  **\n");
    printf("**          PONTUACAO: %d          **\n", pontuacao);
    printf("**************************************\n");

    printf("\n");

}

void proximaFase(){  //Funcao de proxima fase
    limparTela();

    pontuacao += 100;
    
    if(lista[cont].termino == 'U'){
        venceu();
        return;
    }

    printf("*** JOGO DO %s ***\n", nomeJogo);
    printf("\n");
    
    printf("**************************************\n");
    printf("**  MUITO BEM VOCE FINALIZOU A FASE **\n");
    printf("**                                  **\n");
    printf("**   Ir para a proxima fase(S/N)    **\n");
    printf("**************************************\n");

    printf("\n");

    char opcao;
    scanf(" %c", &opcao);

    if(opcao == 'S' || opcao == 's'){
        cont++; //Adiciono no contador de fase
        mainJogo(); //Se = S continua 
    }else if(opcao == 'N'|| opcao == 'n'){  //Senao volta para o menu principal
        return;   
    }

}


void perdeuFase(){  //funcao quando perde a fase  
    
    printf("\n");

    printf("*************************************************\n");
    printf("**  COM ESTE MOVIMENTO, LOTOU A FILA DE ESPERA **\n");
    printf("**                PONTUACAO: %d               **\n", pontuacao);
    printf("**                TECLE <ENTER>                **\n");
    printf("*************************************************\n");

    printf("\n");

    pontuacao = 0;  //Zera a pontucao
    cont = 0;

    getchar();
    getchar();

    return;    //Volto para o menu

}


void mainJogo(){    //Funcao principal do jogo
    limparTela(); 
    carregarFase();

    char filaEspera[5][2] = {"_", "_", "_", "_", "_"}; //Fila de espera


    for(int i = 0; i<lista[cont].quantOnibus; i++){
        limparTela();


        char banco1 = ' ';  //Caracteres do banco
        char banco2 = ' ';
        char banco3 = ' ';

        int filaVazia = 0;

        while(banco1 == ' ' || banco2 == ' ' || banco3 == ' '){ //Enquanto os bancos estao vazios repete
            limparTela();

            int bloqueado = 0;

            for(int j = 0; j<5; j++){   //Se algum caracter da fila de espera for = onibus troca para os bancos
                if(filaEspera[j][0] == lista[cont].ordemOnibus[i]){
                    if(banco1 == ' '){  
                        banco1 = filaEspera[j][0];  //Banco = caracter  
                        filaEspera[j][0] = '_';
                        filaEspera[j][1] = '\0';
                    }else if(banco2 == ' '){
                        banco2 = filaEspera[j][0];
                        filaEspera[j][0] = '_';
                        filaEspera[j][1] = '\0';
                    }else if(banco3 == ' '){
                        banco3 = filaEspera[j][0];
                        filaEspera[j][0] = '_';
                        filaEspera[j][1] = '\0';
                    }
                }
            }

            if(banco1 != ' ' && banco2 != ' ' && banco3 != ' '){//Caso todos os bancos tenham sido completos
                break;
            }

            printf("*** JOGO DO %s ***\n", nomeJogo);
            printf("\n");

            printf("PONTUACAO: %d\n", pontuacao);

            
            printf("+----o--------o----+\n");
            printf("|    -    -    -   |-+\n");
            printf("|   |%c   |%c   |%c   |%c|\n", banco1, banco2, banco3, lista[cont].ordemOnibus[i]);
            printf("|    -    -    -   |-+\n");
            printf("+----o---===--o----+\n");

            printf("\n");


            for(int j = 0; j<5; j++){   //Verifica se a fila de espera esta cheia
                if(i == 4){
                    printf("%s\n", filaEspera[j]);
                }else{
                    printf("%s ", filaEspera[j]);
                }
            }

            for(int j = 0; j<5; j++){   //conta quantos bancos vazios na fila de espera
                if(strcmp(filaEspera[j], "_") == 0){
                    filaVazia++;
                }
            }

            printf("\n");
            printf("\n");


            int aux = 1;    //Numero das linhas
            for(int j = 0; j<lista[cont].quantLinhas; j++){ //Imprimi a Matriz
                printf("%d %s\n", aux, linhaMatriz[j]);
                aux++;
            }
            
            for(int i = 1; i<=10; i++){ //Imprimir o Numero das colunas
                if(i == 1){
                    printf("  %d", i);
                }else{
                    printf("%d", i);
                }
            }
            printf("\n");
            printf("\n");

    
            printf("Informe a linha e coluna para embarcar no onibus: ");
        
            int linha, coluna; 

            scanf("%d %d", &linha, &coluna);    //leio a linha e coluna da matriz
            linha--;
            coluna--;

            if(linhaMatriz[linha][coluna] == '_' || linhaMatriz[linha][coluna] == ' ' || coluna > 10 || coluna < 0 || linha >= lista[cont].quantLinhas || linha < 0){   //Caso seja uma parede ou fora da matriz imprimi erro
                printf("Posicao invalida tecle <enter> para voltar\n");
                getchar();
                getchar();
            }else{
                if(linhaMatriz[linha][coluna] == lista[cont].ordemOnibus[i]){   //Se o caracter for = ao onibus
        
                if(linha == 0){ //Se for o primeiro da fila
                    if(banco1 == ' '){  //Verifica qual banco esta livre e troca
                        banco1 = linhaMatriz[linha][coluna];
                        linhaMatriz[linha][coluna] = ' ';   //Troca o caracter dentro da matriz por ' '
                    }else if(banco2 == ' '){
                        banco2 = linhaMatriz[linha][coluna];
                        linhaMatriz[linha][coluna] = ' ';
                    }else if(banco3 == ' '){
                        banco3 = linhaMatriz[linha][coluna];
                        linhaMatriz[linha][coluna] = ' ';
                    }
                }else{
                    if(linhaMatriz[linha - 1][coluna] != ' ' && linhaMatriz[linha][coluna - 1] != ' ' && linhaMatriz[linha][coluna + 1] != ' '){      //Se tiver algum caracter na frente e dos lados retorna erro
                        printf("Elemento bloqueado tecle <enter> para voltar");
                        getchar();
                        getchar();
                    }else{  //Senao verifia aonde esta livre
                        if(linhaMatriz[linha - 1][coluna] == ' ') { //Se for o de cima
                            for(int k = linha - 1; k >= 0; k--){
                                if(linhaMatriz[k][coluna] != ' '){  //Verifica se estao vazias todas linhas da frente
                                    bloqueado++;
                                }
                            }
                        }else if(linhaMatriz[linha][coluna + 1] == ' '){//Se for o da direita
                                for(int k = linha - 1; k >= 0; k--){    //coluna da direita
                                if(linhaMatriz[k][coluna + 1] != ' '){
                                    bloqueado++;
                                }
                            }
                        }else if(linhaMatriz[linha][coluna - 1] == ' '){//Se for o da esquerda
                            for(int k = linha - 1; k >= 0; k--){    //coluna da esuquerda
                                if(linhaMatriz[k][coluna - 1] != ' '){
                                    bloqueado++;
                                }
                            }
                        }

                        if(bloqueado == 0){     //Se nao tiver nenhum caracter bloqueando
                            if(banco1 == ' '){  //Verifica qual banco esta livre e troca
                                banco1 = linhaMatriz[linha][coluna];
                                linhaMatriz[linha][coluna] = ' ';   //Troca o caracter dentro da matriz por ' '
                            }else if(banco2 == ' '){
                                banco2 = linhaMatriz[linha][coluna];
                                linhaMatriz[linha][coluna] = ' ';
                            }else if(banco3 == ' '){
                                banco3 = linhaMatriz[linha][coluna];
                                linhaMatriz[linha][coluna] = ' ';
                            }
                        }else{
                            printf("Elemento bloqueado tecle <enter> para voltar");
                            getchar();
                            getchar();
                        }

                        bloqueado = 0;
                    }
                }
            
            }else{//Se o caracter nao for = onibus

                if(linha == 0){ //Se estiver na primeira linha
                    for(int k = 0; k<5; k++){   //Caso o banco esteja vazio entra nesse banco
                        if(strcmp(filaEspera[k], "_") == 0){
                            filaEspera[k][0] = linhaMatriz[linha][coluna];
                            filaEspera[k][1] = '\0';
                            linhaMatriz[linha][coluna] = ' ';  //Caracter dentro da matriz vira um espaco
                            break;
                        }
                    }

                }else{
                    if(linhaMatriz[linha - 1][coluna] != ' ' && linhaMatriz[linha][coluna + 1] != ' ' && linhaMatriz[linha][coluna - 1] != ' '){      //Se tiver algum caracter na frente e dos lados retorna erro
                        printf("Elemento bloqueado tecle <enter> para voltar");
                        getchar();
                        getchar();
                    }else{
                        if(linhaMatriz[linha - 1][coluna] == ' '){      //Se for o de cima
                            for(int k = linha - 1; k >= 0; k--){    //Verifica todas as linhas de cima
                                if(linhaMatriz[k][coluna] != ' '){
                                    bloqueado++;
                                }
                            }
                        }else if(linhaMatriz[linha][coluna + 1] == ' '){  //Se for o da direita
                            for(int k = linha; k >= 0; k--){    //coluna da esuquerda
                                if(linhaMatriz[k][coluna + 1] != ' '){
                                    bloqueado++;
                                }
                            }
                        }else if(linhaMatriz[linha][coluna - 1]){
                            for(int k = linha - 1; k >= 0; k--){    //coluna da esuquerda
                                if(linhaMatriz[k][coluna - 1] != ' '){
                                    bloqueado++;
                                }
                            }
                        }
                    }

                    if(bloqueado == 0){
                        for(int k = 0; k<5; k++){   //Caso o banco esteja vazio entra nesse banco
                            if(strcmp(filaEspera[k], "_") == 0){
                                filaEspera[k][0] = linhaMatriz[linha][coluna];
                                filaEspera[k][1] = '\0';
                                linhaMatriz[linha][coluna] = ' ';  //Caracter dentro da matriz vira um espaco
                                break;
                            }
                        }
                    }else{  
                        printf("Elemento bloqueado tecle <enter> para voltar");
                        getchar();
                        getchar();
                    }
                
                    bloqueado = 0;
                }
            }
            }

            if(banco1 != ' ' && banco2 != ' ' && banco3 != ' '){
                pontuacao += 15;
            }

            if(filaVazia == 1){ // Se fila vazia retorna 0 perdeu a fase
                perdeuFase();
                filaVazia = 0;
            }

            filaVazia = 0;

        }

    }

    proximaFase();
    
}


void zerarRanking(){ //Funcao para zerar o raking

}

void configuracoes(){   //Mostrar as configuracoes
    limparTela();

    int opcao;

    printf("*** JOGO DO %s ***\n", nomeJogo);
    printf("\n");

    printf("1 - Zerar ranking\n");
    printf("2 - Voltar para o menu\n");
    printf("\n");

    printf("Digite a opcao: ");

    scanf("%d", &opcao); 
    if(opcao == 1){     //Caso 1 = zerar ranking
        zerarRanking();
    }else if(opcao == 2){   //Caso 2 = menu principal
        menuPrincipal();
    }else{  
        printf("Opcao invalida tecle <enter>\n");
        printf("Digite novamente: ");
        scanf("%d", &opcao);
    }
}

int main(){

    int opcao;

    telaInicial();  //Chamo a tela inicial
    
    while(1){

        opcao = menuPrincipal();   //Chamo o menu principal

        if(opcao == 1){
            mainJogo();
        }else if(opcao == 2){
            configuracoes();
        }
        else if(opcao == 3){
            telaInstrucoes();   //Mostra a tela de Instrucoes
        }else if(opcao == 4){
                                //Mostra o Ranking
        }else if(opcao == 5){
            break;      //Caso a opcao =  4 sai do jogo
        }else{
            printf("Opcao Invalida!\n");  //Caso nenhuma das anteriores = opcao invalida
            getchar();
            getchar();  //Espero um tecla seja digitada
        }


    }
    
    return 0;
}
