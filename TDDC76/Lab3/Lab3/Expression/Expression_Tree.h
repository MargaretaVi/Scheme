
/*
 * Expression_Tree.h
 */
#ifndef EXPRESSIONTREE_H
#define EXPRESSIONTREE_H
#include <iosfwd>
#include <string>
#include <stdexcept>
#include <iostream>
#include <sstream>

/*
 * expression_error: kastas om ett fel inträffar i en Expression-operation;
 * ett diagnostiskt meddelande ska skickas med.
 */
// ATT GÖRA!


// OBSERVERA: NEDANSTÅENDE ÄR ENDAST KODSKELETT - MODIFIERA OCH KOMPLETTERA!

/*
 * Expression_Tree: Abstrakt, polymorf basklass för alla trädnodklasser.
 */

using namespace std;
class Expression_Tree
{
public:
   virtual ~Expression_Tree(){};
   virtual long double      evaluate() const = 0;
   virtual std::string      get_postfix() const = 0;
   virtual std::string      str() const = 0;
   virtual void             print(std::ostream&, int depth) const = 0;
   virtual Expression_Tree* clone() const = 0;
     
};


/*
Test för templates, fungerar
_____________________________
class majs{
};

template<typename T, typename S>
class majset : public majs
{

public:
T variabel;
S variabel2;
majset(T variabel_, S variabel2_){ variabel = variabel_; variabel2 = variabel2_; };

};

class impmajs : public majset<int, string>
{
public:
  impmajs(int variabel_, string variabel2_) : majset(variabel_, variabel2_) {}
  void print(){
    cout << variabel << " " << variabel2 << endl;
  }

};
*/

template <typename T>
class Operand : public Expression_Tree
{
  public:
  T main_member;
  Operand(T main_member_);
  //long double evaluate() const;
  string get_postfix() const;
  string str() const;
  void print(ostream& out, int depth) const;
  
  ~Operand(){};

};

class Integer : public Operand<long>
{
 public:
  Integer(long main_member_) : Operand(main_member_) {}
  virtual long double evaluate() const;
  //using Operand<long>::evaluate;
  using Operand<long>::get_postfix;
  using Operand<long>::str;
  using Operand<long>::print;
  Expression_Tree* clone() const;

  Integer() = delete; // eller default....
  Integer(const Integer&) = delete;
  Integer(Integer&&) = delete;
  ~Integer(){};

};

class Real : public Operand<double long>
{
public:
  Real(double long main_member_) : Operand(main_member_) {}
  virtual long double evaluate() const;  
  //using Operand<double long>::evaluate;
  using Operand<double long>::get_postfix;
  using Operand<double long>::str;
  using Operand<double long>::print;
  Expression_Tree* clone() const;

  Real() = delete; // eller default....
  Real(const Real&) = delete;
  Real(Real&&) = delete;
  ~Real(){};

};

class Variable : public Operand<string>
{
 public:
  double long value;
  Variable(string main_member_): Operand(main_member_) {}
 Variable(string main_member_, double long value_) : Operand(main_member_) {value = value_;}
  long double evaluate() const;
  using Operand<string>::get_postfix;
  using Operand<string>::str;
  using Operand<string>::print;
  Expression_Tree* clone() const;
  void set_value(long double new_value);
  long double  get_value();

  Variable() = delete; // eller default....
  Variable(const Variable&) = delete;
  Variable(Variable&&) = delete;
  ~Variable(){};
 };



//Binary operator klasserna

template <typename T, typename S>
class Binary_Operator : public Expression_Tree
{
 public:
  T left;
  S right;
  string op_name;
  Binary_Operator(T left_, S right_);
  string str() const;
  string get_postfix() const;
  void print(ostream& out, int depth) const;
  virtual ~Binary_Operator();


};

class Assign : public Binary_Operator<Expression_Tree*, Expression_Tree*>
{ 
public:
  Assign(Expression_Tree* left_, Expression_Tree* right_) : Binary_Operator(left_, right_) {op_name = "=";}
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::str;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::get_postfix;
  long double evaluate() const;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::print;
  Expression_Tree* clone() const;

  Assign() = delete; // eller default....
  Assign(const Assign&) = delete;
  Assign(Assign&&) = delete;
  ~Assign(){};
};

class Plus : public Binary_Operator<Expression_Tree*, Expression_Tree*>
{ 
 public:
  Plus(Expression_Tree* left_, Expression_Tree* right_) : Binary_Operator(left_, right_) {op_name = "+";}
  long double evaluate() const;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::get_postfix;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::str;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::print;
  Expression_Tree* clone() const;
};

//______
class Minus : public Binary_Operator<Expression_Tree*, Expression_Tree*> 
{
 
 public:
  Minus(Expression_Tree* left_, Expression_Tree* right_) : Binary_Operator(left_, right_) {op_name = "-";}
  long double evaluate() const;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::get_postfix;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::str;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::print;
  Expression_Tree* clone() const;
 
};

class Times : public Binary_Operator<Expression_Tree*, Expression_Tree*>
{
 public:
  Times(Expression_Tree* left_, Expression_Tree* right_) : Binary_Operator(left_, right_) {op_name = "*";}
  long double evaluate() const;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::get_postfix;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::str;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::print;
  Expression_Tree* clone() const;
};

class Divide : public Binary_Operator<Expression_Tree*, Expression_Tree*>
{
 public:
  Divide(Expression_Tree* left_, Expression_Tree* right_) : Binary_Operator(left_, right_) {op_name = "/";}
  long double evaluate() const;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::get_postfix;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::str;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::print;
  Expression_Tree* clone() const;


};

class Power: public Binary_Operator<Expression_Tree*, Expression_Tree*>
{

 public:
  Power(Expression_Tree* left_, Expression_Tree* right_) : Binary_Operator(left_, right_) {op_name = "^";}
  long double evaluate() const;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::get_postfix;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::str;
  using Binary_Operator<Expression_Tree*, Expression_Tree*>::print;
  Expression_Tree* clone() const;

};


/*
  Execption class
*/
class exp_tree_exception : runtime_error{
 private:
  std::string what_;
 public:
  exp_tree_exception(string m="Felaktig operation på Expression_Tree") : 
   runtime_error(m), what_(m) {}

  virtual const char* what() const throw();

  virtual ~exp_tree_exception() throw (){}


};


#endif
