CC = gcc
LEX = flex
CFLAGS = -Wall

TARGET = compiler.exe

all: $(TARGET)

$(TARGET): lex.yy.c test.c
	$(CC) $(CFLAGS) -o $@ $^

lex.yy.c: test.l
	$(LEX) $^

test: $(TARGET) test.nc
	.\$(TARGET) < test.nc

clean:
	del /Q $(TARGET) lex.yy.c

.PHONY: all test clean
