%{
    /* Declarations and Definitions*/
    #include <string.h>
	#include <stdio.h>

    #include "translation.h"

    extern int yylex();
    extern type_e TYPE;
	void yyerror(const char *s);
%}

%union {
    
    express* express;
    statement* statement;

    unary* Array;
    symboltype* symbol_type;
    symbol* symbol_pointer;

    char* char_value;
    char unary_oper;

    int int_value;
    int instruction;
    int num_params;
    
}

%token <char_value> STRING_LITERAL
%token <char_value> CHARACTER_CONSTANT
%token <int_value> INTEGER_CONSTANT
%token <symbol_pointer> IDENTIFIER 

%token CHARTYPE ELSE FOR IF INTTYPE RETURN VOIDTYPE
%token LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET LEFT_SQUARE_BRACKET 
%token RIGHT_SQUARE_BRACKET LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token ARROW BITWISE_AND ASTERISK PLUS MINUS DIVIDE MODULO EXCLAMATION 
%token QUESTION_MARK LESS_THAN GREATER_THAN 
%token LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL EQUAL NOT_EQUAL
%token LOGICAL_AND LOGICAL_OR ASSIGNMENT COLON SEMICOLON COMMA

%start translation_unit

%type <express> 
    expression
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

%type <num_params>
    argument_expression_list
    argument_expression_list_opt

%type<Array>
    postfix_expression
    unary_expression


%type <symbol_type> 
    constant
    pointer

%type <symbol_pointer>
    initializer

%type <symbol_pointer>
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

//auxiliary non terminals
%type <statement>
    NEE
%type <instruction>
    MEE
   
%%

// ----------------- Expressions -----------------
primary_expression
    : IDENTIFIER {

      $$ = new express();
      $$->symbol_pointer = $1;
      $$->isbool =false;
    }

    | constant {
            
        $$ = new express();
        $$->symbol_pointer = $1;
    }

    | STRING_LITERAL {
    
        $$ = new express();
        $$->symbol_pointer = gentemp(PTR, $1);
        $$->symbol_pointer->initialize($1);
        $$->symbol_pointer->type->ptr = new symboltype(CHAR_1);
    }

    | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS {
        $$ = $2;
    }
    ;

constant
    : INTEGER_CONSTANT {
        $$=gentemp(INT_1,number_to_string($1));
        emit(EQUAL_1, $$->name, $1);
    }
    | CHARACTER_CONSTANT {
        $$=gentemp(CHAR_1);
        emit(EQUAL_1, $$->name, "a");
        
    }
    ;

postfix_expression
    : primary_expression{
        $$ = new unary();
        $$->symbol_pointer = $1->symbol_pointer;
        $$ ->loc = $$->symbol_pointer;
        $$->type = $1->symbol_pointer->type;
    }
    | postfix_expression LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET{
        $$ = new unary();
        $$ -> symbol_pointer = $1->symbol_pointer;
        $$-> type = $1->type->ptr;
        $$->loc = gentemp(INT_1);
        if($1->cat==ARR){
            symbol* t =gentemp(INT_1);
            emit(MULT_1, t->name, $3->symbol_pointer->name, number_to_string(size_of_type($$->type)));
            emit(ADD_1, $$->loc->name, $1->loc->name, t->name);
        }
        else{
            emit(MULT_1, $$->loc->name, $3->symbol_pointer->name, number_to_string(size_of_type($$->type)));
        }
        $$->cat =ARR;
    }

    | postfix_expression LEFT_PARENTHESIS RIGHT_PARENTHESIS
    | postfix_expression LEFT_PARENTHESIS argument_expression_list_opt RIGHT_PARENTHESIS{
        $$ = new unary();
        $$->symbol_pointer = gentemp($1->type->cat);
        emit(CALL, $$->symbol_pointer->name, $1->symbol_pointer->name. tostr($3));
    }
    | postfix_expression ARROW IDENTIFIER 
    ;

argument_expression_list_opt
    : argument_expression_list {$$=$1;}
    | 
    ;

argument_expression_list
    : assignment_expression {
        emit (PARAM, $1->symbol_pointer->name);
        $$ = 1;
    }
    | argument_expression_list COMMA assignment_expression {
        emit (PARAM, $3->symbol_pointer->name);
        $$ = $1+1;
    }
    ;

