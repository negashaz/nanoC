#include <stdio.h>

 /* comments */
#define MULTI_LINE_COMMENT_BODY 1    
#define SINGLE_LINE_COMMENT_BODY 2   

/* keywords */
#define CHARTYPE              3    
#define ELSE                  4        
#define FOR                   5         
#define IF                    6          
#define INTTYPE               7     
#define RETURN                8      
#define VOIDTYPE              9    

/*identifier*/
#define IDENTIFIER           10      

/* constants */
#define INTEGER_CONSTANT     11     
#define CHARACTER_CONSTANT   12   

/* string literal */
#define STRING_LITERAL       13       

#define WHITESPACE           14  
#define NEWLINE              15    

/* punctuators */
#define LEFT_SQUARE_BRACKET  16         
#define RIGHT_SQUARE_BRACKET 17        
#define LEFT_PARENTHESIS     18            
#define RIGHT_PARENTHESIS    19           
#define LEFT_CURLY_BRACKET   20          
#define RIGHT_CURLY_BRACKET  21         

#define ARROW                22               
#define BITWISE_AND          23                 
#define ASTERISK             24                    
#define PLUS                 25                        
#define MINUS                26                       
#define DIVIDE               27                      
#define MODULO               28                      

#define EXCLAMATION          29                 
#define QUESTION_MARK        30              

#define LESS_THAN            31                   
#define GREATER_THAN         32                
#define LESS_THAN_OR_EQUAL   33          
#define GREATER_THAN_OR_EQUAL 34       
#define EQUAL                35                       
#define NOT_EQUAL            36                   

#define LOGICAL_AND          37                 
#define LOGICAL_OR           38                  
#define ASSIGNMENT           39                  
#define COLON                40                       
#define SEMICOLON            41                   
#define COMMA                42 

extern int yylex();
extern char * yytext;
extern FILE * yyin;

