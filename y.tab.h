/* A Bison parser, made by GNU Bison 3.0.5.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    VOID = 258,
    INT = 259,
    ELSE = 260,
    IF = 261,
    RETURN = 262,
    WHILE = 263,
    ID = 264,
    NUM = 265,
    ATRIB = 266,
    MUL = 267,
    DIV = 268,
    SOMA = 269,
    SUB = 270,
    IGUAL = 271,
    DIF = 272,
    MAIOR = 273,
    MAIGUAL = 274,
    MENOR = 275,
    MEIGUAL = 276,
    V = 277,
    PV = 278,
    ACO = 279,
    FCO = 280,
    AP = 281,
    FP = 282,
    ACH = 283,
    FCH = 284
  };
#endif
/* Tokens.  */
#define VOID 258
#define INT 259
#define ELSE 260
#define IF 261
#define RETURN 262
#define WHILE 263
#define ID 264
#define NUM 265
#define ATRIB 266
#define MUL 267
#define DIV 268
#define SOMA 269
#define SUB 270
#define IGUAL 271
#define DIF 272
#define MAIOR 273
#define MAIGUAL 274
#define MENOR 275
#define MEIGUAL 276
#define V 277
#define PV 278
#define ACO 279
#define FCO 280
#define AP 281
#define FP 282
#define ACH 283
#define FCH 284

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 10 "semantico.y" /* yacc.c:1910  */

	struct AST;
    struct list;
    
	struct AST* ast;
	struct list* list;
	char* string;
	int integer;
	int type;

#line 123 "y.tab.h" /* yacc.c:1910  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
