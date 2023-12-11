
#include <bits/stdc++.h>
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;
extern char* yytext;
extern int yyparse();

//classes
class symboltab;
class symbol;
class quad;
class quads;
class symboltype;

enum type_e{
    INT_1,
    CHAR_1,
    VOID_1,
    ARR,
    PTR,
    FUNC
};

enum optype{
    EQUAL_1,  MULT_1,  ADD_1, MOD_1, DIV_1, SUB_1, 

    LESS_1,GREATER_1, LESS_OR_EQUAL_1, GREATER_OR_EQUAL_1, EQUAL_OP_1, NOT_EQUAL_OP_1, 
    
    ARR_1, PTR_1, PTR_2, ARR_2,
    LNOT, UMINUS,

    RETURN_1, GOTO,  PARAM, ADDRESS, CALL, LABEL
};

class symboltype{
public:
    symboltype(type_e cat, symboltype* ptr = NULL, int width = 1);
    type_e cat;
    int width;
    symboltype* ptr;

    friend ostream& operator<<(ostream&, const symboltype);
};

class symbol{
public:
    string name;
    symboltype *type;
    string init;
    string category;
    int size;
    int offset;
    symboltab* nest;

    symbol (string, type_e t= INT_1, symboltype* ptr = NULL, int width = 0);
    symbol* update(symboltype * t);
    symbol* update(type_e t);
    symbol* initialize(string);
    friend ostream& operator<<(ostream&, const symbol*);
    symbol* linkst(symboltab* t);
};

class symboltab{
public:
    string tname;
    int tcount;
    list<symbol*> table;
    symboltab* parent;

    symboltab (string name="");
    symbol* lookup (string name);
    void print(int all = 0);
    void computeoffsets();
};

class quad{
public:
    optype op;
    string result;
    string arg1;
    string arg2;

    void print();
    void update(int addr);
    quad(string results, string arg1, optype op = EQUAL_1, string arg2 = "");
    quad(string results, int arg1, optype op = EQUAL_1, string arg2 = "");
};

class quads{
public:
    vector <quad> array;;
    quadarry () {array.reserve(300);}
    void print ();
    void printtab();

};


symbol* gentemp (type_e t = INT_1, string init ="");
symbol* gentemp (symboltype* t, string init ="");

void backpatch(list<int>, int);

void emit(optype opL, string result, string arg1="", string arg2="");
void emit(optype op, string result, int arg1, string arg2="");

typedef list<int> listint;

list<int> makelist(int);

list<int> merge(list<int> &, list<int> &);

int size_of_type(symboltype*);

string convert_to_string(const symboltype*);

string op_to_str(int);

symbol* conv(symbol*, type_e);
bool typecheck(symbol* &s1, symbol* &s2);
bool typecheck(symboltype* s1, symboltype* s2);

int nextinstr();
string number_to_string(int);

void changetable(symboltab* newtable);

extern symboltab* globalsymboltable;
extern symboltab* table;
extern quads quadarr;
extern symbol* currentsymbol;

// Path: nanoC/Semantic_Analysis/translator.cpp

struct express{
    bool isbool;
    symbol* symbol_pointer;
    listint truelist;
    listint falselist;
    listint nextlist;
};

struct statement{
    listint nextlist;
};

struct unary{
    type_e cat;
    symbol* loc;
    symbol* symbol_pointer;
    symboltype* type;
};

template <typename T> string tostr(const T& t){
    ostringstream os;
    os<<t;
    return os.str();
}
express* convert_to_Bool(express*);
express* convert_from_bool(express*);

void printlist (listint list);