unary_expression
    : postfix_expression {
        $$ = $1;
    }
    | unary_operator unary_expression {
        $$ = new unary();
            if($1=='&'){
                $$->symbol_pointer = gentemp(PTR);
                $$->symbol_pointer->type->ptr = $2->symbol_pointer->type;
                emit(ADDRESS, $$->symbol_pointer->name, $2->symbol_pointer->name);
            } 
            else if($1=='*'){
                $$->cat = PTR;
                $$->loc = gentemp($2->symbol_pointer->type->ptr);
                emit(PTR_1, $$->loc->name, $2->symbol_pointer->name);
                $$->symbol_pointer = $$->symbol_pointer;
            }
            else if($1=='-'){
                $$->symbol_pointer = gentemp($2->symbol_pointer->type->cat);
                emit(UMINUS, $$->symbol_pointer->name, $2->symbol_pointer->name);
            }
            else if($1=='!'){
                $$->symbol_pointer = gentemp($2->symbol_pointer->type->cat);
                emit(LNOT, $$->symbol_pointer->name, $2->symbol_pointer->name);
            }
            else if($1=='+'){
                $$=$2;
            }
            else{}
    }
    ;

unary_operator
    : BITWISE_AND {
        $$ = '&';
    }
    | ASTERISK {
        $$ = '*';
    }
    | PLUS {
        $$ = '+';
    }
    | MINUS {
        $$ = '-';
    }
    | EXCLAMATION {
        $$ = '!';
    }
    ;

multiplicative_expression
    : unary_expression {
        $$= new express();
        if($1->cat==ARR){
            $$->symbol_pointer = gentemp($1->loc->type);
            emit(ARR_1, $$->symbol_pointer->name, $1->symbol_pointer->name, $1->loc->name);
        }
        else if($1->cat==PTR){
            $$->symbol_pointer = $1->loc;
        }
        else{
            $$->symbol_pointer = $1->symbol_pointer;
        }
    }
    | multiplicative_expression ASTERISK unary_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->symbol_pointer = gentemp($1->symbol_pointer->type->cat);
            emit(MULT_1, $$->symbol_pointer->name, $1->symbol_pointer->name, $3->symbol_pointer->name);
        }
        else cout << "Type Mismatch" << endl;
    }
    | multiplicative_expression DIVIDE unary_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->symbol_pointer = gentemp($1->symbol_pointer->type->cat);
            emit(DIV_1, $$->symbol_pointer->name, $1->symbol_pointer->name, $3->symbol_pointer->name);
        }
        else cout << "Type Mismatch" << endl;
    }
    | multiplicative_expression MODULO unary_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->symbol_pointer = gentemp($1->symbol_pointer->type->cat);
            emit(MOD_1, $$->symbol_pointer->name, $1->symbol_pointer->name, $3->symbol_pointer->name);
        }
        else cout << "Type Mismatch" << endl;
    }
    ;

additive_expression
    : multiplicative_expression {
        $$ = $1;
    }
    | additive_expression PLUS multiplicative_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->symbol_pointer = gentemp($1->symbol_pointer->type->cat);
            emit(ADD_1, $$->symbol_pointer->name, $1->symbol_pointer->name, $3->symbol_pointer->name);
        }
        else cout << "Type Mismatch" << endl;
    }
    | additive_expression MINUS multiplicative_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->symbol_pointer = gentemp($1->symbol_pointer->type->cat);
            emit(SUB_1, $$->symbol_pointer->name, $1->symbol_pointer->name, $3->symbol_pointer->name);
        }
        else cout << "Type Mismatch" << endl;
    }
    ;   

relational_expression
    : additive_expression {
        $$ = $1;
    }
    | relational_expression LESS_THAN additive_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->isbool = true;
            $$->truelist =makelist(nextinstr());
            $$->falselist =makelist(nextinstr()+1);
            emit(LESS_1, "", $1->symbol_pointer->name, $3->symbol_pointer->name);
            emit(GOTO, "");
           }
        else cout << "Type Mismatch" << endl;

    }
    | relational_expression GREATER_THAN additive_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->isbool = true;
            $$->truelist =makelist(nextinstr());
            $$->falselist =makelist(nextinstr()+1);
            emit(GREATER_1, "", $1->symbol_pointer->name, $3->symbol_pointer->name);
            emit(GOTO, "");
           }
        else cout << "Type Mismatch" << endl;
        
    }
    | relational_expression LESS_THAN_OR_EQUAL additive_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->isbool = true;
            $$->truelist =makelist(nextinstr());
            $$->falselist =makelist(nextinstr()+1);
            emit(LESS_OR_EQUAL_1, "", $1->symbol_pointer->name, $3->symbol_pointer->name);
            emit(GOTO, "");

           }
        else cout << "Type Mismatch" << endl;
    }
    | relational_expression GREATER_THAN_OR_EQUAL additive_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
            $$ = new express();
            $$->isbool = true;
            $$->truelist =makelist(nextinstr());
            $$->falselist =makelist(nextinstr()+1);
            emit(GREATER_OR_EQUAL_1, "", $1->symbol_pointer->name, $3->symbol_pointer->name);
            emit(GOTO, "");
           }
        else cout << "Type Mismatch" << endl;
    }
    ;

