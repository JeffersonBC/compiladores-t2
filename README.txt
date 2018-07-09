/* Nome dos integrantes disponível em 'nomes.txt' */

Para compilar o projeto basta executar 'make' num terminal tendo o Lex e o YACC instalados na máquina.

Para executar o analiador sobre os arquivos de exemplo:
- Exemplo sem erros:                            ' $ ./sem < testes/teste-s-erros.cm '
- Exemplo com erros sintáticos:                 ' $ ./sem < testes/teste-erros-sint.cm '
- Exemplo com erros semânticos:                 ' $ ./sem < testes/teste-erros-sema.cm '
- Exemplo com erros sintáticos e semânticos:    ' $ ./sem < testes/teste-erros-dois.cm '

A execução dos testes irá gerar os arquivos 'semantica.txt' e 'sintatica.txt'

====

Algumas simplificações foram feitas para tentar simplificar a criação do analizador:

- Variáveis e funções usam apenas uma letra, maiúscula ou minúscula
- Todas as variáveis são globais
- Não foi feito nenhum tratamento para analizar corretamente funções recursivas
