lex filename.l
yacc -d filename.y
cc lex.yy.c y.tab.c -ll
./a.out
------------------------ .l
%{
#include "y.tab.h"
%}
%%
"#define"       {return DEF;}
"#include"      {return INC;}
"main()"      {return MAIN;}
[a-zA-Z][a-zA-Z0-9_]*   {return ID;}
[0-9]+          {return NUM;}
[  ]             {return BLANK;}
[\n]            {return NL;}
.               {return yytext[0];}
%%


------------------ .y
%{
#include<stdio.h>
#include<stdlib.h>
%}
%token DEF INC ID NUM BLANK MAIN NL
%%
        pgm:  def inc def main '{' NL '}'  {printf("Valid C program\n");exit(0);}
        ;
        def:    DEF BLANK ID BLANK NUM NL def
        |
        ;
        inc:    INC'<'ID'.'ID'>'NL inc
        |
        ;
        main:  MAIN NL
        ;
%%
int yyerror(char *msg)
{
        printf("Invalid\n");
        exit(0);
}
main()
{
        printf("Enter the program\n");
        yyparse();
}


Printf ooook
Scanf ooook
Variable declaration (int, float, char, …int x,y,z…., int x=0)
Array declaration

------- .l
%{
#include "y.tab.h"
%}
%%
"#define"       {return DEF;}
"#include"      {return INC;}
"main()"      {return MAIN;}
"int"         {return INT;}
"float"       {return FLOAT;}
"char"        {return CHAR;}
"double"      {return DOUBLE;}
[a-zA-Z][a-zA-Z0-9_]*   {return ID;}
[0-9]+          {return NUM;}
[ ]             {return BLANK;}
[\n]            {return NL;}
.               {return yytext[0];}
%%

------- .y

%{
#include<stdio.h>
#include<stdlib.h>
%}
%token DEF INC ID NUM BLANK MAIN NL INT FLOAT CHAR DOUBLE
%%
        pgm:    def inc main'{' NL dec NL '}' {printf("Valid C program\n");exit(0);}

        ;
        def:    DEF BLANK ID BLANK NUM NL def
        |
        ;
        inc:    INC'<'ID'.'ID'>'NL inc
        |
        ;
        dec: dtype BLANK var';'NL dec
        |
        ;
        dtype: INT |  FLOAT | CHAR | DOUBLE
        ;
        main: MAIN NL
        ;
        var: ID'='NUM',' var
        |    ID ','ID
        |    ID '='NUM
        |    ID '[' NUM ']'
        |    ID
        ;

%%
int yyerror(char *msg)
{
        printf("Invalid\n");
        exit(0);
}
main()
{
        printf("Enter the program\n");
        yyparse();
}



If
For
While


------- .l
%{
#include "y.tab.h"
%}
%%
"#define"       {return DEF;}
"#include"      {return INC;}
"main()"      {return MAIN;}
"int"         {return INT;}
"float"       {return FLOAT;}
"char"        {return CHAR;}
"double"      {return DOUBLE;}
"if"          {return IF;}
"for"         {return FOR;}
"while"       {return WHILE;}
[a-zA-Z][a-zA-Z0-9_]*   {return ID;}
[0-9]+          {return NUM;}
[ ]             {return BLANK;}
[\n]            {return NL;}
.               {return yytext[0];}
%%

------- .y

%{
#include<stdio.h>
#include<stdlib.h>
%}
%token DEF INC ID NUM CHAR DOUBLE BLANK MAIN  NL INT FLOAT IF WHILE FOR
%%
        pgm:    def inc main'{' NL dec iff whileloop  NL forloop NL '}' {printf("Valid C program\n");exit(0);}

        ;
        def:    DEF BLANK ID BLANK NUM NL def
        |
        ;
        inc:    INC'<'ID'.'ID'>'NL inc
        |
        ;
        dec: dtype BLANK var';'NL dec
        |
        ;
        dtype: INT
        |      FLOAT
        |      CHAR
        |      DOUBLE
        ;
        main: MAIN NL
        ;
        var: ID'='NUM',' var
        |    ID ','ID
        |    ID '='NUM
        |    ID '[' NUM ']'
        |    ID
        ;
        iff: IF'('cond')' NL'{' NL var';' NL '}' NL iff
        |
        ;
