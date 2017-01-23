#Makefile för att kompilera programmet main med g++

CCC = g++

CCFLAGS =  -g -std=c++11 -pedantic -Wall -Wextra -Werror

LDFLAGS = -L/sw/gcc-4.2.1/lib -static-libstdc++

main: list.o Lab1-5.o	
		$(CCC) $(CCFLAGS) $(LDFLAGS) Lab1-5.o list.o -o Lab1-5
Lab1-5.o: Lab1-5.cc
		$(CCC) $(CCFLAGS) -c Lab1-5.cc
list.o: list.cc 						
		$(CCC) $(CCFLAGS) -c list.cc			
clean:
	@ \rm -f *.o

