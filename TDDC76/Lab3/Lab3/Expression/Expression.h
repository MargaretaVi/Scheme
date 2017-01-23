/*
 * Expression.h
 */
#ifndef EXPRESSION_H
#define EXPRESSION_H
#include <iosfwd>
#include <stdexcept>
#include <string>
#include "Expression_Tree.h"
/**
 * expression_error: kastas om fel inträffar i en Expression- operation;
 * ett diagnostiskt meddelande ska skickas med.
 */


/* /\* */
/*   Execption class */
/* *\/ */
/* class exp_exception : runtime_error{ */
/*  private:  */
/*   std::string what_; */
/*  public: */
/*   exp_exception(string m="Felaktig operation på Expression") :  */
/*    runtime_error(m), what_(m) {} */

/*   virtual const char* what() const throw(); */

/*   virtual ~exp_exception() throw (){} */


/* }; */

class Expression_Error  : public std::logic_error
{
 public:
  explicit Expression_Error(const std::string& what_arg) noexcept
    : std::logic_error(what_arg) {}
};



// ATT GÖRA!

/**
 * Expression: Klass för att representera ett enkelt aritmetiskt uttryck.
 */
class Expression
{
public:
   // OBSERVERA: DETTA ÄR ENDAST KODSKELETT - MODIFIERA OCH KOMPLETTERA!

   Expression(class Expression_Tree* node = nullptr);
   Expression_Tree* tree;
   Expression(const Expression&);
   Expression(Expression &&);
   ~Expression();  
   
   void operator=(const Expression&);
   void operator=(Expression&&);

   long double evaluate() const;
   std::string get_postfix() const;
   bool        empty() const;
   void        print_tree(std::ostream&) const;
   void        swap( Expression&);
};

/**
 * swap: Byter innehåll på två Expression-objekt.
 */
void swap(Expression&, Expression&);

/**
 * make_expression: Hjälpfunktion för att skapa ett Expression-objekt, givet
 * ett infixuttryck i form av en sträng.
 */
Expression make_expression(const std::string& infix);

#endif