op: ID | NUM
;
cond: op ‘>’ op
	op ‘<’ op
	op’<’’=’op
	op’>’’=’op
	op’=’’=’op
	op’!’’=’op

        cond: ID '>' ID
        |     ID '<' ID
        |     ID '>''=' ID
        |     ID '<''=' ID
        |     NUM '>' NUM
        |     NUM '<' NUM
        |     NUM '>''='NUM
        |     NUM '<''='NUM
        |     NUM '!''='NUM
        |     NUM '=''='NUM
        |     ID  '=''='ID
        |     ID  '!''='ID
        |     ID  '>'NUM
        |     ID  '<'NUM
        |     ID   '>''='NUM
        |     ID   '<''='NUM
        |     ID    '!''='NUM
        |     ID    '=''='NUM
        ;
        whileloop: WHILE '(' cond ')' NL  '{' NL var';'NL '}' NL whileloop
        |
        ;
        forloop: FOR '('var ';'cond';' update ')' '{' NL var';' NL '}' NL forloop
        |
        ;
        update:ID'+''+'
        |      ID'-''-'
        |	  ID’=’ID’+’NUM
        |
        ;

%%
int yyerror(char *msg)
{
        printf("Invalid\n");
        exit(0);
}
main()
{
        printf("Enter the program\n");
        yyparse();
}




Multiline comments
Singleline Comments


------.l
%{
#include "y.tab.h"
%}
%%
"#define"       {return DEF;}
"#include"      {return INC;}
"main()"      {return MAIN;}

“//”[a-zA-Z0-9]*	 {return SLC;}
“/*”[a-zA-Z0-9\n]*”*/”       {return MLC;}

[a-zA-Z][a-zA-Z0-9_]*   {return ID;}
[0-9]+          {return NUM;}
[ ]             {return BLANK;}
[\n]            {return NL;}
.               {return yytext[0];}
%%

------- .y
%{
#include<stdio.h>
#include<stdlib.h>
%}
%token DEF INC ID NUM  BLANK MAIN SLC MLC NL
%%
        pgm:    def inc main'{' NL SLC NL MLC NL '}'    {printf("Valid C program\n");exit(0);}

        ;
        def:    DEF BLANK ID BLANK NUM NL def
        |
        ;
        inc:    INC'<'ID'.'ID'>'NL inc
        |
        ;
        main:  MAIN NL
%%
int yyerror(char *msg)
{
        printf("Invalid\n");
        exit(0);
}
main()
{
        printf("Enter the program\n");
        yyparse();
}








































Pre requiste


------------------------ .l
%{
#include "y.tab.h"
%}
%%
"#define"       {return DEF;}
"#include"      {return INC;}
"main()"      {return MAIN;}
[a-zA-Z][a-zA-Z0-9_]*   {return ID;}
[0-9]+          {return NUM;}
[  ]             {return BLANK;}
[\n]            {return NL;}
“printf”  {return PRTF;}
.               {return yytext[0];}
%%
------------------ .y
%{
#include<stdio.h>
#include<stdlib.h>
%}
%token DEF INC ID NUM BLANK MAIN PRTF NL
%%
        pgm:  def inc def main '{' NL prtf '}'  {printf("Valid C program\n");exit(0);}
        ;
        def:    DEF BLANK ID BLANK NUM NL def
        |
        ;
        inc:    INC'<'ID'.'ID'>'NL inc
        |
        ;
        main:  MAIN NL
        ;
        prtf:   PRTF’(‘ID’)’’;’ NL prtf
        |
        ;
%%
int yyerror(char *msg)
{
        printf("Invalid\n");
        exit(0);
}
main()
{
        printf("Enter the program\n");
        yyparse();
}
