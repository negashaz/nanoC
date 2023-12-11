%{
	
#include <stdio.h>

#include "translation.h"
#include "parser.tab.h"

void yyerror(char *);
void comment(void);
void yylex(void);

%}

%option noyywrap

/* identifiers */
IDENTIFIER_NONDIGIT             "_"|[a-zA-Z]
DIGIT                           [0-9]
IDENTIFIER                      {IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

/* constants */

NONZERO_DIGIT                   [1-9]
INTEGER_CONSTANT                {NONZERO_DIGIT}{DIGIT}*|"0"

ESCAPE_SEQUENCE                 "\\\'"|"\\\""|"\\?"|"\\\\"|"\\n"|"\\t"|"\\r"|"\\v"|"\\f"|"\\a"|"\\b"
C_CHAR                          [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUECNCE                {C_CHAR}+
CHARACTER_CONSTANT              \'{C_CHAR_SEQUECNCE}\'


/* string literals */
S_CHAR                          [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE                 {S_CHAR}
STRING_LITERAL                  \"{S_CHAR_SEQUENCE}?\"

WHITESPACE                      [ \t\v\n\f]

%%

"/*"      { comment(); }
"//".*    {/* ignore single line comments */}

"char"    {return CHARTYPE;}
"else"    {return ELSE;}
"for"     {return FOR;}
"if"      {return IF;}
"int"     {return INTTYPE;}
"return"  {return RETURN;}
"void"    {return VOIDTYPE;}

{IDENTIFIER}                     {
    yylval.symbol_pointer = table->lookup(yytext);
    return IDENTIFIER;
}

{INTEGER_CONSTANT}               {
    yylval.int_value = atoi(yytext);
    return INTEGER_CONSTANT;
}

{CHARACTER_CONSTANT}             {
    return CHARACTER_CONSTANT;
}

{STRING_LITERAL}                 {
    yylval.char_value = yytext;
    return STRING_LITERAL;
}

"["                                 {return LEFT_SQUARE_BRACKET;}
"]"                                 {return RIGHT_SQUARE_BRACKET;}
"("                                 {return LEFT_PARENTHESIS;}
")"                                 {return RIGHT_PARENTHESIS;}
"{"                                 {return LEFT_CURLY_BRACKET;}
"}"                                 {return RIGHT_CURLY_BRACKET;}
"->"                                {return ARROW;}
"&"                                 {return BITWISE_AND;}
"*"                                 {return ASTERISK;}
"+"                                 {return PLUS;}
"-"                                 {return MINUS;}
"/"                                 {return DIVIDE;}
"%"                                 {return MODULO;}
"!"                                 {return EXCLAMATION;}
"?"                                 {return QUESTION_MARK;}
"<"                                 {return LESS_THAN;}
">"                                 {return GREATER_THAN;}
"<="                                {return LESS_THAN_OR_EQUAL;}
">="                                {return GREATER_THAN_OR_EQUAL;}
"=="                                {return EQUAL;}
"!="                                {return NOT_EQUAL;}
"&&"                                {return LOGICAL_AND;}
"||"                                {return LOGICAL_OR;}
"="                                 {return ASSIGNMENT;}
":"                                 {return COLON;}
";"                                 {return SEMICOLON;}
","                                 {return COMMA;}

{WHITESPACE}+                      {/* ignore whitespace */}

%%

void comment(void){
    char c, p = 0;

    /* mapping to 0 */
    while((c = getchar()) != 0){
        if(p == '*' && c == '/'){
            return;
        }
        p = c;
    }
}