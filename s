%{
#include<stdio.h>
#include<stdlib.h>
%}
%token DEF INC MAIN NL BLANK NUM ID SIN MUL INT FLOAT DOUBLE CHAR charliteral IF ELSE DO WHILE RO PRINTF SCANF FOR SWITCH BREAK DEFAULT CASE
%%
pgm:head main '{' NL cmt decl stmt_list'}' {printf("valid c program\n");exit(0);}
   ;
head:DEF BLANK ID BLANK NUM NL head
    |INC'<'ID'.'ID'>' NL head
    |
;
main:MAIN NL
    ;
cmt:SIN NL cmt
   |MUL NL cmt
   |
;
decl:INT BLANK intvar ';' NL decl
    |FLOAT BLANK floatvar ';' NL decl
    |DOUBLE BLANK floatvar ';' NL decl
    |CHAR BLANK charvar ';' NL decl
    |
;
intvar:ID'='NUM',' intvar
      |ID'['NUM']'
      |ID',' intvar
      |ID'='NUM
      |ID
;
floatvar:ID'='NUM'.'NUM',' floatvar
      |ID',' floatvar
      |ID'='NUM'.'NUM
      |ID
;
charvar:ID'='charliteral',' charvar
      |ID',' charvar
      |ID'='charliteral
      |ID
;
stmt_list:stmt stmt_list
         |
;
stmt:assignment
    |simpleif
    |ifelse1
    |elseif1
    |dowhile1
    |while1
    |PF
    |SF
    |for1
    |switch1
    ;
assignment:ID'='NUM';' NL
          |ID'='NUM'.'NUM ';' NL
           |ID'='charliteral';' NL
           |ID'='ID op ID';' NL
           |ID '='ID op NUM';'NL
           |ID'='ID op NUM'.'NUM ';' NL
;
simpleif:IF'('ID compare ID')' NL '{' NL stmt_list '}' NL
         |IF'('ID compare NUM')' NL '{' NL stmt_list '}' NL
        ;
ifelse1:IF'('ID compare ID')' NL '{' NL stmt_list '}' NL ELSE NL '{' NL stmt_list '}' NL
       |IF'('ID compare NUM')' NL '{' NL stmt_list '}' NL ELSE NL '{' NL stmt_list '}' NL
      ;
elseif1:IF'('ID compare ID')' NL '{' NL stmt_list '}'NL ELSE BLANK IF'('ID compare ID')' NL '{' NL stmt_list '}' NL ELSE NL '{' NL stmt_list '}' NL
       ;
dowhile1:DO NL '{' NL stmt_list '}' NL WHILE'('ID compare ID ')' ';' NL
        |DO NL '{' NL stmt_list '}' NL WHILE'('ID compare NUM ')' ';' NL
;
while1:WHILE'('ID compare ID ')' NL '{' NL stmt_list '}' NL
      |WHILE'('ID compare NUM ')' NL '{' NL stmt_list '}' NL
;
for1:FOR'('init';'cond';'incr')' NL '{' NL stmt_list '}' NL
    ;
switch1:SWITCH'('ID')' NL '{' NL case_list default_case '}' NL
       ;
case_list:CASE BLANK NUM BLANK ':' NL stmt_list br  NL case_list
         |
 ;
default_case:DEFAULT ':' NL stmt_list
            |
            ;
br:BREAK ';'
  ;
init:ID'='NUM
    ;
cond:ID compare NUM
    |ID compare ID
    ;
incr:ID op op
    |ID'='ID op NUM
;
PF:PRINTF NL
  ;
SF:SCANF NL
  ;
compare:'>'
       |'<'
|'='
|RO
;
op:'+'
  |'-'
|'*'
;
%%
int yyerror(char *msg)
{
printf("Invalid\n");
exit (0);
}
int main()
{
printf("Enter C program\n");
yyparse();
return 0;
}




cparser.l
%{
#include "y.tab.h"
%}
%%
"#define" { return DEF;}
"#include" { return INC;}
"main()" { return MAIN;}
"int"   { return INT;}
"float"  { return FLOAT;}
"double"  { return DOUBLE;}
"char"  { return CHAR;}
"'"[a-zA-Z]*"'"  { return charliteral;}
"if"  { return IF;}
"else"  { return ELSE;}
"do"   { return DO;}
"while"  { return WHILE;}
"for" { return FOR;}
"printf(".*");" { return PRINTF;}
"scanf(".*");" { return SCANF;}
"switch" { return SWITCH;}
"case" { return CASE;}
"break" { return BREAK;}
"default" { return DEFAULT;}
">="  { return RO;}
"<="  { return RO;}
"=="   { return RO;}
"//".*  { return SIN;}
"/*"(.|\n)*?"*/"  { return MUL;}
[ ]  { return BLANK;}
[\n]  { return NL;}
[a-zA-Z][a-zA-Z0-9_]*  { return ID;}
[0-9]+  { return NUM;}
.  { return yytext[0];}
%%

