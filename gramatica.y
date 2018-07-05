%token <string> ID INT Void IF Return

%token <string> ATRIB MUL DIV SOMA SUB

%token <string> IGUAL DIF MAIOR MAIGUAL MENOR MEIGUAL

%token <string> OP_LOG_NAO OP_LOG_AND OP_LOG_OR

%token <string> V PV ACO FCO AP FP ASPAS

%start programa
%%
    programa: declaracao-lista;
    declaracao-lista: declaracao-lista declaracao | declaracao;
    declaracao: var-declaracao | fun-declaracao;
    var-declaracao: tipo-especificador ID PV | tipo-especificador ID ACO NUM FCO PV;
    tipo-especificador: INT | Void;
    fun-declaracao: tipo-especificador ID AP params FP composto-decl;
    params: param-lista | Void;
    param-lista: param-lista, param | param;
    param: tipo-especificador ID | tipo-especificador ID ACO  FCO;
    composto-decl: { local-declaracoes statement-lista };
    local-declaracoes: local-declaracoes var-declaracao | vazio;
    statement-lista: statement-lista statement | vazio;
    statement: expressao-decl | composto-decl | selecao-decl | iteracao-decl | retorno-decl;
    expressao-decl: expressao PV | PV;
    selecao-decl: IF AP expressao FP statement | IF AP expressao FP statement else statement;
    iteracao-decl: while AP expressao FP statement;
    retorno-decl: Return PV | Return expressao PV;
    expressao: var = expressao | simples-expressao;
    var: ID | ID  ACO  expressao FCO;
    simples-expressao: soma-expressao relacional soma-expressao | soma-expressao;
    relacional: MEIGUAL | MENOR | MAIOR | MAIGUAL | IGUAL | DIF;
    soma-expressao: soma-expressao soma termo | termo;
    soma: SOMA | SUB;
    termo: termo mult fator | fator;
    mult: MUL | DIV;
    fator:  AP expressao FP | var | ativacao | NUM;
    ativacao: ID  AP args FP;
    args: arg-lista | vazio;
    arg-lista: arg-lista, expressao | expressao;
%%
