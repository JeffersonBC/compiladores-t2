%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"void" 		{return VOID;}
"int" 		{return INT;}
"if" 		{return IF;}
"else" 		{return ELSE;}
"return" 	{return RETURN;}
"while" 	{return WHILE;}
"+"		    {return SOMA;}
"-"	    	{return SUB;}
"*"	    	{return MUL;}
"/"	    	{return DIV;}
"<"	    	{return MENOR;}
"<="		{return MEIGUAL;}
">" 		{return MAIOR;}
">="		{return MAIGUAL;}
"=="		{return IGUAL;}
"!="		{return DIF;}
"=" 		{return ATRIB;}
";" 		{return PV;}
"," 		{return V;}
"(" 		{return AP;}
")" 		{return FP;}
"[" 		{return ACO;}
"]" 		{return FCO;}
"{" 		{return ACH;}
"}" 		{return FCH;}
[a-zA-Z]+	{yylval.string = strdup(yytext); return ID;}
[0-9]+		{yylval.integer = atoi(yytext); return NUM;}
"\n"        {++yylineno;}
[ \t\b]+    /* discard whitespace */
"//".*		/* discard comments */
.           { fprintf(stderr, "unknown character: %c", yytext[0]); }

%%
int yywrap (void) {return 1;}

