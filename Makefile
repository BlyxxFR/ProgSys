all: compiler

lex.yy.c: compiler.l
	./flex compiler.l

compiler.tab.c: compiler.y
	./bison/bin/bison -d -v compiler.y

compiler: lex.yy.c compiler.tab.c
	gcc -o compiler compiler.tab.c bison/lib/liby.a lex.yy.c libfl.a

test: compiler
	./compiler < code_test.c
