
%%
    programa: declaração-lista;
    declaração-lista: declaração-lista declaração | declaração;
    declaração: var-declaração | fun-declaração;
    var-declaração: tipo-especificador ID; | tipo-especificador ID[NUM];;
    tipo-especificador: int | void;
    fun-declaração: tipo-especificador ID( params ) composto-decl;
    params: param-lista | void;
    param-lista: param-lista, param | param;
    param: tipo-especificador ID | tipo-especificador ID[ ];
    composto-decl: { local-declarações statement-lista };
    local-declarações: local-declarações var-declaração | vazio;
    statement-lista: statement-lista statement | vazio;
    statement: expressão-decl | composto-decl | seleção-decl | iteração-decl |retorno-decl;
    expressão-decl: expressão ; | ;;
    seleção-decl: if (expressão) statement | if (expressão) statement else statement;
    iteração-decl: while (expressão) statement;
    retorno-decl: return; | return expressão ;;
    expressão: var = expressão | simples-expressão;
    var: ID | ID [ expressão ];
    simples-expressão: soma-expressão relacional soma-expressão | somaexpressão;
    relacional: <= | < | > | >= | == | !=;
    soma-expressão: soma-expressão soma termo | termo;
    soma: + | -;
    termo: termo mult fator | fator;
    mult: * | /;
    fator: ( expressão ) | var | ativação | NUM;
    ativação: ID ( args );
    args: arg-lista | vazio;
    arg-lista: arg-lista, expressão | expressão;
%%
