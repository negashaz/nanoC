# First Phase: Lexical Analysis

## Files in the Directory:

- `lexer.l`: Lexical analyzer specification file written in Flex.
- `source_main.c`: Main source file containing the main function.
- `source_test.nc`: Sample nanoC source file for testing the lexer.
- `Makefile`: Makefile for building and running the lexer.

- `lex.yy.c`: Generated C file from Flex based on the lexer specification.
- `nanoC_lexer.exe`: Executable file for the nanoC lexer.

## How to Run the Makefile:

1. Ensure you have [MinGW](https://mingw-w64.org/doku.php) installed on your system, and the MinGW binaries (gcc.exe, flex.exe) are in your system's PATH.

2. Open the command prompt in the directory containing the files.

3. Run the following command to build and run the lexer:
   ```bash
   make run
