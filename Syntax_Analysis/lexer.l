%{
	#include <stdio.h>
	#include <string.h>
	#include "parser.tab.h"
	extern void yyerror(const char *);
%}

%option noyywrap

/* keywords */
KEYWORD                         "char"|"else"|"for"|"if"|"int"|"return"|"void"

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

CONSTANT                        {INTEGER_CONSTANT}|{CHARACTER_CONSTANT}

/* string literals */
S_CHAR                          [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE                 {S_CHAR}
STRING_LITERAL                  \"{S_CHAR_SEQUENCE}?\"

/* punctuators */

PUNCTUATOR  "["|"]"|"("|")"|"{"|"}"|"->"|"&"|"*"|"+"|"-"|"/"|"%"|"!"|"?"|"<"|">"|"<="|">="|"=="|"!="|"&&"|"||"|"="|":"|";"|","

%x MULTI_LINE_COMMENT_BODY SINGLE_LINE_COMMENT_BODY

%%


"//"                                {BEGIN(SINGLE_LINE_COMMENT_BODY);}
<SINGLE_LINE_COMMENT_BODY>[^\n]     { /* ignore */ }
<SINGLE_LINE_COMMENT_BODY>\n        {BEGIN(INITIAL);}
<SINGLE_LINE_COMMENT_BODY><<EOF>>   {BEGIN(INITIAL);}

"/*"                                {BEGIN(MULTI_LINE_COMMENT_BODY);}
<MULTI_LINE_COMMENT_BODY>[^*]       { /* ignore */ }
<MULTI_LINE_COMMENT_BODY>"*"[^/]    { /* ignore */ }
<MULTI_LINE_COMMENT_BODY>"*/"       {BEGIN(INITIAL);}

{KEYWORD}                        {
    if(strcmp(yytext,"char")==0)    {return CHARTYPE;}
    if(strcmp(yytext,"else")==0)    {return ELSE;}
    if(strcmp(yytext,"for")==0)     {return FOR;}
    if(strcmp(yytext,"if")==0)      {return IF;}
    if(strcmp(yytext,"int")==0)     {return INTTYPE;}
    if(strcmp(yytext,"return")==0)  {return RETURN;}
    if(strcmp(yytext,"void")==0)    {return VOIDTYPE;}
} 

{IDENTIFIER}                     {
    return IDENTIFIER;
}

{INTEGER_CONSTANT}               {
    return INTEGER_CONSTANT;
}

{CHARACTER_CONSTANT}             {
    return CHARACTER_CONSTANT;
}

{STRING_LITERAL}                 {
    return STRING_LITERAL;
}

{PUNCTUATOR}                     {
    if(strcmp(yytext,"[")==0)       {return LEFT_SQUARE_BRACKET;}
    if(strcmp(yytext,"]")==0)       {return RIGHT_SQUARE_BRACKET;}
    if(strcmp(yytext,"(")==0)       {return LEFT_PARENTHESIS;}
    if(strcmp(yytext,")")==0)       {return RIGHT_PARENTHESIS;}
    if(strcmp(yytext,"{")==0)       {return LEFT_CURLY_BRACKET;}
    if(strcmp(yytext,"}")==0)       {return RIGHT_CURLY_BRACKET;}
    if(strcmp(yytext,"->")==0)      {return ARROW;}
    if(strcmp(yytext,"&")==0)       {return BITWISE_AND;}
    if(strcmp(yytext,"*")==0)       {return ASTERISK;}
    if(strcmp(yytext,"+")==0)       {return PLUS;}
    if(strcmp(yytext,"-")==0)       {return MINUS;}
    if(strcmp(yytext,"/")==0)       {return DIVIDE;}
    if(strcmp(yytext,"%")==0)       {return MODULO;}
    if(strcmp(yytext,"!")==0)       {return EXCLAMATION;}
    if(strcmp(yytext,"?")==0)       {return QUESTION_MARK;}
    if(strcmp(yytext,"<")==0)       {return LESS_THAN;}
    if(strcmp(yytext,">")==0)       {return GREATER_THAN;}
    if(strcmp(yytext,"<=")==0)      {return LESS_THAN_OR_EQUAL;}
    if(strcmp(yytext,">=")==0)      {return GREATER_THAN_OR_EQUAL;}
    if(strcmp(yytext,"==")==0)      {return EQUAL;}
    if(strcmp(yytext,"!=")==0)      {return NOT_EQUAL;}
    if(strcmp(yytext,"&&")==0)      {return LOGICAL_AND;}
    if(strcmp(yytext,"||")==0)      {return LOGICAL_OR;}
    if(strcmp(yytext,"=")==0)       {return ASSIGNMENT;}
    if(strcmp(yytext,":")==0)       {return COLON;}
    if(strcmp(yytext,";")==0)       {return SEMICOLON;}
    if(strcmp(yytext,",")==0)       {return COMMA;}
}

"\n"|" "|"\t"	{

}

%%



