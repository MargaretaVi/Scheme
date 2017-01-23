/*
 * FILNAMN:       1-2.cc
 * LABORATION:    1-2
 * PROGRAMMERARE: Margareta Vi 920809-0309 Yi3
 *                
 * DATUM:         2014-10-01
 *
 * Programmet Konverterar mellan olika temperaturskalor
 */

#include <iostream>
#include <iomanip>
using namespace std;

	
int main()
{
	double degree {1};
	
	while (degree > 0)
	{
		cout << "Skriv in en temperatur i Kelvin:\n ";
		cin >> degree;		
			
		while (degree < 0)
		{	
			cout << " Negativa värden ej tillåtna, försök igen\n";
			cin >> degree;
		}	
		
		cout << degree << " grader Kelvin motsvarar " << degree - 273.15 << 
		" grader Celsius eller " << 1.8*degree - 459.67 << " grader Fahrenheit\n";
	}		 
	
	return 0;
}