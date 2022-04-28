all: lexico

lexico: 	
	gcc -o lexico lex.yy.c -ll
