#include <stdio.h>
#include "parser.tab.h"

extern char* yytext;
extern int yyparse();

int main() 
{
  int token;
  yyparse();
  return 0;
}