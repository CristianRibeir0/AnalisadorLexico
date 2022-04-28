
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void adc_tabela(char* tk, char* val);
void persiste_tabela();

typedef struct Obj{
    int lin;
    int col;
    char* token;
    char* valor;
    struct Obj* prox;
}obj;

int coluna = 1;
int linha = 1;
obj* tabela;
obj** aux;

%}

RESERVADA (int|float|string|if|else|while|void|printf)
DIGITO [0-9]
LETRA [a-zA-Z]
LITERAL \"[^\"]*\"
NUMERAL {DIGITO}+([.]{DIGITO}+)?
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
COMENTARIO1 (\/\/.*)
COMENTARIO ("/*"((("*"[^/])?)|[^*])*"*/")
OP_INC {OP_SUM}{OP_SUM}
OP_SUM [+]
OP_SUB [-]
OP_DEC ({OP_SUB}{OP_SUB})
OP_MUL [*]
OP_DIV \/
OP_POW [**]
OP_EQ [=] 
OP_AND [&&]
OP_OR \|\|
OP_MA [\>]
OP_MI [<]
OP_MAEQ {OP_MA}{OP_EQ}
OP_MIEQ [<=]
OP_EQEQ [==]
OP_ARIT({OP_EQ}|{OP_INC}|{OP_DEC}|{OP_SUM}|{OP_SUB}|{OP_MUL}|{OP_DIV})
OP_LOGI({OP_MAEQ}|{OP_MIEQ}|{OP_EQEQ}|{OP_AND}|{OP_OR}|{OP_MA}|{OP_MI})
ESP [\ ]
SEPARADOR [\ \t\n,;}{\(\)]
SEPARADOR_OP({SEPARADOR}|{DIGITO}|{LETRA})
SEPARADOR_NUM({SEPARADOR}|{OP_ARIT}|{OP_LOGI})
ERROR .

%%
\n {coluna=1;linha++;}



{ESP} {coluna++;}
{SEPARADOR} {adc_tabela("SEPARADOR", yytext); coluna++;}

{COMENTARIO1} {coluna+=strlen(yytext);    
}

{RESERVADA}/{SEPARADOR} {adc_tabela("RESERVADA", yytext); coluna+=strlen(yytext);    
}

{IDENTIFICADOR}/{SEPARADOR_NUM} {adc_tabela("IDENTIFICADOR", yytext); coluna+=strlen(yytext);    
}

{NUMERAL}/{SEPARADOR_NUM} {adc_tabela("NUMERAL", yytext); coluna+=strlen(yytext);    
}
{LITERAL}/{SEPARADOR} {adc_tabela("LITERAL", yytext); coluna+=strlen(yytext);    
}
{OP_ARIT}/{SEPARADOR_OP} {adc_tabela("OP_ARIT", yytext); coluna+=strlen(yytext);    
}
{OP_LOGI}/{SEPARADOR_OP} {adc_tabela("OP_LOGI", yytext);}


. {printf("\nCharacter n reconhecido: |%s|\ncoluna: %d\nlinha: %d\n", yytext, coluna, linha); coluna+=1;}
%%

int main(int argc, char* argv[]){
    tabela = (obj*) calloc(1, sizeof(obj));
    aux = &(tabela->prox);
    
    	if(argc > 1)
	{
		FILE *fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
	}
	yylex();
	return 1;
}


void adc_tabela(char* tk, char* val){
    obj* obj_atual = (obj*) calloc(1, sizeof(obj));
    obj_atual->col= coluna;
    obj_atual->lin= linha;
    obj_atual->token = (char*) calloc(15, sizeof(char));
    if((strcmp(tk, "string") != 0) || (strcmp(tk, "comentario") != 0)){
        obj_atual->valor = (char*) calloc(15, sizeof(char));
    }
    else{
        obj_atual->valor = (char*) calloc(50, sizeof(char));
    }
    strcpy(obj_atual->token, tk);
    strcpy(obj_atual->valor, val);
    (*aux) = obj_atual;
    aux = &(obj_atual->prox);
}

void persiste_tabela(){
    FILE* saida = fopen("saida.txt", "w");
    obj* atual = tabela->prox;
    while(atual != NULL){
        fprintf(saida,"%s %s %d %d\n",atual->token, atual->valor, atual->lin, atual->col);
        atual = atual->prox;
    }
}