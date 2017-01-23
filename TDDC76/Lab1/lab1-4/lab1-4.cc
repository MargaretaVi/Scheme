/*
 * FILNAMN:       1-4.cc
 * LABORATION:    1-4
 * PROGRAMMERARE: Margareta Vi 920809-0309 Yi3
 *                
 * DATUM:         2014-10-05
 *
 * Detta program ska kunna ta in en fil med lista, där programmet ska räkna vilka ord 
 * som har förekommit, samt antalet gånger ordet kommit upp.
 */

#include <iostream>
#include <string>
#include <cctype>
#include <iomanip>
#include <vector>
#include <locale>
#include <stdio.h>
#include <ctype.h>
#include <utility>
#include <algorithm>
using namespace std;

struct word_entry
{	
	string word;
	int count = 1;	
};
				


//Den funktionen som skapar vektorer som läggs in i existerande lista

void add_to_vector(vector<word_entry>&  list, const string& word)
{
	vector<word_entry>::iterator it;
	vector<word_entry>::iterator position = list.begin();
	word_entry entry;
	entry.word = word;
	
	
	//Ifall listan är tom, lägger in ordet i listan
	if (list.size() == 0)
	{
		list.push_back(entry);
		cout << entry.word << " adderad i listan" << endl;	
	}	
	//ifall lista ej tom
	else
	{
	
		for(it=list.begin(); it!=list.end(); it++)
		{
			//om ordet finns i listan räkna upp
			if (it->word == word)
			{	
				it->count++;
				cout << word << " uppraknad" << endl;
				return;	
			}
			// Kollar ordets position i listan
			if (it->word < word)
			{	
				position = it;
				list.insert(position, entry);
				cout << "lägger in ordet på rätt plats\n";
				return;
			}
		}					
		
		// ordet finns inte i listan, lägger till den i listan
			if((it->word != word) && (it->word < word))
			{
			word_entry entry;
			entry.word = word;
			list.push_back(entry);	
			cout << entry.word << " adderad på ny plats " << endl;	
			}	
	}		
						
}

//Tar den inlästa ordet och konverterar dess bokstäver till gemener.
void tolowercase(string& word)
{
	transform(word.begin(),word.end(),word.begin(), ::tolower);
}	

//skriver ut den färdiga listan efter programslut
void print(const vector<word_entry>&  list)
{
	vector<word_entry>::const_iterator it;
	
	cout << setw(7) << "ord" << setw(8) << " antal" << endl;
	for(it=list.begin(); it!=list.end(); ++it)
	{
		cout << setw(7) << it->word << ":" << setw(6) << it->count << endl;
	}	

}	
	
int main () 
{
	//Skapar en lista där orden läggs in allt eftersom.
	vector<struct word_entry> list;
	string word = "";
	
	cout << "Skicka in texten som ska analyseras:" << endl;
	
	while(cin >> word)
	{
		tolowercase(word);
		add_to_vector(list, word);

	}	
	print(list);
}		
		
