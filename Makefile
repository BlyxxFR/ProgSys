all: compiler interpreteur

compiler.lex.yy.c: compilateur/compiler.l
	./lib/flex -o compiler.lex.yy.c compilateur/compiler.l

compiler.tab.c: compilateur/compiler.y 
	./bison/bin/bison -d -v compilateur/compiler.y

compiler: compiler.lex.yy.c compiler.tab.c compilateur/table_symboles.c compilateur/table_asm.c logger/logger.c
	gcc -o compiler compiler.tab.c logger/logger.c compilateur/table_symboles.c compilateur/table_asm.c compiler.lex.yy.c lib/libfl.a

test_compiler: compiler
	./compiler < code_test.c

interpreteur.lex.yy.c: interpreteur/interpreteur.l
	./lib/flex -o interpreteur.lex.yy.c interpreteur/interpreteur.l

interpreteur.tab.c: interpreteur/interpreteur.y
	./bison/bin/bison -d -v interpreteur/interpreteur.y

interpreter: interpreteur.lex.yy.c interpreteur.tab.c logger/logger.c interpreteur/memory.c
	gcc -o interpreter interpreteur.tab.c logger/logger.c interpreteur/table_instructions.c interpreteur/memory.c interpreteur.lex.yy.c lib/libfl.a

test_interpreteur: interpreter
	./interpreter < output/asm.s

test: test_compiler test_interpreteur