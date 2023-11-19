
%{

%}

EOL \$
NUMBER [1-9][0-9]*
PUNCTUATOR [()]
OPERATOR [+\-*/%]
WS [ \n\t]

%%

{NUMBER}        {printf("<NUMBER,%s>\n",yytext);}
{PUNCTUATOR}    {printf("<PUNCTUATOR,%s>\n",yytext);}
{OPERATOR}      {printf("<OPERATOR,%s>\n",yytext);}
{EOL}           {printf("<EOL SYMBOL>\n");}
{WS}            ;

%%

int yywrap(){
    return 1;
}