sem: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o sem

lex.yy.c: y.tab.c lex.l
	lex lex.l

y.tab.c: sem.y
	yacc -d sem.y

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h sem sem.dSYM
