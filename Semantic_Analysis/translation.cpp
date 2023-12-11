#include "translation.h"

symboltab* globaltable;
quads quadarr;
symboltab* table;
symbol* currentsymbol;
type_e TYPE;

int size_of_type(symboltype* a)
{
    if (a->cat == VOID_1) return 0;
    else if (a->cat == CHAR_1) return 1;
    else if (a->cat == INT_1) return 4;
    else if (a->cat == PTR) return 4;
    else if (a->cat == FUNC) return 0;
    else return a->width * size_of_type(a->ptr);
}

void symboltab::print(int all){
    list<symboltab*> t;
    cout <<"Symbol Table: " << this -> tname;
    cout << " " << "Parent:";

    if (this->parent!=NULL)
        cout<< this -> parent -> tname;
    else cout << "NULL";

    cout<<endl<<"name"<<" "<<"type"<<" "<<"category"<<" "<<"initial val."<<" "<<"size"<<"	"<<"offset"<<"	"<<"nest"<<endl<<endl;
    
    for (list<symbol*>::iterator it = table.begin(); it!=table.end(); it++) {
        cout << &*it;
        if (it->nest!=NULL) t.push_back (it->nest);
    }
    cout<<endl<<endl;

    if (all) {
        for (list<symboltab*>::iterator it1=t.begin();it1!=t.end();it1++) {
            (*it1)->print();
        }
    }

}

string convert_to_string(const symboltype* a)
{
    if (a == NULL) 
        return "NULL";
    else if (a->cat == VOID_1)
         return "void";
    else if (a->cat == INT_1)
         return "int";
    else if (a->cat == CHAR_1)
        return "char";
    else if (a->cat == FUNC)
        return "function";
    else if (a->cat == PTR)
        return "ptr(" + convert_to_string(a->ptr) + ")";
    else 
        return "arr(" + tostr(a->width) + "," + convert_to_string(a->ptr) + ")";
}

symboltype::symboltype(type_e cat, symboltype* ptr, int width)
{
    this->cat = cat;
    this->ptr = ptr;
    this->width = width;
}  

symbol* symboltab::lookup(string name){
    symbol* s;
    list<symbol>::iterator it;
    for (it = table.begin(); it!=table.end(); it++) {
        if (it->name == name) break;
    }
    if (it !=table.end()){
        return &*it;
    }
    else{
        s = new symbol(name);
        s->category ="local"
        table.push_back(*s);
        return &table.back();
    }

}

symbol* gentemp(type_e t, string init){
    char n[20];
    sprintf(n, "t%02d", table->tcount++);
    symbol* s = new symbol(n, t);
    s->category = "temp";
    s->init = init;
    table ->table.push_back ( *s);
    return &table->table.back();
}

symbol* gentemp(symboltype* t, string init){
    char n[20];
    sprintf(n, "t%02d", table->tcount++);
    symbol* s = new symbol (n);
    s->category = "temp";
    s->init = init;
    s->type = t;
    table ->table.push_back ( *s);
    return &table->table.back();
}

symboltab:: symboltab(string name)
{
    this ->tname =name;
    this ->tcount =0;
}

symbol* symbol::linkst(symboltable* t){
    this->nest = t;
    this ->category = "function";
}

osstream& operator<<(ostream& os, const symboltype* t)
{
    type_e cat = t->cat;
    string var = convert_to_string(t);
    os << var;
    return os;
}

ostream& operator<<(osstream& os, const symbol* it){
    os << left << setw(16) << it->name;
    os << left << setw(16) << it->type;
    os << left << setw(12) << it->category;
    os << left << setw(12) << it->init;
    os << left << setw(8) << it->size;
    os << left << setw(8) << it->offset;
    os << left
    if (it->nest == NULL) {
        os << "NULL" << endl;
    }
    else {
        os << it ->nest->tname << endl;
    }
    return os;
}

quad::quad(string result, string arg1, optype op, string arg2)
{
    this->result = result;
    this->arg1 = arg1;
    this->op = op;
    this->arg2 = arg2;
}

quad::quad(string result, int arg1, optype op, string arg2)
{
    this->result = result;
    this->arg1 = tostr(arg1);
    this->op = op;
    this->arg2 = number_to_string(arg1);
}

symbol::symbol(string name, type_e t, symboltype* ptr, int width){
    this ->name = name;
    this->type -new symboltype(symboltype(t, ptr, width));
    this->nest=NULL;
    this ->init ="";
    this-> category = "";
    this->size = size_of_type(this->type);
    this->offset = 0;    
}

