%{ /* C Declarations and Definitions */
	#include <string.h>
	#include <stdio.h>

    #include "translation_unit.h"

	extern int yylex();
    extern int yytext();
	void yyerror(char *s);
%}

%union {
int int_val;
int instruction_num;
int param_num;

char* char_val;
char unary_oper;

Symboltype* symbol_type;
Symbol* symbol_pointer;

Expression* expression;
Statement* statement;
Array* Array;
}

%token <symbol_pointer> IDENTIFIER
%token <int_val> INTEGER_CONSTANT
%token <char_val> CHARACTER_CONSTANT
%token <char_val> STRING_LITERAL

%token CHARTYPE ELSE FOR IF INTTYPE RETURN VOIDTYPE
%token LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token ARROW BITWISE_AND ASTERISK PLUS MINUS DIVIDE MODULO EXCLAMATION QUESTION_MARK LESS_THAN GREATER_THAN 
%token LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL EQUAL NOT_EQUAL LOGICAL_AND LOGICAL_OR ASSIGNMENT COLON SEMICOLON COMMA

%type <expression> 
    expression
    expression_opt
    primary_expression
    multiplicative_expression
    additive_expression
    relational_expression
    equality_expression
    logical_AND_expression
    logical_OR_expression
    conditional_expression
    assignment_expression
    expression_statement

%type <unary_oper>
    unary_operator

%type <param_num>
    argument_expression_list
    argument_expression_list_opt

%type<Array>
    postfix_expression
    unary_expression

%type <symbol_type> 
    pointer

%type <symbol_pointer>
    initializer
    direct_declarator
    init_declarator
    declarator

%type <statement>
    statement
    compound_statement
    block_item_list
    block_item_list_opt
    block_item
    selection_statement
    iteration_statement
    jump_statement

%start translation_unit
%%

// ----------------- Expressions -----------------
primary_expression
    : IDENTIFIER {printf("primary-expression\n");}
    | CONSTANT {printf("primary-expression\n");}
    | STRING_LITERAL {printf("primary-expression\n");}
    | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS {printf("primary-expression\n");}
    ;

postfix_expression
    : primary_expression {printf("postfix-expression\n");}
    | postfix_expression LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET {printf("postfix-expression\n");}
    | postfix_expression LEFT_PARENTHESIS argument_expression_list_opt RIGHT_PARENTHESIS {printf("postfix-expression\n");}
    | postfix_expression ARROW IDENTIFIER {printf("postfix-expression\n");}
    ;

argument_expression_list_opt
    : argument_expression_list
    |
    ;

argument_expression_list
    : assignment_expression {printf("argument-expression-list\n");}
    | argument_expression_list COMMA assignment_expression {printf("argument-expression-list\n");}
    ;

unary_expression
    : postfix_expression {printf("unary-expression\n");}
    | unary_operator unary_expression {printf("unary-expression\n");}
    ;

unary_operator
    : BITWISE_AND {printf("unary-operator\n");}
    | ASTERISK {printf("unary-operator\n");}
    | PLUS {printf("unary-operator\n");}
    | MINUS {printf("unary-operator\n");}
    | EXCLAMATION {printf("unary-operator\n");}
    ;

multiplicative_expression
    : unary_expression {printf("multiplicative-expression\n");}
    | multiplicative_expression ASTERISK unary_expression {printf("multiplicative-expression\n");}
    | multiplicative_expression DIVIDE unary_expression {printf("multiplicative-expression\n");}
    | multiplicative_expression MODULO unary_expression {printf("multiplicative-expression\n");}
    ;

additive_expression
    : multiplicative_expression {printf("additive-expression\n");}
    | additive_expression PLUS multiplicative_expression {printf("additive-expression\n");}
    | additive_expression MINUS multiplicative_expression {printf("additive-expression\n");}
    ;   

relational_expression
    : additive_expression {printf("relational-expression\n");}
    | relational_expression LESS_THAN additive_expression {printf("relational-expression\n");}
    | relational_expression GREATER_THAN additive_expression {printf("relational-expression\n");}
    | relational_expression LESS_THAN_OR_EQUAL additive_expression {printf("relational-expression\n");}
    | relational_expression GREATER_THAN_OR_EQUAL additive_expression {printf("relational-expression\n");}
    ;