equality_expression
    : relational_expression {
        $$ = $1;
    }
    | equality_expression EQUAL relational_expression {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
           convert_from_bool($1);
           convert_from_bool($3);
           $$ = new express();
           $$->isbool = true;
           $$->truelist =makelist(nextinstr());
           $$->falselist =makelist(nextinstr()+1);
           emit(EQUAL_OP_1, "", $1->symbol_pointer->name, $3->symbol_pointer->name);
           emit(GOTO, "");
            
           }
        else cout << "Type Mismatch" << endl;
    }
    | equality_expression NOT_EQUAL relational_expression  {
        if (typecheck($1->symbol_pointer, $3->symbol_pointer)){
           convert_from_bool($1);
           convert_from_bool($3);
           $$ = new express();
           $$->isbool = true;
           $$->truelist =makelist(nextinstr());
           $$->falselist =makelist(nextinstr()+1);
           emit(NOT_EQUAL_OP_1, "", $$-> symbol_pointer->name, $1->symbol_pointer->name, $3->symbol_pointer->name);
           emit(GOTO, "");
            
           }
        else cout << "Type Mismatch" << endl;
    }
    ;

logical_AND_expression
    : equality_expression {
        $$ = $1;
    }
    | logical_AND_expression NEE LOGICAL_AND MEE equality_expression {
        convert_to_bool($5);
        backpatch($2->nextlist, nextinstr());
        convert_to_bool($1);
        $$ = new express();
        $$->isbool = true;
        backpatch($$->truelist, $4);
        $$->truelist = $5->truelist;
        $$->falselist = merge($1->falselist, $5->falselist);
        
    }
    ;

logical_OR_expression
    : logical_AND_expression {
        $$ = $1;
    }
    | logical_OR_expression NEE LOGICAL_OR MEE logical_AND_expression {
        convert_to_bool($5);
        backpatch($2->nextlist, nextinstr());
        convert_to_bool($1);
        $$ = new express();
        $$->isbool = true;
        backpatch($$->falselist, $4);
        $$->truelist = merge($1->truelist, $5->truelist);
        $$->falselist = $5->falselist;
    }
    ;

MEE 
    :
    {
        $$ = nextinstr();
    }
    ;

NEE 
    :
    {
        $$ = new express();
        $$->nextlist = makelist(nextinstr());
        emit(GOTO, "");
    }

conditional_expression
    : logical_OR_expression {
        $$ = $1;
    }
    | logical_OR_expression NEE QUESTION_MARK MEE expression NEE COLON MEE conditional_expression {
        $$->symbol_pointer = gentemp();
        $$->symbol_pointer->update($5->symbol_pointer->type);
        emit(EQUAL_1, $$->symbol_pointer->name, $9->symbol_pointer->name);
        listint l = makelist(nextinstr());
        emit(GOTO, "");
        backpatch($6->nextlist, nextinstr());
        emit(EQUAL_1, $$->symbol_pointer->name, $5->symbol_pointer->name);
        listint m = makelist(nextinstr());
        l = merge(l, m);
        emit(GOTO, "");
        backpatch($2->nextlist, nextinstr());
        convert_to_bool($1);
        backpatch($1->truelist, $4);
        backpatch($1->falselist, $8);
        backpatch(l, nextinstr());
    }
    ;

assignment_expression
    : conditional_expression {
        $$ = $1;
    }
    | unary_expression ASSIGNMENT assignment_expression {
        if($1->cat=ARR){
            $3->symbol_pointer = conv($3->symbol_pointer, $1->symbol_pointer->type->cat);
            emit(ARR_1, $1->symbol_pointer->name, $1->loc->name, $3->symbol_pointer->name);
        }
        else if($1->cat=PTR){
            emit(PTR_1, $1->symbol_pointer->name, $3->symbol_pointer->name);
        }
        else{
            $3->symbol_pointer = conv($3->symbol_pointer, $1->symbol_pointer->type->cat);
            emit(EQUAL_1, $1->symbol_pointer->name, $3->symbol_pointer->name);

        }
        $$=$3;
    }
    ;

expression
    : assignment_expression {
        $$ = $1;
        }
    ;

//------------- Declarations ----------------
declaration
    : type_specifier init_declarator SEMICOLON {

    }
    ;

init_declarator
    : declarator {
        $$ = $1;
    }
    | declarator ASSIGNMENT initializer {
        if($3->init!="" ) $1->initialize($3->init);
        emit(EQUAL_1, $1->name, $3->name);

    }
    ;

type_specifier
    : VOIDTYPE {
        TYPE = VOID_1;
    }
    | CHARTYPE {
        TYPE = CHAR_1;
    }
    | INTTYPE {
        TYPE = INT_1;
    }
    ;
