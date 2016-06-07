nilang.tab.c nilang.tab.h: nilang.y
	bison -d nilang.y

lex.yy.c: nilang.l nilang.tab.h
	flex nilang.l

nilang: lex.yy.c nilang.tab.c nilang.tab.h
	g++ -o nilang lex.yy.c nilang.tab.c  