symbol* symbol::initialize(string init){
    this->init = init;
}

void symboltab::computeoffsets(){
    list<symboltab*> tablelist;
    int off;
    for (list<symbol>::iterator it = table.begin(); it!=table.end(); it++) {
        if (it==table.begin()) {
            it->offset = 0;
            off = it->size;
        }
        else {
            it->offset = off;
            off = it->offset + it->size;
        }
        if (it->nest!=NULL) tablelist.push_back (it->nest);
    }
    for (list<symboltab*>::iterator iterator = tablelist.begin(); 
            iterator != tablelist.end(); 
            ++iterator) {
        (*iterator)->computeoffsets();
    }
}

symbol* symbol::update(symboltype* t){
    this->type = t;
    this->size = size_of_type(t);
    return this;
}

symbol* symbol::update(type_e t){
    this->type = new symboltype(t);
    this->size = size_of_type(this->type);
    return this;
}
void quad::update(int addr){
    this->result = addr;
}

void quad::print(){
    
    if (this->op == ADD_1)
        cout << this->result << " = " << this->arg1 << " + " << this->arg2;
    else if (this->op == SUB_1)
        cout << this->result << " = " << this->arg1 << " - " << this->arg2;
    else if (this->op == MULT_1)
        cout << this->result << " = " << this->arg1 << " * " << this->arg2;
    else if (this->op == DIV_1)
        cout << this->result << " = " << this->arg1 << " / " << this->arg2;
    else if (this->op == MOD_1)
        cout << this->result << " = " << this->arg1 << " % " << this->arg2;
    else if (this->op == EQUAL_1)
        cout << this->result << " = " << this->arg1;

    else if (this->op == EQUAL_OP_1)
        cout << "if " << this->arg1 << " == " << this->arg2 << " goto " << this->result;
    else if (this->op == NOT_EQUAL_OP_1)
        cout << "if " << this->arg1 << " != " << this->arg2 << " goto " << this->result;
    else if (this->op == LESS_1)
        cout << "if " << this->arg1 << " < " << this->arg2 << " goto " << this->result;
    else if (this->op == GREATER_1)
        cout << "if " << this->arg1 << " > " << this->arg2 << " goto " << this->result;
    else if (this->op == LESS_OR_EQUAL_1)
        cout << "if " << this->arg1 << " <= " << this->arg2 << " goto " << this->result;
    else if (this->op == GREATER_OR_EQUAL_1)
        cout << "if " << this->arg1 << " >= " << this->arg2 << " goto " << this->result;

    
    else if (this->op == GOTO)
        cout << "goto " << this->result;
    else if( this->op == ADDRESS)
        cout << this->result << " = &" << this->arg1;
    else if (this->op == PTR_1)
        cout << this->result << " = *" << this->arg1;
    else if (this->op == PTR_2)
        cout << "*" << this->result << " = " << this->arg1;
    else if(this->op == UMINUS)
        cout<<this->result<<"-"<<this->arg1;
    else if(this->op== LNOT)
        cout<<this->result<<" = !"<<this->arg1;
    else if (this->op == ARR_1)
        cout << this->result << " = " << this->arg1 << "[" << this->arg2 << "]";
    else if (this->op == ARR_2)
        cout << this->result << "[" << this->arg1 << "]" << " = " << this->arg2;  
    else if (this->op == PARAM)
        cout << "param " << this->result;
    else if (this->op == CALL)
        cout << this->result << " = " << "call " << this->arg1 << ", " << this->arg2;
    else if (this->op == RETURN_1)
        cout << "return " << this->result;
    else if (this->op == LABEL)
        cout << this->result << ":";
    else
        cout << "op";
    cout << endl;

}

void quads::printtable()
{
    cout<<"QUAD TABLE"<<endl;
    cout<<"  INDEX   OP   ARG1   ARG2";
    int i=this->array.size();
    for(int j=0;j<i;j++)
    	cout<<"   "<<(j+1)<<"   "<<op_to_str(this->array[j].op)<<"   "<<this->array[j].arg1<<"   "<<this->array[j].arg2<<endl;

}	

void backpatch(list<int> l,int addr)
{
        list<int>:: iterator it;
        for(it=l.begin();it!=l.end();it++)
                  quadarr.array[*it].result=tostr(addr);

}

