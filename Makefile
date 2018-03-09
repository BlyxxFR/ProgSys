all: compiler

lex.yy.c: source/compiler.l
	./lib/flex source/compiler.l

compiler.tab.c: source/compiler.y
	bison -d -v source/compiler.y
	yacc -d source/compiler.y

compiler: lex.yy.c compiler.tab.c
	gcc -o compiler compiler.tab.c lex.yy.c lib/libfl.a

test: compiler
	./compiler < code_test.c
