all: compiler

lex.yy.c: compilateur/compiler.l
	./lib/flex compilateur/compiler.l

compiler.tab.c: compilateur/compiler.y 
	bison -d -v compilateur/compiler.y

compiler: lex.yy.c compiler.tab.c compilateur/table_symboles.c compilateur/table_asm.c logger/logger.c
	gcc -o compiler compiler.tab.c logger/logger.c compilateur/table_symboles.c compilateur/table_asm.c lex.yy.c lib/libfl.a

test: compiler
	./compiler < code_test.c
