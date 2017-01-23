/*
 FILNAMN:       1-5.cc
 * LABORATION:    1-5
 * PROGRAMMERARE: Margareta Vi 920809-0309 Yi3
 *                
 * DATUM:         2014-10-06
 *
 * Detta program ska kunna ta in en fil med lista, där programmet ska räkna vilka ord 
 * som har förekommit, samt antalet gånger ordet kommit upp.
 */
 

// Inkluderingar efter behov
#include "lab1-5.h"
#include <iostream>
#include <fstream>
	 	 	 
using namespace std;	 


// Deklarera en funktion build_lists(inström, list_1, list_2) som läser namn 
// från inströmmen och använder insert() för att sätta in i list_1 och append()
// för att sätta in i list_2. build_lists() ska definieras efter main().
void build_lists(fstream &file, List_Node* &list_1, List_Node* &list_2);

	
// Komplettera och modifiera:

int main()
{
   // Kontrollera att ett argument (filnamn) angivits på kommandoraden.
   // Om inte skriv ut ett felmeddelande och avsluta programmet.
	ifstream file;
	string filename;
	cout << "skriv in filnamnet\n";

   // Öppna en infilström för den fil vars namn givits på kommandoraden. 
   // Kontrollera att öppningen lyckas, om inte ska ett felmeddelande 
   // skrivas ut och programmet avslutas.
	getline(cin,filename);
	if(filename == "" || filename == "\n")
	{
	cout << "Kunde ej öppna fil\n";	
	}	
	else
	{
		file.open(filename);
		if(file.is_open())
		{
		   // Deklarera två tomma listor, list_1 och list_2
			List_Node* list_1 = {};
			List_Node* list_2 = {};
			
		  // Kontrollera med empty() att listorna är tomma och skriv ut det.
			if(empty(list_1) && empty(list_2))
			{
				cout << "Listorna är tomma\n";
			}
			
   // Anropa build_lists() för att läsa namn från indata och sätta in i namnen
   // i list_1 och list_2, enligt vad som sagts om build_lists() ovan.
		
   
	    cout << "Lista 1 efter inläsning av namn:\n";
	    // Skriv ut list_1 med print()
			print(list_1);
			cout<< endl;

	     // Skriv ut list_2 med print()
			cout << "Lista 2 efter inläsning av namn:\n";
			print(list_2);
			cout<< endl;
	   
			
			cout << "Lista 1 utskriven i omvänd ordning:\n";
	    // Skriv ut list_1 med print_reversed()
			print_reverse(list_1);
			cout << endl;
		
		
	    cout << "Lista 1 vänds.\n";
	    // Vänd innehållet i list_1 med reverse();
			reverse(list_1);
	    cout << "Lista 1 efter vändning:\n";
	    // Skriv ut list_1 med print()
			print(list_1);
			
	    cout << "Lista 2 raderas.\n";
	    // Radera list_2 med clear()
			clear(list_2);
			
	    if (empty(list_2))
	       cout << "Lista 2 är tom.\n";
	    else
	       cout << "Lista 2 är inte tom.\n";

	    cout << "Lista 2 tilldelas en kopia av lista 1.\n";
	    // Använd copy() för att kopiera list_1
			list_2 = copy(list_1);
			
	    cout << "Lista 2 innehåller:\n";
	    // Skriv ut list_2 med print()
			print(list_2);

	    cout << "Lista 2 raderas.\n";
	    // Radera list_2 med clear()
			clear(list_2);
	    cout << "Lista 1 och 2 byter innehåller.\n";
	    // Använd swap()
			swap(list_1, list_2);
			
	    if (empty(list_1))
	       cout << "Lista 1 är tom.\n";
	    else
	       cout << "Lista 1 är inte tom.\n";
	    cout << "Lista 2 innehåller:\n";
	    // Skriv ut list_2 med print()
			print(list_2);

	    cout << "Lista 2 raderas.\n";
	    // Radera list_2 med clear()
			clear(list_2);
			
	    // Kontrollera med empty() att listorna är tomma och skriv ut det.
			if (empty(list_1) && empty(list_2))
			{
				cout << "listorna är tomma\n";
			}
			else
			{
				cout << "listorna är ej tomma\n";
			}
	    cout << "Programmet avslutas.\n";
		}
		else
		{
			cout << "filen kunde ej öppnas\n";
		}

	}
   return 0;
}

// void buildlists


// Deklarera en funktion build_lists(inström, list_1, list_2) som läser namn 
// från inströmmen och använder insert() för att sätta in i list_1 och append()
// för att sätta in i list_2. build_lists() ska definieras efter main().

void build_list(fstream &file, List_Node* list_1, List_Node* list_2)
{
	string name;
	int age;
	
	while(!file.eof())
	{
		file >> name;
		file >> age;
		insert(list_1, name ,age );
		append(list_2, name ,age );
	}
}