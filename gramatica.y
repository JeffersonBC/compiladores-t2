%{

#include "ast.h"
#include "list.h"
#include "type.h"
#include "ast_cons.h"
#include <stdio.h>

void yyerror (char *s);
int yylex();

list* program = 0;

%}


%token VOID INT
%token ELSE IF RETURN WHILE 
%token ID NUM
%token ATRIB MUL DIV SOMA SUB					// = * / + -
%token IGUAL DIF MAIOR MAIGUAL MENOR MEIGUAL	// = != > >= < <=
%token V PV ACO FCO AP FP ACH FCH 				// , ; [ ] ( ) { }

%type <list> programa
%type <list> declaracao_lista
%type <ast> declaracao
%type <ast> var_declaracao
%type <type> tipo_especificador
%type <ast> fun_declaracao
%type <list> params
%type <list> param_lista
%type <ast> param
%type <ast> composto_decl
%type <list> local_declaracoes
%type <list> statement_lista
%type <ast> statement
%type <ast> expressao_decl
%type <ast> selecao_decl
%type <ast> iteracao_decl
%type <ast> retorno_decl
%type <ast> expressao
%type <ast> var
%type <ast> simples_expressao
%type <ast> soma_expressao
%type <ast> termo
%type <ast> fator
%type <ast> ativacao
%type <list> args
%type <string> ID
%type <integer> NUM
%type <type> VOID INT


%start programa
%%
    programa: 
		  declaracao_lista						
			{ programa = $1; }
		;
    declaracao_lista: 
		  declaracao_lista declaracao 	
			{ $$ = append_list($1, single_list($2)); }
		| declaracao								
	        { $$ = single_list($1); }
		;
    declaracao: 
		  var_declaracao 						
		| fun_declaracao							
		;
    var_declaracao: 
		tipo_especificador ID PV 		
			{ $$ = var_decl($1, $2, 0, 0); }
		| tipo_especificador ID ACO NUM FCO PV		
			{ $$ = var_decl($1, $2, $4, 1); }
		;
    tipo_especificador: 
		INT 						
			{ $$ = TYPE_INT; }
		| VOID										
			{ $$ = TYPE_VOID; }
        ;
    fun_declaracao: 
		tipo_especificador ID AP params FP composto_decl	
			{ $$ = function($1, $2, $4, $6); }
		;
    params: 
		param_lista
		| /* vazio */															
			{ $$ = nil_list(); }
        ;
    param_lista: 
		param_lista V param 									
			{ $$ = append_list($1, single_list($3)); }
		| param															
			{ $$ = single_list($1); }
        ;
    param: 
		tipo_especificador ID 										
			{ $$ = param($1, $2, 0); }
		| tipo_especificador ID ACO FCO								
			{ $$ = param($1, $2, 1); }
        ;
    composto_decl: 
		ACH local_declaracoes statement_lista FCH	
			{ $$ = compound_stmt($2, $3); }
		;
    local_declaracoes: 
		local_declaracoes var_declaracao 		
			{ $$ = append_list($1, single_list($2)); }
		| /* vazio */												
			{ $$ = nil_list(); }
        ;
    statement_lista: 
		statement_lista statement 		
			{ $$ = append_list($1, single_list($2)); }
		| /* vazio */										
			{ $$  = nil_list(); }
        ;
    statement: 
		expressao_decl 							
		| composto_decl 								
		| selecao_decl 									
		| iteracao_decl 								
		| retorno_decl									
        ;
    expressao_decl: 
		expressao PV
		| PV											
			{ $$ = NULL; }
        ;
    selecao_decl: 
		IF AP expressao FP statement 			
			{ $$ = if_then($3, $5, NULL); }
		| IF AP expressao FP statement ELSE statement	
			{ $$ = if_then($3, $5, $7); }
        ;
    iteracao_decl: 
		WHILE AP expressao FP statement		
			{ $$ = while_loop($3, $5); }
		;
    retorno_decl: 
		RETURN PV 							
			{ $$ = ret(NULL); }
		| RETURN expressao PV							
			{ $$ = ret($2); }
        ;
    expressao: 
		var ATRIB expressao 						
			{ $$ = assign($1, $3); }
		| simples_expressao
        ;
    var: 
		ID 											
			{ $$ = variable($1); }
		| ID ACO expressao FCO							
			{ $$ = access($1, $3); }
        ;
    simples_expressao: 
		soma_expressao MEIGUAL soma_expressao 
			{ $$ = lt($1, $3); }
		| soma_expressao MENOR soma_expressao 
			{ $$ = lte($1, $3); }
		| soma_expressao MAIOR soma_expressao 
			{ $$ = gt($1, $3); }
		| soma_expressao MAIGUAL soma_expressao 
			{ $$ = gte($1, $3); }
		| soma_expressao IGUAL soma_expressao 
			{ $$ = eq($1, $3); }
		| soma_expressao DIF soma_expressao 
			{ $$ = neq($1, $3); }
		| soma_expressao
        ;
    soma_expressao: 
		soma_expressao SOMA termo 	
			{ $$ = add($1, $3); }
		| soma_expressao SUB termo 	
			{ $$ = sub($1, $3); }
		| termo
        ;
    termo: 
		termo MUL fator 			
			{ $$ = mul($1, $3); }
		| termo DIV fator 			
			{ $$ = divide($1, $3); }
		| fator
        ;
    fator:  
		AP expressao FP 			
			{ $$ = $2; }
		| var
		| ativacao
		| NUM							
			{ $$ = num($1); }
        ;
    ativacao:
		ID AP args FP			
			{ $$ = call($1, $3); }
		;
    args: 
		args V expressao 
			{ $$ = append_list($1, single_list($3)); }
		| expressao						
			{ $$ = single_list($1); }
		| /* vazio */							
			{ $$ = nil_list(); }
        ;
%%

int main (void) {
	return yyparse ( );
}

void yyerror(char* err, ...) {
	fprintf(stderr, "%s\n", err);
}
