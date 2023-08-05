%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>
int yylex();
void yyerror(const char *);

char* macros[100000];
char* replacements[100000];
char* params[100000];
int macros_added = 0;

char * concat2(char *, char*);
char * concatWC2(char*, char*);
char * concat3(char *, char*, char *);
char * concat4(char *, char*, char *, char *);
char * getparams(char *);
char * string_arr(char *);
bool macro_present(char *);
int identifier_count(char *);
void add_macros(char * , char *, char *);
char ** split(char *, int);
char * str_replace(char * , char *, char *);
void replace_statement(char*, char**, char**);

%}

%union {
  int num;
  char * stringval;
}

%token <stringval> AND OR LEQ NEQ PLUS MINUS MUL DIV OPENSQBRAC CLOSESQBRAC OPENCURLY CLOSECURLY DOT LENGTH STRING OPENPARAN 
%token <stringval> CLOSEPARAN QUES COLON COMMA SEMICOLON TRUEBOOL FALSEBOOL NOT EQUAL THIS NEW INT PRINTSTMT WHILE IF 
%token <stringval> ELSE PUBLIC PRIVATE PROTECTED BOOLEAN RETURN CLASS STATIC VOID EXTENDS MAIN  
%token <stringval> DEFEXPR DEFEXPR0 DEFEXPR1 DEFEXPR2 DEFSTMT DEFSTMT0 DEFSTMT1 DEFSTMT2
%token <stringval> INTEGER
%token <stringval> IDENTIFIER

%type <stringval> goal
%type <stringval> mainclass
%type <stringval> typedeclaration
%type <stringval> typedeclarationstar
%type <stringval> typeidentifierscstar
%type <stringval> commatypeidentifierstar
%type <stringval> methoddeclaration
%type <stringval> methoddeclarationstar
%type <stringval> type
%type <stringval> identifier
%type <stringval> integer
%type <stringval> statement
%type <stringval> commaidentifierstar
%type <stringval> statementstar
%type <stringval> expression
%type <stringval> commaexpressionstar
%type <stringval> primaryexpression
%type <stringval> macrodefinition
%type <stringval> macrodefinitionstar
%type <stringval> macrodefstatement
%type <stringval> macrodefexpression

%start goal

%define parse.error detailed

%%

goal: mainclass {
  sprintf($$, "%s", $1);
  printf("%s\n", $$);
};

goal: macrodefinitionstar mainclass {
  sprintf($$, "%s", $2);
  printf("%s\n", $$);
};

goal: mainclass typedeclarationstar{
  sprintf($$, "%s %s\n", $1, $2);
  printf("%s\n", $$);

};

goal: macrodefinitionstar mainclass typedeclarationstar  {
  sprintf($$, "%s %s\n", $2, $3);
  printf("%s\n", $$ );
};

mainclass: CLASS identifier OPENCURLY PUBLIC STATIC VOID MAIN OPENPARAN STRING OPENSQBRAC CLOSESQBRAC identifier CLOSEPARAN OPENCURLY PRINTSTMT OPENPARAN expression CLOSEPARAN SEMICOLON CLOSECURLY CLOSECURLY  {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21);
};

typedeclaration: CLASS identifier OPENCURLY typeidentifierscstar methoddeclarationstar CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s\n", $1, $2, $3, $4, $5, $6);
};

typedeclaration: CLASS identifier OPENCURLY CLOSECURLY {
  sprintf($$, "%s %s %s %s\n", $1, $2, $3, $4);
};

typedeclaration: CLASS identifier OPENCURLY typeidentifierscstar CLOSECURLY {
  sprintf($$, "%s %s %s %s %s\n", $1, $2, $3, $4, $5);
};

typedeclaration: CLASS identifier OPENCURLY methoddeclarationstar CLOSECURLY {
  sprintf($$, "%s %s %s %s %s\n", $1, $2, $3, $4, $5);
};

typedeclaration: CLASS identifier EXTENDS identifier OPENCURLY typeidentifierscstar methoddeclarationstar CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8);
};

typedeclaration: CLASS identifier EXTENDS identifier OPENCURLY CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s", $1, $2, $3, $4, $5, $6);
};

typedeclaration: CLASS identifier EXTENDS identifier OPENCURLY methoddeclarationstar CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7);
};

typedeclaration: CLASS identifier EXTENDS identifier OPENCURLY typeidentifierscstar CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7);
};

methoddeclaration: PUBLIC type identifier OPENPARAN CLOSEPARAN OPENCURLY typeidentifierscstar statementstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
};

methoddeclaration: PUBLIC type identifier OPENPARAN CLOSEPARAN OPENCURLY RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
};

