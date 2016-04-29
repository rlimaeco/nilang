
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

// Bison fundamentalmente funciona , pedindo flex para obter o próximo token, que ele
// retorna como um objeto do tipo "yystype" . Mas tokens poderão ser de qualquer
// tipo de dados arbitrários ! Então, com o em Bison , define-se uma C union
// mantendo cada um dos tipos de tokens que Flex poderia voltar, e com Bison
// Use essa union em vez de "int" para a definição de "yystype" :
%union {
	int ival;
	float fval;
	char *sval;
}

// define o token de string constante:
%token NILANG TYPE
%token END ENDL

// Define os tokens de simbolo terminal
// Em maiusculo por definição, e associar cada campo com seu union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

%%
// A primeira regra define o nível mais alto de regra, neste caso
// será o conceito do arquivo completo nilang:
nilang:
	header template body_section footer { cout << "arquivo nILANg compilado!" << endl; }
	;
header:
	NILANG FLOAT ENDLS { cout << "versão da linguagem nilang: " << $2 << endl; }
	;
template:
	typelines
	;
typelines:
	typelines typeline
	| typeline
	;
typeline:
	TYPE STRING ENDLS { cout << "novo tipo definido:  " << $2 << endl; }
	;
body_section:
	body_lines
	;
body_lines:
	body_lines body_line
	| body_line
	;
body_line:
	INT INT INT INT STRING ENDLS { cout << "novo nilang: " << $1 << $2 << $3 << $4 << $5 << endl; }
	;
footer:
	END ENDLS
	;
ENDLS:
    ENDLS ENDL
    | ENDL ;
%%

int main(int argc, char* argv[]) {
	// Nilang - Compilador criado para fins acadêmicos
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
