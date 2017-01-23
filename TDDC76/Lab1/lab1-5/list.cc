# Filnamn:  list.cc
# Laboration: 1-5
# Programmerare: Margareta Vi 19920809-0309 Yi3
# Datum: 2014-10-05
# Beskrivning: funktionsdefinitions filen för  lab 1-5.

#include "Lab1-5.h"
#include <iostream>
using namespace std;
 	 
//constructors
List_Node::List_Node()
{
  name = "";
  age = 0;
  next = nullptr;
}	

List_Node::List_Node(const string name_in, int age_in, List_Node* next_in)
{
  name = name_in;
  age = age_in;
  next = next_in;
}
		
List_Node::List_Node(const string name_in, int age_in)
{
  name= name_in;
  age = age_in;	
  next = nullptr;
}


//destructor
List_Node::~List_Node()
{
  delete next;
}

	
//funktionen som lägger en nod sist i listan.
void append (List_Node* &current_list, const string& name_in,const int age_in)
{ 
  auto p = new List_Node{name_in, age_in, nullptr}; // auto = List_Node* som kräver något som returnerar saker.
  if (current_list == nullptr)
    {
      current_list = p;
      return;
    }	
  auto last = current_list;
  while (last->next != nullptr)
    {
      last = last->next;
    }  
  last->next = p;
}


// sätter in en nod i början av listan.
void insert(List_Node* &current_list, const string& name,const int age)
{
  auto pointer = new List_Node(name, age);
  if(current_list == nullptr)
    {
      current_list = pointer;
    }
  else
    {
      pointer->next = current_list;	
      current_list = pointer;
    }
}

// Kollar om listan är tom, isf returnera sant.
bool empty(List_Node* &current_list)
{
  if (current_list == nullptr)
    {
      return true;
    }
  else
    {
      return false;
    }
}

// Gör en lista tom.
void clear (List_Node* &current_list)
{
  delete current_list;
  current_list = nullptr;
}
	
//skriver ut noden med namn och åldern.	
void print(List_Node*& current_list)
{
  for (auto pointer = current_list; pointer != nullptr ; pointer = pointer->next)
    {
      cout << "->" << pointer-> name << "("<< pointer -> age <<")\n";

    }
}	

// Skriver ut som print() men i omvänd ordning.
void print_reverse(List_Node* current_list)
{
	
  if (current_list->next != nullptr)
    {
      print_reverse(current_list->next);
    }
	
  cout << current_list->name << " " << current_list->age << endl;
	
}

//En hjälpfunktion till reverse.
void reverse_help(List_Node* current_list, List_Node* before,List_Node* &first)
{
  if (current_list->next != nullptr)
    {
      reverse_help(current_list->next, current_list ,first);
		
    }
  else if(current_list->next == nullptr)
    {
      first = current_list;
		
    }
  current_list->next = before; 
}

//Funktionen som ska vända på listan.
void reverse(List_Node* &current_list)
{
  if (current_list->next != nullptr)
    {
      reverse_help(current_list, nullptr ,current_list);
    }
	
}

// Byter innehåller i två listor med varann
void swap(List_Node* &lista_1, List_Node* &lista_2)
{
  List_Node* currentlist = lista_1;
  lista_1 = lista_2;
  lista_2 = currentlist;
}
	
// Skapar en kopia av en lista.
List_Node* copy(List_Node* &current_list)		
{
  if(empty(current_list))
    {
      return nullptr;
    }
  auto pek = new List_Node(current_list->name, current_list->age, nullptr);
  List_Node* new_list = point;
  List_Node* temp_point = nullptr;

  while(List_Node*->next != nullptr)
    {
      current_list = current_list->next;
      temp_point = point;
      point = new List_Node*(current_list->name, current_list->age, nullptr);
      temp_point->next=point;
    } 
  return copylist;
	
}
/*
  int main()
  {
  List_Node* test_list = {};
  insert(test_list, "joel", 89);
  print(test_list);
	
  return 0;
  }
*/

