/* DECLARAÇÕES */

%{
void yyerror (char *s);
int yylex();

#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include "type.h"

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

FILE *sintatica;
FILE *semantica;

int vars[52];
int initializedV[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
void initVar(char var, int val);
int checkVar(char var);

int funcTipo[52];
int declaredF[52];
void initFunc(char func, int tipo);
int checkFunc(char func);
int tipoFunc(char func);

int errosSemanticos;
int valorRetorno;

%}

%union {
	char string;
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
%type <string> param var ativacao ID
%type <integer> expressao simples_expressao soma_expressao termo fator NUM
%type <list> args

%% /* GRAMÁTICA */

programa:
	declaracao_lista
		{ fprintf(sintatica, "Programa com sintática correta!\n"); }
	;
declaracao_lista:
	declaracao_lista declaracao
		{ fprintf(sintatica, "declaracao_lista := declaracao_lista declaracao\n"); }
	| declaracao
		{ fprintf(sintatica, "declaracao_lista := declaracao\n"); }
	;
declaracao:
	var_declaracao
		{ fprintf(sintatica, "declaracao := var_declaracao\n"); }
	| fun_declaracao
		{ fprintf(sintatica, "declaracao := fun_declaracao\n"); }
	;
var_declaracao:
	tipo_especificador ID PV
		{
			fprintf(sintatica, "var_declaracao := tipo_especificador ID PV\n");
			if ($1 == TYPE_VOID) {
				fprintf(semantica, "***ERRO: Variável '%c' declarada como tipo void! Ela não será inicializada.\n", $2);
				errosSemanticos++;
			}
			else {
				initVar($2, 0);
				fprintf(semantica, "Variável '%c' declarada\n", $2);
			}
		}
	| tipo_especificador ID ACO NUM FCO PV
		{
			fprintf(sintatica, "var_declaracao := tipo_especificador ID ACO NUM FCO PV\n");
			if ($1 == TYPE_VOID) {
				fprintf(semantica, "***ERRO: Variável '%c' declarada como tipo void! Ela não será inicializada.\n", $2);
				errosSemanticos++;
			}
			else {
				initVar($2, 0);
				fprintf(semantica, "Variável '%c' declarada\n", $2);
			}
		}
	;
tipo_especificador:
	INT
		{ $$ = TYPE_INT; }
	| VOID
		{ $$ = TYPE_VOID; }
	;
fun_declaracao:
	tipo_especificador ID AP params FP composto_decl
		{
			initFunc($2, $1);
			fprintf(sintatica, "fun_declaracao := tipo_especificador ID AP params FP composto_decl\n");

			if ($1 == TYPE_VOID)
				fprintf(semantica, "Função '%c' declarada como void\n", $2);
			else
				fprintf(semantica, "Função '%c' declarada como int\n", $2);

			/* ERROS */
			if ($1 == TYPE_VOID && valorRetorno == TRUE) {
				fprintf(semantica, "***ERRO: Retornando valor numérico em função '%c' void\n", $2);
				errosSemanticos++;
			}
			else if ($1 == TYPE_INT && valorRetorno == FALSE) {
				fprintf(semantica, "***ERRO: Não retornando valor numérico em função '%c' int\n", $2);
				errosSemanticos++;
			}
			valorRetorno = FALSE;
		}
	;
params:
	param_lista
		{ fprintf(sintatica, "params := param_lista\n"); }
	| VOID
		{ fprintf(sintatica, "params := VOID\n"); }
	;
param_lista:
	param_lista V param
		{ fprintf(sintatica, "param_lista := param_lista V param\n"); }
	| param
		{ fprintf(sintatica, "param_lista := param\n"); }
	;
param:
	tipo_especificador ID
		{
			fprintf(sintatica, "param := tipo_especificador ID\n");
			if ($1 == TYPE_VOID) {
				fprintf(semantica, "***ERRO: Parâmetro '%c' declarada como tipo void!\n", $2);
				errosSemanticos++;
			}
			else {
				initVar($2, 0);
				fprintf(semantica, "Parâmetro '%c' declarado\n", $2);
			}
		}
	| tipo_especificador ID ACO FCO
		{
			fprintf(sintatica, "param := tipo_especificador ID ACO FCO\n");
			if ($1 == TYPE_VOID) {
				fprintf(semantica, "***ERRO: Parâmetro '%c' declarada como tipo void!\n", $2);
				errosSemanticos++;
			}
			else {
				initVar($2, 0);
				fprintf(semantica, "Parâmetro '%c' declarado\n", $2);
			}
		}
	;
composto_decl:
	ACH local_declaracoes statement_lista FCH
		{ fprintf(sintatica, "composto_decl := ACH local_declaracoes statement_lista FCH\n"); }
	;
local_declaracoes:
	local_declaracoes var_declaracao
		{ fprintf(sintatica, "local_declaracoes := local_declaracoes var_declaracao\n"); }
	| /* vazio */
		{ fprintf(sintatica, "local_declaracoes := \n"); }
	;
statement_lista:
	statement_lista statement
		{ fprintf(sintatica, "statement_lista := statement_lista statement\n"); }
	| /* vazio */
		{ fprintf(sintatica, "statement_lista := \n"); }
	;
statement:
	expressao_decl
		{ fprintf(sintatica, "statement := expressao_decl\n"); }
	| composto_decl
		{ fprintf(sintatica, "statement := composto_decl\n"); }
	| selecao_decl
		{ fprintf(sintatica, "statement := selecao_decl\n"); }
	| iteracao_decl
		{ fprintf(sintatica, "statement := iteracao_decl\n"); }
	| retorno_decl
		{ fprintf(sintatica, "statement := retorno_decl\n"); }
	;
expressao_decl:
	expressao PV
		{ fprintf(sintatica, "expressao_decl := expressao PV\n"); }
	| PV
		{ fprintf(sintatica, "expressao_decl := PV\n"); }
	;
selecao_decl:
	IF AP expressao FP statement
		{ fprintf(sintatica, "selecao_decl := IF AP expressao FP statement\n"); }
	| IF AP expressao FP statement ELSE statement
		{ fprintf(sintatica, "selecao_decl := IF AP expressao FP statement ELSE statement\n"); }
	;
iteracao_decl:
	WHILE AP expressao FP statement
		{ fprintf(sintatica, "iteracao_decl := WHILE AP expressao FP statement\n"); }
	;
retorno_decl:
	RETURN PV
		{
			fprintf(sintatica, "retorno_decl := RETURN PV\n");
			valorRetorno = FALSE;
		}
	| RETURN expressao PV
		{
			fprintf(sintatica, "retorno_decl := RETURN expressao PV\n");
			valorRetorno = TRUE;
		}
	;
expressao:
	var ATRIB expressao
		{
			if (checkVar($1) == TRUE) {
				updateSymbolVal($1, $3);
				fprintf(sintatica, "expressao := var ATRIB expressao\n");
				fprintf(semantica, "Atribuindo '%d' à variável '%c'\n", $3, $1);
			}
			else {
				fprintf(semantica, "***ERRO: Tentando atribuir valor à variável não inicializada '%c'\n", $1);
				errosSemanticos++;
			}
		}
	| simples_expressao
		{ fprintf(sintatica, "expressao := simples_expressao\n"); }
	;
var:
	ID
		{
			fprintf(sintatica, "var := ID\n");
			if (checkVar($1) == FALSE) {
				fprintf(semantica, "***ERRO: Tentando acessar variável '%c' não inicializada\n", $1);
				errosSemanticos++;
			}
			$$ = $1;
		}
	| ID ACO expressao FCO
		{
			fprintf(sintatica, "var := ID ACO expressao FCO\n");
			if (checkVar($1) == FALSE) {
				fprintf(semantica, "***ERRO: Tentando acessar variável '%c' não inicializada\n", $1);
				errosSemanticos++;
			}
			$$ = $1;
		}
	;
simples_expressao:
	soma_expressao MEIGUAL soma_expressao
		{
			$$ = ($1 <= $3) ? 1 : 0;
			fprintf(sintatica, "simples_expressao := soma_expressao <= soma_expressao\n");
		}
	| soma_expressao MENOR soma_expressao
		{
			$$ = ($1 < $3) ? 1 : 0;
			fprintf(sintatica, "simples_expressao := soma_expressao < soma_expressao\n");
		}
	| soma_expressao MAIOR soma_expressao
		{
			$$ = ($1 > $3) ? 1 : 0;
			fprintf(sintatica, "simples_expressao := soma_expressao > soma_expressao\n");
		}
	| soma_expressao MAIGUAL soma_expressao
		{
			$$ = ($1 >= $3) ? 1 : 0;
			fprintf(sintatica, "simples_expressao := soma_expressao >= soma_expressao\n");
		}
	| soma_expressao IGUAL soma_expressao
		{
			$$ = ($1 == $3) ? 1 : 0;
			fprintf(sintatica, "simples_expressao := soma_expressao == soma_expressao\n");
		}
	| soma_expressao DIF soma_expressao
		{
			$$ = ($1 != $3) ? 1 : 0;
			fprintf(sintatica, "simples_expressao := soma_expressao != soma_expressao\n");
		}
	| soma_expressao
	;
soma_expressao:
	soma_expressao SOMA termo
		{
			$$ = $1 + $3;
			fprintf(sintatica, "soma_expressao := soma_expressao + termo\n");
		}
	| soma_expressao SUB termo
		{
			$$ = $1 - $3;
			fprintf(sintatica, "soma_expressao := soma_expressao - termo\n");
		}
	| termo
		{
			$$ = $1;
			fprintf(sintatica, "soma_expressao := termo\n");
		}
	;
termo:
	termo MUL fator
		{
			$$ = $1 * $3;
			fprintf(sintatica, "termo := termo * fator\n");
		}
	| termo DIV fator
		{
			if ($3 == 0) {
				$$ = $1; // divisão não é feita
				fprintf(semantica, "***ERRO: Tentativa de divisão por 0! Divisão será ignorada.\n");
				errosSemanticos++;
			}
			else {
				$$ = $1 / $3;
				fprintf(sintatica, "termo := termo / fator\n");
			}
		}
	| fator
		{
			$$ = $1;
			fprintf(sintatica, "termo := fator\n");
		}
	;
fator:
	AP expressao FP
		{
			$$ = $2;
			fprintf(sintatica, "fator := AP expressao FP\n");
		}
	| var
		{
			$$ = symbolVal($1);
			fprintf(sintatica, "fator := var\n");
		}
	| ativacao
		{
			fprintf(sintatica, "fator := ativacao\n");
		}
	| NUM
		{
			$$ = $1;
			fprintf(sintatica, "fator := NUM\n");
		}
	;
ativacao:
	ID AP args FP
		{
			fprintf(sintatica, "ativacao := ID AP args FP\n");

			if (checkFunc($1) == FALSE) {
				fprintf(semantica, "***ERRO: Tentando acessar função '%c' não inicializada!\n", $1);
				errosSemanticos++;
			}
			else {
				fprintf(semantica, "Executando função '%c'\n", $1);
			}

			$$ = $1; // repassar nome da função a 'ativacao'
		}
	;
args:
	args V expressao
		{ fprintf(sintatica, "args := args V expressao\n"); }
	| expressao
		{ fprintf(sintatica, "args := expressao\n"); }
	| /* vazio */
		{ fprintf(sintatica, "args :=\n"); }
	;

%% /* CÓDIGO C */

int computeSymbolIndex(char token) {
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
}

// Funções auxiliares para variáveis
int symbolVal(char symbol) {
	int bucket = computeSymbolIndex(symbol);
	return vars[bucket];
}

void updateSymbolVal(char symbol, int val) {
	int bucket = computeSymbolIndex(symbol);
	vars[bucket] = val;
}

void initVar(char var, int val) {
	int bucket = computeSymbolIndex(var);
	initializedV[bucket] = TRUE;
	vars[bucket] = val;
}

int checkVar(char var) {
	int bucket = computeSymbolIndex(var);
	return (initializedV[bucket] == TRUE ? TRUE : FALSE);
}

// Funções auxiliares para funções
void initFunc(char func, int tipo) {
	int bucket = computeSymbolIndex(func);
	declaredF[bucket] = TRUE;
	funcTipo[bucket] = tipo;
}

int checkFunc(char func) {
	int bucket = computeSymbolIndex(func);
	return (declaredF[bucket] == TRUE ? TRUE : FALSE);
}

int tipoFunc(char func) {
	int bucket = computeSymbolIndex(func);
	return (funcTipo[bucket] == TYPE_INT ? TYPE_INT : TYPE_VOID);
}


int main (void) {
	sintatica = fopen("sintatica.txt", "w");
	semantica = fopen("semantica.txt", "w");

	valorRetorno = FALSE;
	errosSemanticos = 0;

	/* tabela de símbolos */
	int i;
	for(i=0; i<52; i++) {
		vars[i] = 0;
		initializedV[i] = FALSE;

		funcTipo[i] = 0;
		declaredF[i] = FALSE;
	}

	yyparse ();

	fprintf(semantica, "\nAnálise semântica encerrada com '%d' erros\n", errosSemanticos);

	fclose(sintatica);
	fclose(semantica);

	return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
