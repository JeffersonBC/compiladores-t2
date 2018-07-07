%{
#include "type.h"
#include <stdio.h>

void yyerror(char* err, ...);
int yylex();

%}

%union {
	struct AST;
    struct list;

	struct AST* ast;
	struct list* list;
	char* string;
	int integer;
	int type;
};

%token VOID INT
%token ELSE IF RETURN WHILE
%token ID NUM
%token ATRIB MUL DIV SOMA SUB					// = * / + -
%token IGUAL DIF MAIOR MAIGUAL MENOR MEIGUAL	// = != > >= < <=
%token V PV ACO FCO AP FP ACH FCH 				// , ; [ ] ( ) { }

%type <list> programa
%type <list> declaracao_lista
// %type <> declaracao
// %type <> var_declaracao
%type <type> tipo_especificador
// %type <> fun_declaracao
%type <list> params
%type <list> param_lista
%type <string> param
// %type <> composto_decl
%type <list> local_declaracoes
%type <list> statement_lista
// %type <> statement
// %type <> expressao_decl
// %type <> selecao_decl
// %type <> iteracao_decl
// %type <> retorno_decl
%type <integer> expressao
// %type <> var
%type <integer> simples_expressao
%type <integer> soma_expressao
%type <integer> termo
%type <integer> fator
// %type <> ativacao
%type <list> args
%type <string> ID
%type <integer> NUM
%type <type> VOID INT


%start programa
%%
	programa:
		declaracao_lista
			{}
		;
	declaracao_lista:
		declaracao_lista declaracao
			{}
		| declaracao
			{}
		;
	declaracao:
		var_declaracao
			{}
		| fun_declaracao
			{}
		;
	var_declaracao:
		tipo_especificador ID PV
			{}
		| tipo_especificador ID ACO NUM FCO PV
			{}
		;
	tipo_especificador:
		INT
			{ $$ = TYPE_INT; }
		| VOID
			{ $$ = TYPE_VOID; }
		;
	fun_declaracao:
		tipo_especificador ID AP params FP composto_decl
			{}
		;
	params:
		param_lista
			{}
		| VOID
			{}
		;
	param_lista:
		param_lista V param
			{}
		| param
			{}
		;
	param:
		tipo_especificador ID
			{}
		| tipo_especificador ID ACO FCO
			{}
		;
	composto_decl:
		ACH local_declaracoes statement_lista FCH
			{}
		;
	local_declaracoes:
		local_declaracoes var_declaracao
			{}
		| /* vazio */
			{}
		;
	statement_lista:
		statement_lista statement
			{}
		| /* vazio */
			{}
		;
	statement:
		expressao_decl
			{}
		| composto_decl
			{}
		| selecao_decl
			{}
		| iteracao_decl
			{}
		| retorno_decl
			{}
		;
	expressao_decl:
		expressao PV
			{}
		| PV
			{}
		;
	selecao_decl:
		IF AP expressao FP statement
			{}
		| IF AP expressao FP statement ELSE statement
			{}
		;
	iteracao_decl:
		WHILE AP expressao FP statement
			{}
		;
	retorno_decl:
		RETURN PV
			{}
		| RETURN expressao PV
			{}
		;
	expressao:
		var ATRIB expressao
			{}
		| simples_expressao
			{}
		;
	var:
		ID
			{}
		| ID ACO expressao FCO
			{}
		;
	simples_expressao:
		soma_expressao MEIGUAL soma_expressao
			{ $$ = ($1 <= $3) ? 1 : 0; }
		| soma_expressao MENOR soma_expressao
			{ $$ = ($1 < $3) ? 1 : 0; }
		| soma_expressao MAIOR soma_expressao
			{ $$ = ($1 > $3) ? 1 : 0; }
		| soma_expressao MAIGUAL soma_expressao
			{ $$ = ($1 >= $3) ? 1 : 0; }
		| soma_expressao IGUAL soma_expressao
			{ $$ = ($1 == $3) ? 1 : 0; }
		| soma_expressao DIF soma_expressao
			{ $$ = ($1 != $3) ? 1 : 0; }
		| soma_expressao
		;
	soma_expressao:
		soma_expressao SOMA termo
			{ $$ = $1 + $3; }
		| soma_expressao SUB termo
			{ $$ = $1 - $3; }
		| termo
			{ $$ = $1; }
		;
	termo:
		termo MUL fator
			{ $$ = $1 * $3; }
		| termo DIV fator
			{ $$ = $1 / $3; }
		| fator
			{ $$ = $1; }
		;
	fator:
		AP expressao FP
			{ $$ = $2; }
		| var
			{}
		| ativacao
			{}
		| NUM
			{ $$ = $1; }
		;
	ativacao:
		ID AP args FP
			{}
		;
	args:
		args V expressao
			{}
		| expressao
			{}
		| /* vazio */
			{}
		;
%%

int main (void) {
	return yyparse ();
}

void yyerror(char* err, ...) {
	fprintf(stderr, "%s\n", err);
}
