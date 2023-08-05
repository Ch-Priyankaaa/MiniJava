%{
	#include <stdio.h>
	#include <string.h> 
%}

INTEGER 	(0|([1-9][0-9]*))
WHITESPACE 		"\t"|"\n"|"\r"|"\f"|" "
ID	[A-Z|a-z]([A-Z|a-z]|[0-9]|[_])*
	
%%

"&&"                {  yylval.stringval = strdup(yytext);
                      return AND;
                   }

"||"                {  yylval.stringval = strdup(yytext);
                      return OR;
                   }

                   "="                {  yylval.stringval = strdup(yytext);
                      return EQUAL;
                   }

"<="                {  yylval.stringval = strdup(yytext);
                      return LEQ;
                   }

"!="                {  yylval.stringval = strdup(yytext);
                      return NEQ;
                   }

"+"                {  yylval.stringval = strdup(yytext);
                      return PLUS;
                   }

"-"                {  yylval.stringval = strdup(yytext);
                      return MINUS;
                   }

"*"                {  yylval.stringval = strdup(yytext);
                      return MUL;
                   }

"/"                {  yylval.stringval = strdup(yytext);
                      return DIV;
                   }

"["                {  yylval.stringval = strdup(yytext);
                      return OPENSQBRAC;
                   }

"]"                {  yylval.stringval = strdup(yytext);
                      return CLOSESQBRAC;
                   }

"{"                {  yylval.stringval = strdup(yytext);
                      return OPENCURLY;
                   }

"}"                {  yylval.stringval = strdup(yytext);
                      return CLOSECURLY;
                   }

"."                {  yylval.stringval = strdup(yytext);
                      return DOT;
                   }

"length"          { yylval.stringval = strdup(yytext);
                    return LENGTH;}

"("                {  yylval.stringval = strdup(yytext);
                      return OPENPARAN;
                   }

")"                {  yylval.stringval = strdup(yytext);
                      return CLOSEPARAN;
                   }

"?"                {  yylval.stringval = strdup(yytext);
                      return QUES;
                   }

":"                {  yylval.stringval = strdup(yytext);
                      return COLON;
                   }

","                {  yylval.stringval = strdup(yytext);
                      return COMMA;
                   }

";"                {  yylval.stringval = strdup(yytext);
                      return SEMICOLON;
                   }

"true"             {  yylval.stringval = strdup(yytext);
                      return TRUEBOOL;
                   }

"false"            {  yylval.stringval = strdup(yytext);
                      return FALSEBOOL;
                   }

"!"                {  yylval.stringval = strdup(yytext);
                      return NOT;
                   }


"this"             {  yylval.stringval = strdup(yytext);
                      return THIS;
                   }

"new"              {  yylval.stringval = strdup(yytext);
                      return NEW;
                   }

"int"              {  yylval.stringval = strdup(yytext);
                      return INT;
                   }

"System.out.println"  {  yylval.stringval = strdup(yytext);
                      return PRINTSTMT;
                   }

"while"            {  yylval.stringval = strdup(yytext);
                      return WHILE;
                   }

"if"               {  yylval.stringval = strdup(yytext);
                      return IF;
                   }

"else"             {  yylval.stringval = strdup(yytext);
                      return ELSE;
                   }

"public"           {  yylval.stringval = strdup(yytext);
                      return PUBLIC;
                   }

"private"          {  yylval.stringval = strdup(yytext);
                      return PRIVATE;
                   }

"protected"        {  yylval.stringval = strdup(yytext);
                      return PROTECTED;
                   }

"boolean"          {  yylval.stringval = strdup(yytext);
                      return BOOLEAN;
                   }

"return"           {  yylval.stringval = strdup(yytext);
                      return RETURN;
                   }

"class"            {  yylval.stringval = strdup(yytext);
                      return CLASS;
                   }

"static"           {  yylval.stringval = strdup(yytext);
                      return STATIC;
                   }

"void"             {  yylval.stringval = strdup(yytext);
                      return VOID;
                   }

"extends"          {  yylval.stringval = strdup(yytext);
                      return EXTENDS;
                   }

"main"             {  yylval.stringval = strdup(yytext);
                      return MAIN;
                   }

"String"            {
                        yylval.stringval = strdup(yytext);
                        return STRING;
                    }

"#defineExpr"      {  yylval.stringval = strdup(yytext);
                      return DEFEXPR;
                   }

"#defineExpr0"     {  yylval.stringval = strdup(yytext);
                      return DEFEXPR0;
                   }

"#defineExpr1"     {  yylval.stringval = strdup(yytext);
                      return DEFEXPR1;
                   }

"#defineExpr2"     {  yylval.stringval = strdup(yytext);
                      return DEFEXPR2;
                   }

"#defineStmt"      {  yylval.stringval = strdup(yytext);
                      return DEFSTMT;
                   }

"#defineStmt0"      {  yylval.stringval = strdup(yytext);
                      return DEFSTMT0;
                   }

"#defineStmt1"      {  yylval.stringval = strdup(yytext);
                      return DEFSTMT1;
                   }

"#defineStmt2"      {  yylval.stringval = strdup(yytext);
                      return DEFSTMT2;
                   }

{INTEGER}            { yylval.stringval = strdup(yytext);
                      return INTEGER;
                   }

{ID}               {  yylval.stringval = strdup(yytext);
                      return IDENTIFIER;
                   }

"//"[^\n]*         ;

{WHITESPACE}       ;

.				   {printf("error\n");return 1;}

%%