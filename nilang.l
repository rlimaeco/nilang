
D			[0-9]
L			[a-zA-Z]
H			[a-zA-Z0-9]

%{

#include <cstdio>
#include <cstdlib>
#include <string>

using namespace std;
#include "nilang.tab.h"   //  output  of  bison on  example1.y

int line_num=1;
void yyerror(char*);
int yyparse(void);
%}

%%
[ \t]+                   ;
"imprime"                  {return IMPRIME;}
"se"                        {return SE;}
"senao"                     {return SENAO;}
"enquanto"                  {return ENQUANTO;}
"quebrar"                   {return QUEBRAR;}
"continuar"                 {return CONTINUAR;}

{L}{H}*                    {yylval.str_val = new string(yytext); return VARIAVEL;}
{D}{D}*(.{D}+)?            {yylval.double_val = atof(yytext); return REAL;}
{D}+                       { yylval.int_val = atoi(yytext); return INT; }
{H}+                       {yylval.str_val = new string(yytext); return STRING;}
"="                        {return IGUAL;}
"+"                        {return MAIS;}
"-"                        {return MENOS;}
"*"                        {return VEZES;}
"/"                        {return DIVIDIR;}
"("                        {return ABREPAREN;}
")"                        {return FECHAPAREN;}
"{"                        {return ABRECHAVE;}
"}"                        {return FECHACHAVE;}
">"                        {return MAIOR;}
"<"                        {return MENOR;}
">="                        {return MAIORIGUAL;}
"<="                        {return MENORIGUAL;}
";"                        {return PTEVIR;}
"\""                        {return ASPA;}


\n                         { ++line_num; }
%%

void yyerror(char* str) {printf("\nTipo de falha: %s\nNa linha: %d\n\n",str, line_num);}
int yywrap(void) { }

int main(int num_args, char** args) {
	if(num_args != 2) {printf("usage: ./nilang  nome_do_arquivo\n"); exit(0);}
	FILE* file = fopen(args[1],"r");
	if(file == NULL) {printf("Não foi possível abrir o arquvivo %s\n", args [1]);  exit(0);}
	yyin = file;   // now  flex  reads  from  file
	yyparse();
	fclose(file);
}
