clear
echo "...Criando compilador"
flex nilang.l
bison -d nilang.y
g++ -o nilang lex.yy.c nilang.tab.c  
echo "Compilador pronto... Testando ./nilang"
echo "\nNilang_________________________________/|\_____\/______/|\_________________________\n"
./nilang helloworld.ni