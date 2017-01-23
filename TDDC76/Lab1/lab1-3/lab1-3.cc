/*
 * FILNAMN:       1-3.cc
 * LABORATION:    1-3
 * PROGRAMMERARE: Margareta Vi 920809-0309 Yi3
 *                
 * DATUM:         2014-10-01
 *
 * Programmet ska ta in en sträng och räkna antalet bokstäver, blanksteg,siffor och totala
 * antalet tecken det finns i strängen.
 */

#include <iostream>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

using namespace std;

int main ()
{

	//definierar variabler som används, och ansätter de till 0
	
	int alpha {0};
	int digit {0};
	int punkt {0};
	int space {0};
	int total {0};
	string indata;
	
	cout << "Mata in en textsnutt:\n";
	getline(cin,indata);
	total = indata.size();	
	
	
	// räknar upp de olika variablerna
	for (int i = 0; i <= total; ++i)
	{
		if (isspace(indata[i]))
		{
			++space;
		}	
		else if (isdigit(indata[i]))
		{
			++digit;	
		}
		else if (isalpha(indata[i]))
		{	
			++alpha;
		}		
		else if (ispunct(indata[i]))
		{	
			++punkt;
		}				
	}
	cout << alpha << " Bokstäver\n";
	cout << digit << " Siffror\n";
	cout << punkt << " Punkter\n";
	cout << space << " Mellanslag\n";
	cout << total << " Tecken totalt\n";
	return 0;	
}	
