#include <stdio.h>
#include "parser.tab.h"

extern int yyparse();

int main() {
  int token;
  yyparse();
  return 0;
}
