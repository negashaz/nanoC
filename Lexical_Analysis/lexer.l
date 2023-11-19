%{
    #include <stdio.h>
    #include <string.h>

    /* comments */
    #define MULTI_LINE_COMMENT_BODY 1    
    #define SINGLE_LINE_COMMENT_BODY 2   

    /* keywords */
    #define CHARTYPE 3    
    #define ELSE 4        
    #define FOR 5         
    #define IF 6          
    #define INTTYPE 7     
    #define RETURN 8      
    #define VOIDTYPE 9    

    /* identifier */
    #define IDENTIFIER 10      

    /* constants */
    #define INTEGER_CONSTANT 11     
    #define CHARACTER_CONSTANT 12   

    /* string literal */
    #define STRING_LITERAL 13       

    #define WHITESPACE 14  
    #define NEWLINE 15    

    /* punctuators */
    #define LEFT_SQUARE_BRACKET 16         
    #define RIGHT_SQUARE_BRACKET 17        
    #define LEFT_PARENTHESIS 18            
    #define RIGHT_PARENTHESIS 19           
    #define LEFT_CURLY_BRACKET 20          
    #define RIGHT_CURLY_BRACKET 21         
    #define ARROW 22               
    #define BITWISE_AND 23                 
    #define ASTERISK 24                    
    #define PLUS 25                        
    #define MINUS 26                       
    #define DIVIDE 27                      
    #define MODULO 28                      
    #define EXCLAMATION 29                 
    #define QUESTION_MARK 30              
    #define LESS_THAN 31                   
    #define GREATER_THAN 32                
    #define LESS_THAN_OR_EQUAL 33          
    #define GREATER_THAN_OR_EQUAL 34       
    #define EQUAL 35                       
    #define NOT_EQUAL 36                   
    #define LOGICAL_AND 37                 
    #define LOGICAL_OR 38                  
    #define ASSIGNMENT 39                  
    #define COLON 40                       
    #define SEMICOLON 41                   
    #define COMMA 42                       
%}

/* ----- Regular Expression----- */

/* keywords */
CHAR                            'char'
ELSE                            'else'
FOR                             'for'
IF                              'if'
INT                             'int'
RETURN                          'return'
VOID                            'void'

/* identifiers */
IDENTIFIER_NONDIGIT             "_"|[a-zA-Z]
DIGIT                           [0-9]
IDENTIFIER                      {IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*


/* constants */
SIGN                            [+-]
NONZERO_DIGIT                   [1-9]
INTEGER_CONSTANT                {SIGN}?{NONZERO_DIGIT}{DIGIT}*|"0"

ESCAPE_SEQUENCE                 "\\\'"|"\\\""|"\\?"|"\\\\"|"\\n"|"\\t"|"\\r"|"\\v"|"\\f"|"\\a"|"\\b"
C_CHAR                          [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUECNCE                {C_CHAR}+
CHARACTER_CONSTANT              \'{C_CHAR_SEQUECNCE}\'

/* string literals */
S_CHAR                          [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE                 {S_CHAR}
STRING_LITERAL                  \"{S_CHAR_SEQUENCE}?\"

/* punctuators */
PUNCTUATORS                     "["|"]"|"("|")"|"{"|"}"|"->"|"&"|"*"|"+"|"-"|"/"|"%"|"!"|"?"|"<"|">"|"<="|">="|"=="|"!="|"&&"|"||"|"="|":"|";"|","

/* comments */
SINGLE_LINE_COMMENT_BODY        [/][/][^\n]*
SEQUENCE                        [^*]|[*][^/]
MULTI_LINE_COMMENT_BODY         [/][*]{SEQUENCE}*[*][/]

WHITESPACE                      [ \t]+
NEWLINE                         \n

%%

"char"                              {return CHARTYPE;}
"else"                              {return ELSE;}
"for"                               {return FOR;}
"if"                                {return IF;}
"int"                               {return INTTYPE;}
"return"                            {return RETURN;}
"void"                              {return VOIDTYPE;}

{IDENTIFIER}                        {return IDENTIFIER;}

{INTEGER_CONSTANT}                  {return INTEGER_CONSTANT;}
{CHARACTER_CONSTANT}                {return CHARACTER_CONSTANT;}

{STRING_LITERAL}                    {return STRING_LITERAL;}

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

{MULTI_LINE_COMMENT_BODY}           {return MULTI_LINE_COMMENT_BODY;}
{SINGLE_LINE_COMMENT_BODY}          {return SINGLE_LINE_COMMENT_BODY;}


{WHITESPACE}                        { /* ignore */ }
{NEWLINE}                           { /* printf("\n ************* line %d***********\n\n", yylineo); */ }
.                                   { /* printf("line %d: error generating token %s\n", yylineno, yytext); */ }

%%