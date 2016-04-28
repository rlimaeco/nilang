
%{
#include <cstdio>
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num =1;
#include "nilang.tab.h"
#include <cstring>

%}


%%
[ \t]          ;
nilang         { return NILANG; }
type           { return TYPE; }
end            { return END; }
[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+         { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9]+   {
	// we have to copy because we can't rely on yytext not changing underneath us:
	yylval.sval = strdup(yytext);
	return STRING;
}
[\(\)\{\}:;=,] { return yytext[0]; }
\n             { ++line_num; return ENDL; }
.              ;
%%


