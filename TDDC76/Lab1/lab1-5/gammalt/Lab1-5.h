// lab1-5.h

#include <iostream>
#include <string>
using namespace std;

struct List_Node
{
	string name;
	int age;
	List_Node* next= nullptr; //default initisiering
	
	List_Node();
	List_Node(const string name, int age);
	List_Node(const string name, int age, List_Node* next);
	
	~List_Node();
	
};

void append (List_Node* &current_list, const string& name_in, int age_in);
void insert(List_Node* &current_list, const string& name, int age);
bool empty(List_Node* &current_list);
void clear (List_Node* &current_list);
void print(List_Node*& current_list);
void print_reverse(List_Node* current_list);
void reverse_help(List_Node* current_list, List_Node* before,List_Node* &first);
void reverse(List_Node* &current_list);
void swap(List_Node* &lista_1, List_Node* &lista_2);
List_Node* copy(List_Node* &current_list);

