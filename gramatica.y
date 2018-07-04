%token <string> ID INT NUM Void IF Else Return While

%token <string> ATRIB MUL DIV SOMA SUB

%token <string> IGUAL DIF MAIOR MAIGUAL MENOR MEIGUAL

%token <string> V PV ACO FCO AP FP ACH FCH

%token <string> vazio

%start programa
%%
    programa: declaracao-lista;
    declaracao-lista: declaracao-lista declaracao 
		| declaracao
		;
    declaracao: var-declaracao 
		| fun-declaracao
		;
    var-declaracao: tipo-especificador ID PV 
		| tipo-especificador ID ACO NUM FCO PV
		;
    tipo-especificador: INT 
		| Void
        ;
    fun-declaracao: tipo-especificador ID AP params FP composto-decl;
    params: param-lista 
		| Void
        ;
    param-lista: param-lista V param 
		| param
        ;
    param: tipo-especificador ID 
		| tipo-especificador ID ACO  FCO
        ;
    composto-decl: ACH local-declaracoes statement-lista FCH;
    local-declaracoes: local-declaracoes var-declaracao 
		| vazio
        ;
    statement-lista: statement-lista statement 
		| vazio
        ;
    statement: expressao-decl 
		| composto-decl 
		| selecao-decl 
		| iteracao-decl 
		| retorno-decl
        ;
    expressao-decl: expressao PV 
		| PV
        ;
    selecao-decl: IF AP expressao FP statement 
		| IF AP expressao FP statement Else statement
        ;
    iteracao-decl: While AP expressao FP statement;
    retorno-decl: Return PV 
		| Return expressao PV
        ;
    expressao: var ATRIB expressao 
		| simples-expressao
        ;
    var: ID 
		| ID ACO  expressao FCO
        ;
    simples-expressao: soma-expressao relacional soma-expressao 
		| soma-expressao
        ;
    relacional: MEIGUAL 
		| MENOR 
		| MAIOR 
		| MAIGUAL 
		| IGUAL 
		| DIF
        ;
    soma-expressao: soma-expressao soma termo 
		| termo
        ;
    soma: SOMA 
		| SUB
        ;
    termo: termo mult fator 
		| fator
        ;
    mult: MUL 
		| DIV
        ;
    fator:  AP expressao FP 
		| var 
		| ativacao 
		| NUM
        ;
    ativacao: ID  AP args FP;
    args: arg-lista 
		| vazio
        ;
    arg-lista: arg-lista V expressao 
		| expressao
        ;
%%