int main(){
    FILE *testfile = fopen ("source_test_add.nc", "r");
    /* FILE *testfile = fopen ("source_test_max.nc", "r"); */

    if (!testfile){
        printf ("Error opening file. Check if it exists.\n");
        return -1;
    }

    yyin = testfile;
    int token;

    while(token = yylex()){
        switch (token){

            //-----------------COMMENTS-----------------
            case SINGLE_LINE_COMMENT_BODY: 
                printf("< SINGLE_LINE_COMMENT: ,%d, %s >\n", token, yytext);
                break;

            case MULTI_LINE_COMMENT_BODY: 
                printf("< MULTI_LINE_COMMENT: ,%d, %s >\n", token, yytext);
                break;

            //-----------------KEYWORDS-----------------
            case CHARTYPE:
                printf("< KEYWORD: CHAR, %d, %s >\n", token, yytext);
                break;
            case ELSE:
                printf("< KEYWORD: ELSE, %d, %s >\n", token, yytext);
                break;
            case FOR:
                printf("< KEYWORD: FOR, %d, %s >\n", token, yytext);
                break;
            case IF:
                printf("< KEYWORD: IF, %d, %s >\n", token, yytext);
                break;
            case INTTYPE:
                printf("< KEYWORD: INT, %d, %s >\n", token, yytext);
                break;
            case RETURN:
                printf("< KEYWORD: RETURN, %d, %s >\n", token, yytext);
                break;
            case VOIDTYPE:
                printf("< KEYWORD: VOID, %d, %s >\n", token, yytext);
                break;

            //-----------------IDENTIFIERS-----------------
            case IDENTIFIER:
                printf("< IDENTIFIER:, %d, %s >\n", token, yytext);
                break;
            
            //-----------------CONSTANTS-----------------
            case INTEGER_CONSTANT:
                printf("< INTEGER CONSTANT:, %d, %s >\n", token, yytext);
                break;
            case CHARACTER_CONSTANT:
                printf("< CHARACTER CONSTANT:, %d, %s >\n", token, yytext);
                break;

            //-----------------STRING LITERALS-----------------
            case STRING_LITERAL:
                printf("< STRING LITERAL:, %d, %s >\n", token, yytext);
                break;

            //-----------------PUNCTUATORS-----------------
            case LEFT_SQUARE_BRACKET:
                printf("< PUNCTUATOR: LEFT SQUARE BRACKET, %d, %s >\n", token, yytext);
                break;
            case RIGHT_SQUARE_BRACKET:
                printf("< PUNCTUATOR: RIGHT SQUARE BRACKET, %d, %s >\n", token, yytext);
                break;
            case LEFT_PARENTHESIS:
                printf("< PUNCTUATOR: LEFT PARENTHESIS, %d, %s >\n", token, yytext);
                break;
            case RIGHT_PARENTHESIS:
                printf("< PUNCTUATOR: RIGHT PARENTHESIS, %d, %s >\n", token, yytext);
                break;
            case LEFT_CURLY_BRACKET:
                printf("< PUNCTUATOR: LEFT CURLY BRACKET, %d, %s >\n", token, yytext);
                break;
            case RIGHT_CURLY_BRACKET:
                printf("< PUNCTUATOR: RIGHT CURLY BRACKET, %d, %s >\n", token, yytext);
                break;
            case ARROW:
                printf("< PUNCTUATOR: ARROW, %d, %s >\n", token, yytext);
                break;
            case BITWISE_AND:
                printf("< PUNCTUATOR: BITWISE AND, %d, %s >\n", token, yytext);
                break;
            case ASTERISK:
                printf("< PUNCTUATOR: ASTERIK, %d, %s >\n", token, yytext);
                break;
            case PLUS:
                printf("< PUNCTUATOR: PLUS, %d, %s >\n", token, yytext);
                break;
            case MINUS:
                printf("< PUNCTUATOR: MINUS, %d, %s >\n", token, yytext);
                break;
            case DIVIDE:
                printf("< PUNCTUATOR: DIVIDE, %d, %s >\n", token, yytext);
                break;
            case MODULO:
                printf("< PUNCTUATOR: MODULO, %d, %s >\n", token, yytext);
                break;
            case EXCLAMATION:
                printf("< PUNCTUATOR: EXCLAMATION, %d, %s >\n", token, yytext);
                break;
            case QUESTION_MARK:
                printf("< PUNCTUATOR: QUESTION MARK, %d, %s >\n", token, yytext);
                break;
            case LESS_THAN:
                printf("< PUNCTUATOR: LESS THAN, %d, %s >\n", token, yytext);
                break;
            case GREATER_THAN:
                printf("< PUNCTUATOR: GREATER THAN, %d, %s >\n", token, yytext);
                break;
            case LESS_THAN_OR_EQUAL:
                printf("< PUNCTUATOR: LESS THAN OR EQUAL, %d, %s >\n", token, yytext);
                break;
            case GREATER_THAN_OR_EQUAL:
                printf("< PUNCTUATOR: GREATER THAN OR EQUAL, %d, %s >\n", token, yytext);
                break;
            case EQUAL:
                printf("< PUNCTUATOR: EQUAL, %d, %s >\n", token, yytext);
                break;
            case NOT_EQUAL:
                printf("< PUNCTUATOR: NOT EQUAL, %d, %s >\n", token, yytext);
                break;
            case LOGICAL_AND:
                printf("< PUNCTUATOR: LOGICAL AND, %d, %s >\n", token, yytext);
                break;
            case LOGICAL_OR:
                printf("< PUNCTUATOR: LOGICAL OR, %d, %s >\n", token, yytext);
                break;
            case ASSIGNMENT:
                printf("< PUNCTUATOR: ASSIGNMENT, %d, %s >\n", token, yytext);
                break;
            case COLON:
                printf("< PUNCTUATOR: COLON, %d, %s >\n", token, yytext);
                break;
            case SEMICOLON:
                printf("< PUNCTUATOR: SEMICOLON, %d, %s >\n", token, yytext);
                break;
            case COMMA:
                printf("< PUNCTUATOR: COMMA, %d, %s >\n", token, yytext);
                break;
        }
    }
    return 0;
}

int yywrap(){
    return 1;
}