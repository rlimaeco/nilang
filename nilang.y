%{
    #include <cstdio>
    #include <cstdlib>
    #include <string>
    #include <map>
    using namespace std;
    map <string,double> vars;    // map  from  variable  name to value
    map <string,string> varsStr;    // map  from  variable  name to value
    extern int yylex();
    extern void yyerror(char*);
    void Div0Error(void);
    void UnknownVarError(string s);
%}

%union {
    int      int_val;
    double   double_val;
    string*  str_val;
}

%token <int_val> INT MAIS MENOS VEZES DIVIDIR IGUAL IMPRIME ABREPAREN FECHAPAREN PTEVIR
%token <int_val> SE SENAO ENQUANTO QUEBRAR CONTINUAR ASPA MAIOR MENOR MAIORIGUAL MENORIGUAL
%token <int_val> ABRECHAVE FECHACHAVE
%token <str_val> VARIAVEL STRING
%token <double_val> REAL

%type <double_val> expression;
%type <double_val> interno1;
%type <double_val> interno2;

%start parsetree

%%

parsetree:      lines                                {printf("Compilado com sucesso");};

lines:          lines line | line;

line:           IMPRIME expression PTEVIR             {printf("%lf\n",$2);}
              | VARIAVEL IGUAL expression PTEVIR      {vars[*$1] = $3; delete $1;};

expression:     expression MAIS interno1                {$$ = $1 + $3;}
              | expression MENOS interno1               {$$ = $1 - $3;}
              | interno1                                {$$ = $1;};


interno1:       interno1 VEZES interno2                 {$$ = $1 * $3;}
              | interno1 DIVIDIR interno2
                {if($3 == 0) Div0Error();  else $$ = $1 / $3;}
              | interno2                                {$$ = $1;};

interno2:       VARIAVEL
                {if(!vars.count(*$1))  UnknownVarError(*$1); else $$ = vars[*$1]; delete $1;}
              | REAL                                     {$$ = $1;}
              | ABREPAREN expression FECHAPAREN          {$$ = $2;};
%%


void  Div0Error(void) {printf("Erro: Divisão por zero\n"); exit(0);}
void  UnknownVarError(string s) {printf("Erro: %s não existe !\n", s.c_str()); exit (0);}