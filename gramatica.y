
%%
programa: declaração-lista
2. declaração-lista: declaração-lista declaração | declaração
3. declaração: var-declaração | fun-declaração
4. var-declaração: tipo-especificador ID; | tipo-especificador ID[NUM];
5. tipo-especificador: int | void
6. fun-declaração: tipo-especificador ID( params ) composto-decl
7. params: param-lista | void
8. param-lista: param-lista, param | param
9. param: tipo-especificador ID | tipo-especificador ID[ ]
10. composto-decl: { local-declarações statement-lista }
11. local-declarações: local-declarações var-declaração | vazio
12. statement-lista: statement-lista statement | vazio
13. statement: expressão-decl | composto-decl | seleção-decl | iteração-decl |
retorno-decl
14. expressão-decl: expressão ; | ;
15. seleção-decl: if (expressão) statement | if (expressão) statement
else statement
16. iteração-decl: while (expressão) statement
17. retorno-decl: return; | return expressão ;
18. expressão: var = expressão | simples-expressão
19. var: ID | ID [ expressão ]
20. simples-expressão: soma-expressão relacional soma-expressão | somaexpressão
21. relacional: <= | < | > | >= | == | !=
22. soma-expressão: soma-expressão soma termo | termo
23. soma: + | -
24. termo: termo mult fator | fator
25. mult: * | /
26. fator: ( expressão ) | var | ativação | NUM
27. ativação: ID ( args )
28. args: arg-lista | vazio
29. arg-lista: arg-lista, expressão | expressão

%%