void emit(optype op, string result, string arg1, string arg2) {
	quad *s;
	s=new quad(result,arg1,op,arg2);
	quadarr.array.push_back(*s);
}
void emit(optype op, string result, int arg1, string arg2) {
	quad *s;
	s=new quad(result,arg1,op,arg2);
	quadarr.array.push_back(*s);
}

string op_to_str(int op){
    
    if(op == ADD_1)
        return "+";
    else if(op == SUB_1)
        return "-";
    else if(op == MULT_1)
        return "*";
    else if(op == DIV_1)
        return "/";
    else if(op == MOD_1)
        return "%";
    else if(op == EQUAL_1)
        return "=";
    else if(op == EQUAL_OP_1)
        return "==";
    else if(op == NOT_EQUAL_OP_1)
        return "!=";
    else if(op == LESS_1)
        return "<";
    else if(op == GREATER_1)
        return ">";
    else if(op == LESS_OR_EQUAL_1)
        return "<=";
    else if(op == GREATER_OR_EQUAL_1)
        return ">=";
    else if(op == GOTO)
        return "goto";
    else if(op == ADDRESS)
        return "&";
    else if(op == PTR_1)
        return "*R";
    else if(op == PTR_2)
        return "*L";
    else if(op == UMINUS)
        return "-";
    else if(op == LNOT)
        return "!";
    else if(op == ARR_1)
        return "=[]R";
    else if(op == PARAM)
        return "param";
    else if(op == CALL)
        return "call";
    else if(op == RETURN_1)
        return "return";
    else
        return "op";
}

list<int> makelist (int i) {
    list<int> l(1,i);
    return l;
}

list<int> merge (list<int> &a, list <int> &b) {
	a.merge(b);
	return a;
}
int nextinstr() {
	return quadarr.array.size();
}
string number_to_string ( int Number ) {
	ostringstream ss;
	ss << Number;
	return ss.str();
}

void quads::print () {
	cout <<"" <<endl<<"PRINTING QUADS" <<endl<<""<<endl<< endl;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++) {
		if (it->op != LABEL) {
			cout<<"	"<<it-array.begin()<<":	";
			it->print();
		}
		else {
			cout << "\n";
			it->print();
			cout << "\n";
		}
	}
}

express* convert_to_bool(express* e){
    if (!e->isbool){
        e->falselist = makelist(nextinstr());
        emit (EQUAL_OP_1, "", e->symbol_pointer->name, "0");
        e->truelist = makelist(nextinstr());
        emit(GOTO, "");

    };
   
}

express* convert_from_bool(express* e){
    if (e->isbool){
        e-> symbol_pointer = gentemp(INT_1);
        backpatch(e->truelist, nextinstr());
        emit(EQUAL_1, e->symbol_pointer->name, "true");
        emit(GOTO, tostr (nextinstr()+1));
        backpatch(e->falselist, nextinstr()); 
        emit(EQUAL_1, e->symbol_pointer->name, "false");
    }
}

symbol* conv(symbol* s, type_e t){
    symbol* temp=gentemp(t);
    if(s->type->cat == INT_1){
        if(t==CHAR_1){
            emit(EQUAL_1, temp->name, "int2char(" + s->name + ")");
            return temp;
        }
        return s;
    }

    if(s->type->cat == CHAR_1){
        if(t==INT_1){
            emit(EQUAL_1, temp->name, "char2int(" + s->name + ")");
            return temp;
        }
        return s;
    }
}

void changetable(symboltab* newtable){
    table = newtable;
}
bool typecheck(symbol*& s1, symbol*& s2){
    symboltype* type1 = s1->type;
    symboltype* type2 = s2->type;
    if (typecheck(type1, type2)) return true;
    else if (s1 = conv(s1, type2->cat)) return true;
    else if (s2 = conv(s2, type1->cat)) return true;
    return false;
}

bool typecheck(symbotype* t1, symboltype* t2){
    if (t1 != NULL || t2 != NULL) {
        if (t1==NULL) return false;
        if (t2==NULL) return false;
        if (t1->cat==t2->cat) return (t1->ptr, t2->ptr);
        else return false;
    }
    return true;
}

int main(int argc, char* argv[]){
    globaltable = new symboltab("Global");
    table = globaltable;
    yyparse();
    table->computeoffsets();
    table->print(1);
    quadarr.print();
    int n, x;
    cin >> n;
    if (n==10) {
        while (n--) {
            cin >> x;
            if (x==1) {
                cout << "Enter the name of the symbol table: ";
            }
            else if(x==2){
                emit(ADD_1, "a", "b", "c");
            }
        }
    }
};

