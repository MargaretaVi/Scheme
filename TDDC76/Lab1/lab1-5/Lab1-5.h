# Filnamn: Lab1-5.h
# Laboration: 1-5
# Programmerare: Margareta Vi 19920809-0309 Yi3
# Datum: 2014-10-05
# Beskrivning: deklarationsfilen för lab 1-5.

#include <iostream>
#include <string>
using namespace std;

struct List_Node
{
	string name;
	int age;
	List_Node* next= nullptr; //default initiering
	
	List_Node();
	List_Node(const string name, int age);
	List_Node(const string name, int age, List_Node* next);
	
	~List_Node();
	
};

void append (List_Node* &current_list, const string& name_in,const int age_in);
void insert(List_Node* &current_list, const string& name,const int age);
bool empty(List_Node* &current_list);
void clear (List_Node* &current_list);
void print(List_Node*& current_list);
void print_reverse(List_Node* current_list);
void reverse_help(List_Node* current_list, List_Node* before,List_Node* &first);
void reverse(List_Node* &current_list);
void swap(List_Node* &lista_1, List_Node* &lista_2);
List_Node* copy(List_Node* &current_list);

