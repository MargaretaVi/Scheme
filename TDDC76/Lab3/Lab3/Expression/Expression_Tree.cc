/*
 * Expression_Tree.cc
 */
#include "Expression_Tree.h"
#include <typeinfo>
// INKLUDERA FÖR DET SOM KOMMER ATT ANVÄNDAS I DENNA FIL!
using namespace std;

// SEPARATA DEFINITIONER FÖR FÖR EXPRESSION_TREE-KLASSERNA DEFINIERAS HÄR.

template <class T, class S>
Binary_Operator<T,S>::~Binary_Operator(){
  delete left;
  delete right;  
}

/*
Binary_Operator implementerade funktioner
*/
template <class T, class S>
Binary_Operator<T,S>::Binary_Operator(T left_, S right_){
  left = left_;
  right = right_;
}

template <class T, class S>
string Binary_Operator<T,S>::str() const{
  return op_name;
}

template <class T, class S>
string Binary_Operator<T,S>::get_postfix() const{
  string s{""};
  if (left != nullptr){
    s += left->get_postfix();
    s += " ";
  }
  if (right!= nullptr){
    s += right->get_postfix();
    s += " ";
  }
  s += op_name;
  return s;
}

template <class T, class S>
void Binary_Operator<T,S>::print(ostream& out, int depth) const{
  right->print(out, depth+1);
  for(int i = 0; i < 2*depth; i++){
    cout << " ";
  }
  cout << "/" << endl;
  for(int i = 0; i < 2*depth-1; i++){
    cout << " ";
  }
  cout << str() << endl;
  for(int i = 0; i < 2*depth; i++){
    cout << " ";
  }
  cout << "\\" << endl;
  left->print(out, depth+1);
}
/*
__________________
*/

/*
Assign
*/

long double Assign::evaluate() const{
  // if(typeid(left) != typeid(Variable*)){
  //   throw exp_tree_exception("Otillatet att tilldela tal ett nytt varde.");
  // }
  Variable* temp = dynamic_cast<Variable*>(left);
  long double eval_val = right->evaluate();
  temp->set_value(eval_val);
  return eval_val;

}

Expression_Tree* Assign::clone() const {
 Assign* Clone = new Assign{dynamic_cast<Variable*>(left->clone()), right->clone()};
 return Clone;

}


/*
Plus
*/
long double Plus::evaluate() const {
  return left->evaluate() + right->evaluate();
}
//***********

Expression_Tree* Plus::clone() const {
 Plus* Clone = new Plus{left->clone(), right->clone()};
 return Clone;
}
/*
_____________
*/




/*
Minus
*/
long double Minus::evaluate() const {
  return left->evaluate() - right->evaluate();
}

//***********

Expression_Tree* Minus::clone() const {

 Minus* Clone = new Minus{left->clone(), right->clone()};
 return Clone;

}
/*
_____________
*/

/*
Times
*/

long double Times::evaluate() const {
  return left->evaluate() * right->evaluate();
}
//***********

Expression_Tree* Times::clone() const {
 Times* Clone = new Times{left->clone(), right->clone()};
 return Clone;

}
/*
____________
*/


/*
Divide
*/


long double Divide::evaluate() const {
  if(right->evaluate() == 0){
    throw exp_tree_exception("Division med 0 ej tillåtet");
  }
  return left->evaluate() / right->evaluate();
}
//***********

Expression_Tree* Divide::clone() const {
 Divide* Clone = new Divide{left->clone(), right->clone()};
 return Clone;
}
/*
______________
*/


/*
 Power
_______________
*/
long double Power::evaluate() const {
  long double temp = left->evaluate();
  long double temp2 = temp;

  for (long i = 2; i <= right->evaluate(); i++){
    temp = temp * temp2;
  }
  return temp;
}
//***********

Expression_Tree* Power::clone() const {
 Power* Clone = new Power{left->clone(), right->clone()};
 return Clone;
}
/*
_____________
*/

/*
Operand template class
*/
template <class T>
Operand<T>::Operand(T main_member_){
  main_member = main_member_;
}

//  template <class T>
//  long double Operand<T>::evaluate() const{
//    return main_member;
// }

template <class T>
string Operand<T>::get_postfix() const{
  string ret;
  stringstream s;
  s << main_member;
  s >> ret;
  return ret;
}

template <class T>
string Operand<T>::str() const{
  string ret;
  stringstream s;
  s << main_member;
  s >> ret;
  return ret;
}

template<class T>
void Operand<T>::print(ostream& out, int depth) const{
  for(int i = 0; i < (2*depth-1); i++){
    out << " ";
  }
  out << str() << endl;
}


/*
Integer
_______________
*/
//********
Expression_Tree* Integer::clone() const {
  return new Integer{main_member};
}

long double Integer::evaluate() const{
   return main_member;
}


/*
___________
*/
/*
Real
*/
//********

Expression_Tree* Real::clone() const {
  return new Real{main_member};
}

long double Real::evaluate() const{
   return main_member;
}



/*
__________
*/
/*
Variable
*/
long double Variable::evaluate() const{
  return value;
}
//********
Expression_Tree* Variable::clone() const {
  return new Variable{main_member, value};
}
//********
void Variable::set_value(long double  new_value){
  value = new_value;
}
//********
long double Variable::get_value(){
  return value;
}
/*
___________
*/

/*
Exception
*/
  const char* exp_tree_exception::what() const throw(){
    return what_.c_str();
}

// int main ()
// {
//   cout << "tja" << endl;
// }

// int main(){

//   // try{
//   // Times test{new Integer{5}, new Integer {2}};
//   // cout << test.op_name << endl;
//   // Times test2{test.clone(), new Integer{7}};
//   // cout << test.evaluate() << endl;
//   // //cout << test.left->number << endl;
//   // test.left = new Integer{3};
//   // cout << " " << test.left->str() << endl;
  
//   // cout << test2.evaluate() << endl;
//   // cout << test2.op_name << endl;

//   // Assign tester{new Variable{"x",0}, test.clone()};
//   // cout << tester.left->str() << endl;
  
//   // cout << tester.left->get_value() << endl;
//   // //cout << tester.left->str() << tester.str() << tester.left->get_value() << endl;
//   // tester.evaluate();
//   // // cout << tester.left->str() << tester.str() << tester.left->get_value() << endl;
//   // cout << tester.right->str() << endl;
//   // tester.print(cout, 1);

 
//   //   Divide Bad{new Real{7.44}, new Integer{0}};
//   //   cout << Bad.evaluate() << endl;
//   // }
//   // catch(const exp_tree_exception& e){
//   //   cout << e.what() << endl;
//   // }
//   // /*template test
//   // impmajs majsig{4, "hej"};
//   // majsig.print();
//   // */
//   return 0;
// }