equality_expression
    : relational_expression {printf("equality-expression\n");}
    | equality_expression EQUAL relational_expression {printf("equality-expression\n");}
    | equality_expression NOT_EQUAL relational_expression  {printf("equality-expression\n");}
    ;

logical_AND_expression
    : equality_expression {printf("logical-AND-expression\n");}
    | logical_AND_expression LOGICAL_AND equality_expression {printf("logical-AND-expression\n");}
    ;

logical_OR_expression
    : logical_AND_expression {printf("logical-OR-expression\n");}
    | logical_OR_expression LOGICAL_OR logical_AND_expression {printf("logical-OR-expression\n");}
    ;

conditional_expression
    : logical_OR_expression {printf("conditional-expression\n");}
    | logical_OR_expression QUESTION_MARK expression COLON conditional_expression {printf("conditional-expression\n");}
    ;

assignment_expression
    : conditional_expression {printf("assignment-expression\n");}
    | unary_expression ASSIGNMENT assignment_expression {printf("assignment-expression\n");}
    ;

expression
    : assignment_expression {printf("expression\n");}
    ;

//------------- Declarations ----------------
declaration
    : type_specifier init_declarator SEMICOLON {printf("declaration\n");}
    ;

init_declarator
    : declarator {printf("init-declarator\n");}
    | declarator ASSIGNMENT initializer {printf("init-declarator\n");}
    ;

type_specifier
    : VOIDTYPE {printf("type-specifier\n");}
    | CHARTYPE {printf("type-specifier\n");}
    | INTTYPE {printf("type-specifier\n");}
    ;

declarator
    : pointer_opt direct_declarator {printf("declarator\n");}
    ;
pointer_opt
    : pointer
    |
    ;

direct_declarator
    : IDENTIFIER {printf("direct-declarator\n");}
    | IDENTIFIER LEFT_SQUARE_BRACKET integer_constant RIGHT_SQUARE_BRACKET {printf("direct-declarator\n");}
    | IDENTIFIER LEFT_PARENTHESIS parameter_list_opt RIGHT_PARENTHESIS {printf("direct-declarator\n");}
    ;

parameter_list_opt
    : parameter_list
    |
    ; 

integer_constant
    : INTEGER_CONSTANT
    |
    ;

pointer
    : ASTERISK {printf("pointer\n");}
    ;

parameter_list
    : parameter_declaration {printf("parameter-list\n");}
    | parameter_list COMMA parameter_declaration {printf("parameter-list\n");}
    ;

parameter_declaration
    : type_specifier pointer_opt identifier_opt {printf("parameter-declaration\n");}
    ;

identifier_opt
    : IDENTIFIER
    |
    ;

initializer
    : assignment_expression{printf("initializer\n");}
    ;

// ----------------- Statements -----------------
statement
    : compound_statement {printf("statement\n");}
    | expression_statement {printf("statement\n");}
    | selection_statement {printf("statement\n");}
    | iteration_statement {printf("statement\n");}
    | jump_statement {printf("statement\n");}
    ;

compound_statement
    : LEFT_CURLY_BRACKET block_item_list_opt RIGHT_CURLY_BRACKET{printf("compound-statement\n");}
    ;

block_item_list_opt
    : block_item_list
    |
    ;

block_item_list
    : block_item {printf("block-item_list\n");}
    | block_item_list block_item {printf("block-item_list\n");}
    ;
    
block_item
    : declaration {printf("block-item\n");}
    | statement {printf("block-item\n");}
    ;

expression_statement
    : expression_opt SEMICOLON {printf("expression-statement\n");}
    ;

expression_opt
    : expression
    |
    ;
    
selection_statement
    : IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement {printf("selection-statement\n");}
    | IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement ELSE statement {printf("selection-statement\n");}
    ;

iteration_statement
    : FOR LEFT_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RIGHT_PARENTHESIS statement {printf("iteration-statement\n");}
    ;

jump_statement
    : RETURN expression_opt SEMICOLON {printf("jump-statement\n");}
    ;

// ----------------- Translation Unit -----------------
translation_unit
    : external_declaration {printf("translation-unit\n");}
    | translation_unit external_declaration {printf("translation-unit\n");}
    ;

external_declaration
    : declaration {printf("external-declaration\n");}
    | function_definition {printf("external-declaration\n");}
    ;

function_definition
    : type_specifier declarator compound_statement {printf("function-definition\n");}
    ;

%%

void yyerror(char *s) {
	printf("Error: %s on '%s'\n", s, yytext);
}