-----------------------------

%{
#include"y.tab.h"
%}
%%
"include" {printf("%s",yytext);return INCL;}
"int"|"float"|"char" {printf("%s",yytext);return DT;}
"define" {printf("%s",yytext);return DEF;}
"stdio.h"|"math.h" {printf("%s",yytext);return HFILE;}
"main" {printf("%s",yytext);return MAIN;}
"break;" {printf("%s",yytext);return BREAK;}
"switch" {printf("%s",yytext);return SW;}
"default:" {printf("%s",yytext);return DEFAULT;}
"case" {printf("%s",yytext);return CASE;}
"while" {printf("%s",yytext);return WH;}
"for" {printf("%s",yytext);return FOR;}
">="|"<=" {printf("%s",yytext);return GT;}
"++"|"--" {printf("%s",yytext);return SI;}
"printf(".*");" {printf("%s",yytext);return PF;}
"scanf(".*");" {printf("%s",yytext);return SF;}
"=="|"&&"|"||" {printf("%s",yytext);return LOGEQ;}
"if" {printf("%s",yytext);return IF;}
"else" {printf("%s",yytext);return ELSE;}
[a-z][a-z]* {printf("%s",yytext);return ID;}
[0-9][0-9][.][0-9]* {printf("%s",yytext);return NUM;}
"=" {printf("%s",yytext);return EQ;}
"(" {printf("%s",yytext);return OBR;}
")" {printf("%s",yytext);return CBR;}
"{" {printf("%s",yytext);return OB;}
"}" {printf("%s",yytext);return CB;}
"/"."*/" {printf("%s",yytext);return multiline;}
"//".* {printf("%s",yytext);return singleline;}
" " {printf("%s",yytext);return SP;}
\n {printf("%s",yytext);return NL;}
. {return yytext[0];}
%%


%{
#include<stdio.h>
extern FILE *yyin;
%}
%token NL INCL HFILE DEF ID NUM MAIN OBR CBR OB CB SP DT EQ multiline singleline PF SF IF LOGEQ ELSE BREAK SW DEFAULT CASE WH FOR GT SI
%%
S:PREPROC MN NL {printf("valid c program");return;}
;
PREPROC:HEADER NL PREPROC
       |
;
HEADER:'#' INCL '<' HFILE '>'
      |'#' DEF SP ID SP NUM
;
MN:MAIN OBR CBR NL OB NL BODY CB
;
BODY:DD BODY
    |SCANF BODY
    |PRINT BODY
    |SIMPLEIF BODY
    |IFELSE
    |ELSEIF
    |SWITCH
    |WHILE
    |FORL
    |
;
DD:DT SP ID EQ NUM ';' NL
;
PRINT:PF NL
;
SCANF:SF NL
;
SIMPLEIF:IF OBR EQN CBR NL OB NL BODY  CB NL
;
EQN:ID LOGEQ ID
   |NUM LOGEQ NUM
;
IFELSE:IF OBR EQN CBR NL OB NL BODY CB NL ELSEB
;
ELSEB:ELSE NL OB  NL BODY CB NL
;
ELSEIF:IF OBR EQN CBR NL OB NL BODY CB NL ELSE SP IF OBR EQN CBR NL OB NL BODY CB NL ELSE NL OB NL BODY CB NL
;
SWITCH:SW OBR ID CBR NL OB NL CASES  CASES DEFAULT NL BODY CB NL
;
CASES:CASE SP  NUM ':' NL BODY  BREAK NL
     |
;
WHILE:WH OBR EQN CBR NL OB NL BODY CB NL
;
FORL:FOR OBR FORCON CBR NL OB NL BODY CB NL
;
FORCON:DT SP ID EQ NUM ';' ID GT ID ';' ID SI
;
%%
yyerror(){
printf("invalid program");
}
int yywrap(){
return 1;
}
main(){
yyin=fopen("c.txt","r");
printf("program:\n");
yyparse();
}
