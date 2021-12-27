flex plex.l
bison -d psynt.y
gcc lex.yy.c psynt.tab.c -o projet