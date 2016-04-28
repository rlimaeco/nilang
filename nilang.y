
%{
#include <cstdio>
#include <iostream>
#include <cstdlib>


using namespace std;

// Definicoes do flex requeridos pelo bison:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num;

void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	float fval;
	char *sval;
}

// define the constant-string tokens:
%token NILANG TYPE
%token END ENDL

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

%%
// the first rule defined is the highest-level rule, which in our
// case is just the concept of a whole "nilang file":
nilang:
	header template body_section footer { cout << "done with a nilang file!" << endl; }
	;
header:
	NILANG FLOAT ENDLS { cout << "reading a nilang file version " << $2 << endl; }
	;
template:
	typelines
	;
typelines:
	typelines typeline
	| typeline
	;
typeline:
	TYPE STRING ENDLS { cout << "new defined nilang type: " << $2 << endl; }
	;
body_section:
	body_lines
	;
body_lines:
	body_lines body_line
	| body_line
	;
body_line:
	INT INT INT INT STRING ENDLS { cout << "new nilang: " << $1 << $2 << $3 << $4 << $5 << endl; }
	;
footer:
	END ENDLS
	;
ENDLS:
    ENDLS ENDL
    | ENDL ;
%%

int main(int argc, char* argv[]) {
	// Nilang - Compilador criado para fins academicos
    // 16902 - Rafael da Silva Lima

    if (argc > 1)
    {
        std::string arquivoAlvo(argv[1]);
        const char * nomeArquivo = arquivoAlvo.c_str();

        FILE *arquivo = fopen(nomeArquivo, "r");
            // testa a validade do arquivo:
            if (!arquivo) {
                cout << "Não foi possível abrir o arquivo: " << nomeArquivo << endl;
                return -1;
            }
            // define o lex para ler o arquivo:
            yyin = arquivo;

            // parse through the input until there is no more:
            do {
                yyparse();
            } while (!feof(yyin));
    }
    else
    {
        cout << "Favor definir o arquivo a ser compilado" << endl;
    }

}

void yyerror(const char *s) {
	cout << "EEK, parse error on line " << line_num << "! Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}
