# Makefile for compiling lexer.l and source_main.c on Windows

# Compiler
CC = gcc
LEX = flex

# Executable name
TARGET = nanoC_lexer.exe

# Source files
LEXER_SOURCE = lexer.l
MAIN_SOURCE = source_main.c

# Generated files
LEXER_OUTPUT = lex.yy.c

# Build rules
all: $(TARGET)

$(TARGET): $(LEXER_OUTPUT) $(MAIN_SOURCE)
	$(CC) -o $(TARGET) $(LEXER_OUTPUT) $(MAIN_SOURCE)

$(LEXER_OUTPUT): $(LEXER_SOURCE)
	$(LEX) $(LEXER_SOURCE)

run: $(TARGET)
	$(TARGET)

clean:
	del $(TARGET) $(LEXER_OUTPUT)

.PHONY: all run clean
