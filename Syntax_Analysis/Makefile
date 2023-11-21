# Makefile for Lexer and Parser

# Compiler and compiler flags
CC = gcc

# Bison (parser generator) and Flex (lexical analyzer generator) commands
BISON = bison
FLEX = flex

# Output executable name
OUTPUT = parser.exe

# Source files
LEXER_SOURCE = lexer.l
PARSER_SOURCE = parser.y
MAIN_SOURCE = source_main.c
TEST_SOURCE = source_test_bubble.nc

# Default target
all: $(OUTPUT)

# Rule to generate the parser source and header files from the Bison file
parser.tab.c: $(PARSER_SOURCE)
	$(BISON) -d $^

# Rule to generate the lexer source file from the Flex file
lex.yy.c: $(LEXER_SOURCE)
	$(FLEX) $^

# Rule to build the parser executable
$(OUTPUT): parser.tab.c lex.yy.c $(MAIN_SOURCE)
	$(CC) -o $@ parser.tab.c lex.yy.c $(MAIN_SOURCE)

# Target to run the executable with the provided input
run: $(OUTPUT)
	.\$(OUTPUT) < $(TEST_SOURCE)

# Clean rule to remove generated files
clean:
	del /Q $(OUTPUT) lex.yy.c parser.tab.c parser.tab.h

# Phony target to prevent conflicts with files named 'clean', 'all', or 'run'
.PHONY: clean all run
