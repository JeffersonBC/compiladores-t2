/* DECLARAÇÕES */

%{
void yyerror (char *s);
int yylex();

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "type.h"

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

int symbols[52];
int symbolVal(char symbol);
int initialized[52];
void updateSymbolVal(char symbol, int val);
%}

%union {
	char* string;
	int integer;
	int type;
	char none;
};

%start programa

%token VOID INT
%token ELSE IF RETURN WHILE
%token ID NUM
%token ATRIB MUL DIV SOMA SUB					// = * / + -
%token IGUAL DIF MAIOR MAIGUAL MENOR MEIGUAL	// = != > >= < <=
%token V PV ACO FCO AP FP ACH FCH 				// , ; [ ] ( ) { }

%type <list> programa declaracao_lista
%type <type> tipo_especificador VOID INT
%type <list> params
%type <list> param_lista
%type <string> param ID
%type <integer> expressao simples_expressao soma_expressao termo fator NUM
%type <list> args

%% /* GRAMÁTICA */

programa:
	declaracao_lista
		{ printf("Programa\n"); }
	;
declaracao_lista:
	declaracao_lista declaracao
		{ printf("declaracao_lista := declaracao_lista declaracao\n"); }
	| declaracao
		{ printf("declaracao_lista := declaracao\n"); }
	;
declaracao:
	var_declaracao
		{ printf("declaracao := var_declaracao\n"); }
	| fun_declaracao
		{ printf("declaracao := fun_declaracao\n"); }
	;
var_declaracao:
	tipo_especificador ID PV
		{ printf("var_declaracao := tipo_especificador ID PV\n"); }
	| tipo_especificador ID ACO NUM FCO PV
		{ fprintf(stdin, "var_declaracao := tipo_especificador ID ACO NUM FCO PV\n"); }
	;
tipo_especificador:
	INT
		{ $$ = TYPE_INT; }
	| VOID
		{ $$ = TYPE_VOID; }
	;
fun_declaracao:
	tipo_especificador ID AP params FP composto_decl
		{ printf("fun_declaracao := tipo_especificador ID AP params FP composto_decl\n"); }
	;
params:
	param_lista
		{ printf("params := param_lista\n"); }
	| VOID
		{ printf("params := VOID\n"); }
	;
param_lista:
	param_lista V param
		{ printf("param_lista := param_lista V param\n"); }
	| param
		{ printf("param_lista := param\n"); }
	;
param:
	tipo_especificador ID
		{ printf("param := tipo_especificador ID\n"); }
	| tipo_especificador ID ACO FCO
		{ printf("param := tipo_especificador ID ACO FCO\n"); }
	;
composto_decl:
	ACH local_declaracoes statement_lista FCH
		{ printf("composto_decl := ACH local_declaracoes statement_lista FCH\n"); }
	;
local_declaracoes:
	local_declaracoes var_declaracao
		{ printf("local_declaracoes := local_declaracoes var_declaracao\n"); }
	| /* vazio */
		{ printf("local_declaracoes := \n"); }
	;
statement_lista:
	statement_lista statement
		{ printf("statement_lista := statement_lista statement\n"); }
	| /* vazio */
		{ printf("statement_lista := \n"); }
	;
statement:
	expressao_decl
		{ printf("statement := expressao_decl\n"); }
	| composto_decl
		{ printf("statement := composto_decl\n"); }
	| selecao_decl
		{ printf("statement := selecao_decl\n"); }
	| iteracao_decl
		{ printf("statement := iteracao_decl\n"); }
	| retorno_decl
		{ printf("statement := retorno_decl\n"); }
	;
expressao_decl:
	expressao PV
		{ printf("expressao_decl := expressao PV\n"); }
	| PV
		{ printf("expressao_decl := PV\n"); }
	;
selecao_decl:
	IF AP expressao FP statement
		{ printf("selecao_decl := IF AP expressao FP statement\n"); }
	| IF AP expressao FP statement ELSE statement
		{ printf("selecao_decl := IF AP expressao FP statement ELSE statement\n"); }
	;
iteracao_decl:
	WHILE AP expressao FP statement
		{ printf("iteracao_decl := WHILE AP expressao FP statement\n"); }
	;
retorno_decl:
	RETURN PV
		{ printf("retorno_decl := RETURN PV\n"); }
	| RETURN expressao PV
		{ printf("retorno_decl := RETURN expressao PV\n"); }
	;
expressao:
	var ATRIB expressao
		{ printf("expressao := var ATRIB expressao\n"); }
	| simples_expressao
		{ printf("expressao := simples_expressao\n"); }
	;
var:
	ID
		{ printf("var := ID\n"); }
	| ID ACO expressao FCO
		{ printf("var := ID ACO expressao FCO\n"); }
	;
simples_expressao:
	soma_expressao MEIGUAL soma_expressao
		{
			$$ = ($1 <= $3) ? 1 : 0;
			printf("simples_expressao := soma_expressao MEIGUAL soma_expressao\n");
		}
	| soma_expressao MENOR soma_expressao
		{
			$$ = ($1 < $3) ? 1 : 0;
			printf("simples_expressao := soma_expressao MEIGUAL soma_expressao\n");
		}
	| soma_expressao MAIOR soma_expressao
		{
			$$ = ($1 > $3) ? 1 : 0;
			printf("simples_expressao := soma_expressao MEIGUAL soma_expressao\n");
		}
	| soma_expressao MAIGUAL soma_expressao
		{
			$$ = ($1 >= $3) ? 1 : 0;
			printf("simples_expressao := soma_expressao MEIGUAL soma_expressao\n");
		}
	| soma_expressao IGUAL soma_expressao
		{
			$$ = ($1 == $3) ? 1 : 0;
			printf("simples_expressao := soma_expressao MEIGUAL soma_expressao\n");
		}
	| soma_expressao DIF soma_expressao
		{
			$$ = ($1 != $3) ? 1 : 0;
			printf("simples_expressao := soma_expressao MEIGUAL soma_expressao\n");
		}
	| soma_expressao
	;
soma_expressao:
	soma_expressao SOMA termo
		{
			$$ = $1 + $3;
			print("soma_expressao := soma_expressao SOMA termo\n");
		}
	| soma_expressao SUB termo
		{
			$$ = $1 - $3;
			print("soma_expressao := soma_expressao SUB termo\n");
		}
	| termo
		{
			$$ = $1;
			print("soma_expressao := termo\n");
		}
	;
termo:
	termo MUL fator
		{
			$$ = $1 * $3;
			printf("termo := termo MUL fator\n");
		}
	| termo DIV fator
		{
			$$ = $1 / $3;
			printf("termo := termo DIV fator\n");
		}
	| fator
		{
			$$ = $1;
			printf("termo := fator\n");
		}
	;
fator:
	AP expressao FP
		{
			$$ = $2;
			printf("fator := AP expressao FP\n");
		}
	| var
		{
			printf("fator := var\n");
		}
	| ativacao
		{
			printf("fator := ativacao\n");
		}
	| NUM
		{
			$$ = $1;
			printf("fator := NUM\n");
		}
	;
ativacao:
	ID AP args FP
		{ printf("ativacao := ID AP args FP\n"); }
	;
args:
	args V expressao
		{ printf("args := args V expressao\n"); }
	| expressao
		{ printf("args := expressao\n"); }
	| /* vazio */
		{ printf("args :=\n"); }
	;

%% /* CÓDIGO C */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
}

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

void initVar(char var, int val) {
	int bucket = computeSymbolIndex(var);
	initialized[bucket] = TRUE;
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
		initialized[i] = FALSE;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