declarator
    : pointer direct_declarator {
        symboltype *t = $1;
        while(t->ptr!=NULL) t = t->ptr;
        t->ptr = $2->type;
        $$ = $2->update($1);
        
    }
    | direct_declarator {}
    ;

direct_declarator
    : IDENTIFIER {
        $$ = $1->update(TYPE);
        currentsymbol = $$;
    }
    | IDENTIFIER LEFT_SQUARE_BRACKET integer_constant RIGHT_SQUARE_BRACKET
    | IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS
    | IDENTIFIER LEFT_PARENTHESIS ChangeSymbolTable parameter_list RIGHT_PARENTHESIS {
        table->tname = $1->name;
        
        if ($1 ->type->cat == VOID_1){
            symbol *s = table->lookup("retVal");
            s->update($1->type);
            
        }
       $1 = $1->linkst(table);
       table->parent = globalsymboltable;
       changetable(globalsymboltable);
       currentsymbol = $1;

    }
    ;

integer_constant
    : INTEGER_CONSTANT
    |
    ;

pointer
    : ASTERISK {
        $$ = new symboltype(PTR);
    }
    ;

parameter_list
    : parameter_declaration 
    | parameter_list COMMA parameter_declaration {

    }
    ;

parameter_declaration
    : type_specifier pointer IDENTIFIER {
        $2->category = "param";
    }
    ;



initializer
    : assignment_expression{
        $$ = $1->symbol_pointer;
    }
    ;

// ----------------- Statements -----------------
statement
    : compound_statement {
        $$ = $1;
    }
    | expression_statement {
        $$ = new statement();
        $$->nextlist = $1->nextlist;
    }
    | selection_statement {
        $$ = $1;
    }
    | iteration_statement {
        $$ = $1;
    }
    | jump_statement {
        $$ = $1;
    }
    ;

compound_statement
    : LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET{
        $$ = new statement();
    }
    | LEFT_CURLY_BRACKET block_item_list_opt RIGHT_CURLY_BRACKET{
        $$ = $2;
    }
    ;
block_item_list_opt
    : block_item_list {
        $$ = $1;}
    |
    ;

block_item_list
    : block_item {
        $$ = $1;
    }
    | block_item_list MEE block_item {
        $$ =$3;
        backpatch ($1->nextlist, $2);
    }
    ;
    
block_item
    : declaration {
        $$ = new statement();
    }
    | statement {
        $$ = $1;
    }
    ;

expression_statement
    : ';'{
        $$ = new express();
    }
    | expression SEMICOLON {
        $$ = $1; 
        }
    ;

selection_statement
    : IF LEFT_PARENTHESIS expression NEE RIGHT_PARENTHESIS MEE statement NEE {
        backpatch($4 -> nextlist, nextinstr());
        convert_to_bool($3);
        $$ = new statement();
        backpatch($3 ->truelist, $6);
        listint temp = merge($3-> faslelist, $7-> nextlist);
        $$->nextlist = merge($8->nextlist, temp);
    }
    | IF LEFT_PARENTHESIS expression NEE RIGHT_PARENTHESIS MEE statement NEE ELSE MEE statement {
        backpatch($4 -> nextlist, nextinstr());
        convert_to_bool($3);
        backpatch($3 ->truelist, $6);
        backpatch($3 ->falselist, $10);
        listint temp = merge($7->nextlist, $8-> nextlist);
        $$->nextlist = merge(temp, $11->nextlist);
    }
    ;

iteration_statement
    : FOR LEFT_PARENTHESIS expression MEE expression MEE expression NEE RIGHT_PARENTHESIS MEE statement {
        $$ = new statement();
        convert_to_bool($5);
        backpatch($5->truelist, $10);
        backpatch($8 ->nextlist, $4);
        backpatch($11->nextlist, $6);
        emit(GOTO, "", tostr($6));
        $$ ->nextlist = $5 ->falselist;

    }
    ;

jump_statement
    : RETURN SEMICOLON {
        $$ = new statement();
        emit(RETURN_1, "");
    }
    | RETURN expression SEMICOLON {
        $$ = new statement();
    }
    ;

// ----------------- Translation Unit -----------------
translation_unit
    : external_declaration 
    | translation_unit external_declaration {
        
    }
    ;

external_declaration
    : declaration 
    | function_definition 
    ;

ChangeSymbolTable
    : 
    {
        if (currentsymbol -> nest == NULL)changetable(new symboltable());
        else{
            changetable(currentsymbol->nest);
            emit(LABEL, table->ttable);
        } 
    }
    ;

function_definition
    : type_specifier declarator ChangeSymbolTable compound_statement {
        table -> parent = globalsymboltable;
        changetable(globalsymboltable);
    }
    ;

%%

void yyerror(const char *s) {
	printf("Error: %s on '%s'\n", s, yytext);
}
