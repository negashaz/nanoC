
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     CHARTYPE = 258,
     ELSE = 259,
     FOR = 260,
     IF = 261,
     INTTYPE = 262,
     RETURN = 263,
     VOIDTYPE = 264,
     IDENTIFIER = 265,
     INTEGER_CONSTANT = 266,
     CHARACTER_CONSTANT = 267,
     STRING_LITERAL = 268,
     CONSTANT = 269,
     LEFT_CURLY_BRACKET = 270,
     RIGHT_CURLY_BRACKET = 271,
     LEFT_SQUARE_BRACKET = 272,
     RIGHT_SQUARE_BRACKET = 273,
     LEFT_PARENTHESIS = 274,
     RIGHT_PARENTHESIS = 275,
     ARROW = 276,
     BITWISE_AND = 277,
     ASTERISK = 278,
     PLUS = 279,
     MINUS = 280,
     DIVIDE = 281,
     MODULO = 282,
     EXCLAMATION = 283,
     QUESTION_MARK = 284,
     LESS_THAN = 285,
     GREATER_THAN = 286,
     LESS_THAN_OR_EQUAL = 287,
     GREATER_THAN_OR_EQUAL = 288,
     EQUAL = 289,
     NOT_EQUAL = 290,
     LOGICAL_AND = 291,
     LOGICAL_OR = 292,
     ASSIGNMENT = 293,
     COLON = 294,
     SEMICOLON = 295,
     COMMA = 296
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 10 "parser.y"

int intval;



/* Line 1676 of yacc.c  */
#line 99 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


