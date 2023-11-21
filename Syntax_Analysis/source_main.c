#include <stdio.h>
#include "parser.tab.h"

extern char* yytext;
extern FILE* yyin;
extern int yyparse();

int main() 
{
  FILE *testfile = fopen("source_test_bubble.nc", "r");
  if (!testfile) {
    printf("Error: cannot open file\n");
    return -1;
  }
  yyin = testfile;
  
  yyparse();
  return 0;
}