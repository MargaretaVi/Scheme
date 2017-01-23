# Filnamn: makefile
# Laboration: 1-5
# Programmerare: Margareta Vi 19920809-0309 Yi3
# Datum: 2014-10-05
# Beskrivning: makefil för lab 1-5.


CCC=g++

CCFLAGS= -g -std=c++11 -pedantic -Wall -Wextra -Werror

LDFLAGS= -L/sw/gcc-${GCC4_V}/lib -static-libstdc++


Lab1-5: list.o Lab1-5.o
	
	$(CCC) $(CCFLAGS) $(LDFLAGS)  Lab1-5.o list.o -o Lab1-5

lab2.o: Lab1-5.cc
	$(CCC) $(CCFLAGS) -c lab2.cc

monetary.o:list.cc 	
	$(CCC) $(CCFLAGS) -c list.cc	

# St‰da arbetsmappen
clean:
	@ \rm -f *.o 