methoddeclaration: PUBLIC type identifier OPENPARAN CLOSEPARAN OPENCURLY statementstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
};

methoddeclaration: PUBLIC type identifier OPENPARAN CLOSEPARAN OPENCURLY typeidentifierscstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier commatypeidentifierstar CLOSEPARAN OPENCURLY typeidentifierscstar statementstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier commatypeidentifierstar CLOSEPARAN OPENCURLY RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier commatypeidentifierstar CLOSEPARAN OPENCURLY statementstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier commatypeidentifierstar CLOSEPARAN OPENCURLY typeidentifierscstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier CLOSEPARAN OPENCURLY typeidentifierscstar statementstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,$13, $14);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier CLOSEPARAN OPENCURLY RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier CLOSEPARAN OPENCURLY statementstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
};

methoddeclaration: PUBLIC type identifier OPENPARAN type identifier CLOSEPARAN OPENCURLY typeidentifierscstar RETURN expression SEMICOLON CLOSECURLY {
  sprintf($$, "%s %s %s %s %s %s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
};

type: INT OPENSQBRAC CLOSESQBRAC {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

type: BOOLEAN { sprintf($$, "%s", $1);};

type: INT { sprintf($$, "%s", $1);};

type: identifier { sprintf($$, "%s", $1);};

statement: OPENCURLY CLOSECURLY {
  sprintf($$, "%s %s", $1, $2);
};

statement: OPENCURLY statementstar CLOSECURLY {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

statement: PRINTSTMT OPENPARAN expression CLOSEPARAN SEMICOLON {
  sprintf($$, "%s %s %s %s %s", $1, $2, $3, $4, $5);
};

statement: identifier EQUAL expression SEMICOLON {
  sprintf($$, "%s %s %s %s", $1, $2, $3, $4);
};

statement: identifier OPENSQBRAC expression CLOSESQBRAC EQUAL expression SEMICOLON {
  sprintf($$, "%s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7);
};

statement: IF OPENPARAN expression CLOSEPARAN statement {
  sprintf($$, "%s %s %s %s %s", $1, $2, $3, $4, $5);
};

statement: IF OPENPARAN expression CLOSEPARAN statement ELSE statement {
  sprintf($$, "%s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7);  
};

statement: WHILE OPENPARAN expression CLOSEPARAN statement {
  sprintf($$, "%s %s %s %s %s", $1, $2, $3, $4, $5);
};

statement: identifier OPENPARAN CLOSEPARAN SEMICOLON {
  if (! macro_present($1)) {
    yyerror("wasnt2");
    exit(0);
    //sprintf($$,"%s %s %s %s",$1, $2, $3, $4);
  }
  else {
    if(identifier_count(getparams($1)) != 0){
      yyerror("sarg");
      exit(0);
    }
    char * val = string_arr($1);
    sprintf($$, "%s", val);
  }
};

statement: identifier OPENPARAN expression CLOSEPARAN SEMICOLON {
  if(macro_present($1))
  {
    if(identifier_count(getparams($1)) != 1){
      yyerror("sarg1");
      exit(0);
    }
    char * val = string_arr($1);
    sprintf($$,"%s",str_replace(val,getparams($1),$3));
  }
  else{
    yyerror("wasnt2");
    exit(0);
    //sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);
  }
};

statement: identifier OPENPARAN expression commaexpressionstar CLOSEPARAN SEMICOLON {
  if(!macro_present($1)){
    yyerror("wasnt2");
    exit(0);
    // sprintf($$,"%s %s %s %s %s %s",$1,$2,$3,$4,$5,$6);
	}
	else{
    if(identifier_count(getparams($1)) != identifier_count($4)){
      yyerror("sarg2");
      exit(0);
    }
      char * val = string_arr($1);
			char** temptokens = split(concatWC2($3, $4), identifier_count(concatWC2($3, $4)));
			char ** paramtokens = split(getparams($1), identifier_count(getparams($1)));
			char* stmt = (char*)malloc(1000);
			strcpy(stmt,val);
			replace_statement(stmt, temptokens, paramtokens);
			sprintf($$,"%s",stmt);
    }
};

expression: primaryexpression AND primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression OR primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression NEQ primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression LEQ primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression PLUS primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression MINUS primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression MUL primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression DIV primaryexpression {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression OPENSQBRAC primaryexpression CLOSESQBRAC {
  sprintf($$, "%s %s %s %s", $1, $2, $3, $4);
};

expression: primaryexpression DOT LENGTH {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

expression: primaryexpression{
  sprintf($$, "%s", $1);
};

expression: primaryexpression DOT identifier OPENPARAN CLOSEPARAN {
  if(! macro_present($3)){
    sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);
  }
  else{
    char * val = string_arr($3);
    sprintf($$,"%s %s %s %s %s",$1,$2,$4,val,$5);
  }
};

expression: primaryexpression DOT identifier OPENPARAN expression commaexpressionstar CLOSEPARAN {
  if(macro_present($3)){
    char * val = string_arr($3);
			char** temptokens = split(concatWC2($5, $6), identifier_count(concatWC2($5, $6)));
			char ** paramtokens = split(getparams($3), identifier_count(getparams($3)));
			char* stmt = (char*)malloc(1000);
			strcpy(stmt,val);
			replace_statement(stmt, temptokens, paramtokens);
			sprintf($$,"%s %s %s %s %s",$1,$2,$4,stmt,$7);
  }
  else{
    sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6, $7);
  }
};

expression: primaryexpression DOT identifier OPENPARAN expression CLOSEPARAN {
  if(!macro_present($3)){
    sprintf($$,"%s %s %s %s %s %s",$1,$2,$3,$4,$5,$6);
  }
  else{
    char * val = string_arr($3);
    if(identifier_count(getparams($3)) != 1);
    sprintf($$,"%s %s %s %s %s",$1,$2,$4,str_replace(val,getparams($3),$5),$6);
  }
};

expression: identifier OPENPARAN CLOSEPARAN {
  if(! macro_present($1) ){
    yyerror("wasnt");
    exit(0);
  }
  else{
    char * val = string_arr($1);
    if(identifier_count(getparams($1)) == 0)
      sprintf($$,"%s %s %s",$2,val,$3);
    else{
      yyerror("arg");
      exit(0);
    }
  }
};

expression: identifier OPENPARAN expression commaexpressionstar CLOSEPARAN {
  if(macro_present($1)){
    char * val = string_arr($1);
      if(identifier_count(getparams($1)) != identifier_count($4)){
        yyerror("argu");
        exit(0);
      }
			char **temptokens = split(concatWC2($3, $4), identifier_count(concatWC2($3, $4)));
			char ** paramtokens = split(getparams($1), identifier_count(getparams($1)));
			char* stmt = (char*)malloc(1000);
			strcpy(stmt,val);
			replace_statement(stmt, temptokens, paramtokens);
			sprintf($$,"%s %s %s",$2,stmt,$5);
		}
		else{
      yyerror("wasnt");
    exit(0);
  }
};

expression: identifier OPENPARAN expression CLOSEPARAN {
  
  if(!macro_present($1))
  {
    yyerror("");
    exit(0);
    //sprintf($$,"%s %s %s %s",$1,$2,$3,$4);
  }
  else{
    char * val = string_arr($1);
    if(identifier_count(getparams($1)) != 1){
      yyerror("argun");
      exit(0);
    }
    sprintf($$,"%s %s %s",$2,str_replace(val,getparams($1),$3),$4);
  }
};

primaryexpression: integer {
  sprintf($$,"%s",$1);
};

primaryexpression: TRUEBOOL {
  sprintf($$,"%s",$1);
};

primaryexpression: FALSEBOOL {
  sprintf($$,"%s",$1);
};

primaryexpression: identifier {
  sprintf($$,"%s",$1);
};

primaryexpression: THIS {
  sprintf($$,"%s",$1);
};

primaryexpression: NEW INT OPENSQBRAC expression CLOSESQBRAC {
  sprintf($$, "%s %s %s %s %s", $1, $2, $3, $4, $5);
};

primaryexpression: NEW identifier OPENPARAN CLOSEPARAN {
  sprintf($$, "%s %s %s %s", $1, $2, $3, $4);
};

primaryexpression: NOT expression {
  sprintf($$, "%s %s", $1, $2);
};

primaryexpression: OPENPARAN expression CLOSEPARAN {
  sprintf($$, "%s %s %s", $1, $2, $3);
};

macrodefinition: macrodefexpression {
  sprintf($$,"%s", $1);
};

macrodefinition: macrodefstatement {
  sprintf($$,"%s", $1);
};

macrodefstatement: DEFSTMT identifier OPENPARAN identifier COMMA identifier COMMA identifier commaidentifierstar CLOSEPARAN OPENCURLY statementstar CLOSECURLY {
  char * parameters = concat4($4, $6, $8, $9);
  add_macros($2,parameters, $12); 
};

macrodefstatement: DEFSTMT identifier OPENPARAN identifier COMMA identifier COMMA identifier CLOSEPARAN OPENCURLY CLOSECURLY {
  char * parameters = concat3($4, $6, $8);
  add_macros($2,parameters,""); 
};

macrodefstatement: DEFSTMT identifier OPENPARAN identifier COMMA identifier COMMA identifier CLOSEPARAN OPENCURLY statementstar CLOSECURLY {
  char * parameters = concat3($4, $6, $8);
  add_macros($2,parameters, $11); 
};

macrodefstatement: DEFSTMT identifier OPENPARAN identifier COMMA identifier COMMA identifier commaidentifierstar CLOSEPARAN OPENCURLY CLOSECURLY {
  char * parameters = concat4($4, $6, $8, $9);
  add_macros($2,parameters, "");
};

macrodefstatement: DEFSTMT0 identifier OPENPARAN CLOSEPARAN OPENCURLY statementstar CLOSECURLY {
  add_macros($2, "", $6);  sprintf($$, "%s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7);  
};

macrodefstatement: DEFSTMT0 identifier OPENPARAN CLOSEPARAN OPENCURLY CLOSECURLY {
  add_macros($2, "", "");sprintf($$, "%s %s %s %s %s %s", $1, $2, $3, $4, $5, $6);  
}; 

macrodefstatement: DEFSTMT1 identifier OPENPARAN identifier CLOSEPARAN OPENCURLY statementstar CLOSECURLY {
  add_macros($2, $4, $7); 
};  

macrodefstatement: DEFSTMT1 identifier OPENPARAN identifier CLOSEPARAN OPENCURLY CLOSECURLY {
  add_macros($2, $4, ""); 
}; 

macrodefstatement: DEFSTMT2 identifier OPENPARAN identifier COMMA identifier CLOSEPARAN OPENCURLY statementstar CLOSECURLY {
  char * parameters = concat2($4, $6);
  add_macros($2,parameters,$9); 
};

macrodefstatement: DEFSTMT2 identifier OPENPARAN identifier COMMA identifier CLOSEPARAN OPENCURLY CLOSECURLY {
  char * parameters = concat2($4, $6);
  add_macros($2,parameters,""); 
};

macrodefexpression: DEFEXPR identifier OPENPARAN identifier COMMA identifier COMMA identifier commaidentifierstar CLOSEPARAN OPENPARAN expression CLOSEPARAN {
  char * parameters = concat4($4, $6, $8, $9);
  add_macros($2,parameters,$12); 
};  

macrodefexpression: DEFEXPR identifier OPENPARAN identifier COMMA identifier COMMA identifier CLOSEPARAN OPENPARAN expression CLOSEPARAN {
  char * parameters = concat3($4, $6, $8);
  add_macros($2,parameters,$11); 
};

macrodefexpression: DEFEXPR0 identifier OPENPARAN CLOSEPARAN OPENPARAN expression CLOSEPARAN {
  add_macros($2, "", $6); sprintf($$, "%s %s %s %s %s %s %s", $1, $2, $3, $4, $5, $6, $7);  
};

macrodefexpression: DEFEXPR1 identifier OPENPARAN identifier CLOSEPARAN OPENPARAN expression CLOSEPARAN {
  add_macros($2, $4, $7); 
}; 

macrodefexpression: DEFEXPR2 identifier OPENPARAN identifier COMMA identifier CLOSEPARAN OPENPARAN expression CLOSEPARAN {
  char * parameters = concat2($4, $6);
  add_macros($2, parameters, $9);
};  

identifier: IDENTIFIER {
    sprintf($$, "%s", $1);
};

integer: INTEGER {
    sprintf($$, "%s", $1);
};

typedeclarationstar: typedeclaration {
    sprintf($$, "%s", $1);
};

typedeclarationstar: typedeclaration typedeclarationstar {
    sprintf($$, "%s %s", $1, $2);
};

typeidentifierscstar: type identifier SEMICOLON {
    sprintf($$, "%s %s %s", $1, $2, $3);
};

typeidentifierscstar: typeidentifierscstar type identifier SEMICOLON{
    sprintf($$, "%s %s %s %s", $1, $2, $3, $4);
};

commatypeidentifierstar: COMMA type identifier {
    sprintf($$, "%s %s %s", $1, $2, $3);
};

commatypeidentifierstar: COMMA type identifier commatypeidentifierstar {
    sprintf($$, "%s %s %s %s", $1, $2, $3, $4);
};

methoddeclarationstar: methoddeclaration {
    sprintf($$, "%s", $1);
};

methoddeclarationstar: methoddeclaration methoddeclarationstar{
    sprintf($$, "%s %s", $1, $2);
};

commaidentifierstar: COMMA identifier {
    sprintf($$, "%s %s", $1, $2);
};

commaidentifierstar: COMMA identifier commaidentifierstar {
    sprintf($$, "%s %s %s", $1, $2, $3);
};

statementstar: statement {
    sprintf($$, "%s", $1);
};

statementstar: statement statementstar {
    sprintf($$, "%s %s", $1, $2);
};

commaexpressionstar: COMMA expression{
    sprintf($$, "%s %s", $1, $2);
};

commaexpressionstar: COMMA expression commaexpressionstar {
    sprintf($$, "%s %s %s", $1, $2, $3);
};

macrodefinitionstar: macrodefinition {
    sprintf($$, "%s", $1);
};

macrodefinitionstar: macrodefinition macrodefinitionstar  { sprintf($$, "%s %s", $1, $2);};
%%

char * concat3(char * oo, char * tt, char * tr) {
  char * concatStr = (char *) malloc(1000);
  sprintf(concatStr, "%s,%s,%s", oo, tt, tr);
  return concatStr;
}

char * concat2(char * oo, char * tr) {
  char * concatStr = (char *) malloc(1000);
  sprintf(concatStr, "%s,%s", oo, tr);
  return concatStr;
}

char * concatWC2(char *oo, char* tr){
  char * concatStr = (char *) malloc(1000);
  sprintf(concatStr, "%s%s", oo, tr);
  return concatStr;
}

char * concat4(char * oo, char * tt, char * tr, char * ff) {
  char * concatStr = (char *) malloc(1000);
  sprintf(concatStr, "%s,%s,%s%s", oo, tt, tr, ff);
  return concatStr;
}

char* getparams(char* id){
  for(int i = 0; macros[i]; i++) 
    if(strcmp(id,macros[i]) == 0) 
      return params[i];
}

char * string_arr(char* id){
  for(int i = 0; macros[i]; i++)
    if(strcmp(macros[i],id) == 0)
      return replacements[i];
}

bool macro_present(char *id) {
  for(int i = 0; macros[i]; i++)
    if(strcmp(macros[i],id) == 0)
      return true;
  return false;
}

int identifier_count(char * concat){
  if(strcmp(concat, "") == 0){
    return 0;
  } 
  int count = 1;
  while(*concat) {
    if(*concat == ',') count++;
    concat++;
  }
  return count;
}

void add_macros(char* id,char* param, char* body){
  if(macro_present(id)){
    yyerror("present");
    exit(0);
  }
	macros[macros_added] = strdup(id);
  replacements[macros_added] = strdup(body);
  params[macros_added] = strdup(param);
	macros_added++;	
}

char** split(char* a_str, int count)
{
  count++;
  char** split_tokens = malloc(sizeof(char*) * count);;
  if (split_tokens){
    int idx  = 0;
    char * token = strtok(a_str, ",\0");
    while (token){
      assert(idx < count);
      *(split_tokens + idx) = strdup(token);
      idx++;
      token = strtok(0, ",\0");
    }
  *(split_tokens + idx) = 0;
  }
  return split_tokens;
}

void replace_statement(char * stmt, char **temptokens, char **paramtokens){
  if (paramtokens){
		for (int i = 0; *(paramtokens + i); i++)
		  strcpy(stmt,str_replace(stmt,*(paramtokens + i),*(temptokens + i)));    
    for (int i = 0; *(paramtokens + i); i++){
      free(*(paramtokens+i));
      free(*(temptokens+i));
    }
		free(paramtokens);
		free(temptokens);
	}
}

char *str_replace(char *orig, char *rep, char *with) {
    char *result; 
    char *ins = orig; 
    char *tmp;
    long len_rep = 0;
    long len_with = 0; 
    long len_front = 0; 
    long count = 0; 

    int temp = 0;
    if (!orig)
        return NULL;
    if (with) len_with = strlen(with);
    if(rep) len_rep = strlen(rep);
    
    while(strstr(ins, rep)){
      count++;
      ins = strstr(ins, rep) + len_rep;
    }

    int ap = 1;
    tmp = result = malloc(strlen(orig) + (len_with - len_rep) * count + 1);

    if (result == NULL)
        return NULL;

    int i = 0;
    for(i = 0; i<count; i++){
      ins = strstr(orig, rep);
      len_front = ins- orig;
      tmp = strncpy(tmp, orig, len_front) + len_front;
      tmp = strcpy(tmp, with) + len_with;
      orig += len_front + len_rep;
    }
    strcpy(tmp, orig);
    return result;
}

void yyerror (const char *s) {
  //printf("%s\n", s);
  printf ("//Failed to parse input code\n");
}

int main () {
  yyparse ();
	return 0;
}

#include "lex.yy.c"


