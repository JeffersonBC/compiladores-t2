%token <string> IGUAL MUL DIV SOMA SUB

%token <string> IGUAL DIF MAIOR MAIGUAL MENOR MEIGUAL

%token <string> OP_LOG_NAO OP_LOG_AND OP_LOG_OR

%token <string> V PV ACO FCO AP FP ASPAS

%%
    programa: declaracao-lista;
    declaracao-lista: declaracao-lista declaracao | declaracao;
    declaracao: var-declaracao | fun-declaracao;
    var-declaracao: tipo-especificador ID; | tipo-especificador ID[NUM];;
    tipo-especificador: int | void;
    fun-declaracao: tipo-especificador ID( params ) composto-decl;
    params: param-lista | void;
    param-lista: param-lista, param | param;
    param: tipo-especificador ID | tipo-especificador ID[ ];
    composto-decl: { local-declaracoes statement-lista };
    local-declaracoes: local-declaracoes var-declaracao | vazio;
    statement-lista: statement-lista statement | vazio;
    statement: expressao-decl | composto-decl | selecao-decl | iteracao-decl |retorno-decl;
    expressao-decl: expressao ; | ;;
    selecao-decl: if (expressao) statement | if (expressao) statement else statement;
    iteracao-decl: while (expressao) statement;
    retorno-decl: return; | return expressao ;;
    expressao: var = expressao | simples-expressao;
    var: ID | ID [ expressao ];
    simples-expressao: soma-expressao relacional soma-expressao | soma-expressao;
    relacional: <= | < | > | >= | == | !=;
    soma-expressao: soma-expressao soma termo | termo;
    soma: + | -;
    termo: termo mult fator | fator;
    mult: * | /;
    fator: ( expressao ) | var | ativacao | NUM;
    ativacao: ID ( args );
    args: arg-lista | vazio;
    arg-lista: arg-lista, expressao | expressao;
%%
