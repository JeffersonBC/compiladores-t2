%{

#include <stdio.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

int erros = 0;

%}

letra [a-z]|[A-Z]
digito [0-9]
NUM {digito}{digito}*
ID {letra}{letra}*
SOMA \+
SUB \-
MUL \*
DIV \/
MENOR \<
MAIOR \>
ATRIB \=
MEIGUAL {MENOR}{ATRIB}
MAIGUAL {MAIOR}{ATRIB}
IGUAL {ATRIB}{ATRIB}
DIF !{ATRIB}
PV \;
V \,
AP \(
FP \)
ACO \[
FCO \]
ACH \{
FCH \}
ERRO \.|\'|\!|\@|\#|\$|\%|\&|\*|\?|\:|\\|\|
Main "main"
Else "else"
IF "if"
INT "int"
Return "return"
Void "void"
While "while"

%%
{ID}{NUM}{ID}|{ID}{NUM}|{NUM}{ID}|{NUM}{ID}{NUM} {
    erros++;
    fprintf(yyout, "%s ERRO\n", yytext);
}
{Main} {fprintf(yyout, "%s %s\n", yytext, "MAIN");}
{Else} {fprintf(yyout, "%s %s\n", yytext, "ELSE");}
{IF} {fprintf(yyout, "%s %s\n", yytext, "IF");}
{INT} {fprintf(yyout, "%s %s\n", yytext, "INT");}
{Return} {fprintf(yyout, "%s %s\n", yytext, "RETURN");}
{Void} {fprintf(yyout, "%s %s\n", yytext, "VOID");}
{While} {fprintf(yyout, "%s %s\n", yytext, "WHILE");}
{NUM} {fprintf(yyout, "%s %s\n", yytext, "NUM");}
{ID} {fprintf(yyout, "%s %s\n", yytext, "ID");}
{SOMA} {fprintf(yyout, "%s %s\n", yytext, "SOMA");}
{SUB} {fprintf(yyout, "%s %s\n", yytext, "SUB");}
{MUL} {fprintf(yyout, "%s %s\n", yytext, "MUL");}
{DIV} {fprintf(yyout, "%s %s\n", yytext, "DIV");}
{MENOR} {fprintf(yyout, "%s %s\n", yytext, "MENOR");}
{MAIOR} {fprintf(yyout, "%s %s\n", yytext, "MAIOR");}
{ATRIB} {fprintf(yyout, "%s %s\n", yytext, "ATRIB");}
{MEIGUAL} {fprintf(yyout, "%s %s\n", yytext, "MEIGUAL");}
{MAIGUAL} {fprintf(yyout, "%s %s\n", yytext, "MAIGUAL");}
{IGUAL} {fprintf(yyout, "%s %s\n", yytext, "IGUAL");}
{DIF} {fprintf(yyout, "%s %s\n", yytext, "DIF");}
{PV} {fprintf(yyout, "%s %s\n", yytext, "PV");}
{V} {fprintf(yyout, "%s %s\n", yytext, "V");}
{AP} {fprintf(yyout, "%s %s\n", yytext, "AP");}
{FP} {fprintf(yyout, "%s %s\n", yytext, "FP");}
{ACO} {fprintf(yyout, "%s %s\n", yytext, "ACO");}
{FCO} {fprintf(yyout, "%s %s\n", yytext, "FCO");}
{ACH} {fprintf(yyout, "%s %s\n", yytext, "ACH");}
{FCH} {fprintf(yyout, "%s %s\n", yytext, "FCH");}

"/*" {
    char c;
    int ok = FALSE;

    do{
        while ((c=input()) != '*')
            fseek(yyin, 1, SEEK_CUR);

        fseek(yyin, 1, SEEK_CUR);

        while ((c=input()) == '*')
            fseek(yyin, 1, SEEK_CUR);

        fseek(yyin, 1, SEEK_CUR);

        if (c == '/')
            ok = TRUE;
    }while(!ok);
}

{ERRO} {
    erros++;
    fprintf(yyout, "%s ERRO\n", yytext);
}

" "|"\n"|"\t"


%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
    yyout = fopen("relatorio.txt", "w");
	yylex();
	fprintf(yyout, "%d erro(s) encontrado(s)\n", erros);
    fclose(yyin);
    fclose(yyout);
}
