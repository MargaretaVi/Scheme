// Laboration 1.1
/*
 * FILNAMN:       1-1.cc
 * LABORATION:    1-1
 * PROGRAMMERARE: Margareta Vi 920809-0309 Yi3
 *                
 * DATUM:         2014-10-01
 *
 * Detta program ska kunna konvertera ett inargument(heltal) mellan decimaltal, hexadecimalt 
 * och oktav och sedan skriva ut alla tal ifrån 1 framtill inargumentet i dessa tre talsystem
 * i tre kolumner.
 */

#include <iostream>
#include <string>
#include <iomanip>
using namespace std;

// funktionen som ska skriva ut tre kolumner.

void print_columns (int tal)
{
	if (tal > 0)
	{
	
		cout << "DEC" << setw(10) << "OKT" << setw(10) << "HEX" <<"\n\n";
		for (int i = 1; i <= tal; ++i)
		{
			cout << setw(2) << dec << i << setw(10) << oct << i << setw(10) << hex << i<< '\n';
		}
	}	
	else
	{
		cout << "Fel inmatningsvärde, försök igen\n";	
	}

}	

int main()
{
	int tal;
	
	cout << "Skriv in ett tal: ";
	cin >> tal;
	
	for (tal < 0)
	{
		cout << "Fel inmatningsvärde, försök igen\n";
		cout << "Skriv in ett tal: ";
		cin >> tal;
	}
	print_columns(tal);
	
	return 0;
}	
	