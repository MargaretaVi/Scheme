/*
 * FILNAMN:       Expression.h
 * LABORATION:    lab3
 * PROGRAMMERARE: Victor Viberg 911211-4716
 *                Christian W�ngblad 870323-7118
 * DATUM:         2012-10-17
 *
 * BESKRIVNING 
 * 
 * Skapar Expression klassen, och hanterar infix och postfix
 */
#ifndef EXPRESSION_H
#define EXPRESSION_H
#include <iosfwd>
#include <stdexcept>
#include <string>



class Expression_Error : public std::logic_error
{
 public :
  explicit Expression_Error(const std::string& what_arg) noexcept : logic_error(what_arg) {}
};




 
class Expression
{
public:
  // OBSERVERA: DETTA �R ENDAST KODSKELETT - MODIFIERA OCH KOMPLETTERA!

 Expression(class Expression_Tree* n  = 0):tree(n)  {}
  Expression(const Expression& tree);
  ~Expression();
  void operator=(Expression tree);
  double      evaluate() const;
  std::string get_postfix() const;
  bool        empty() const;
  void        print_tree(std::ostream&) const;
  void        swap(Expression& n);

 private:
  Expression_Tree* tree;


};

/**
 * swap: Byter inneh�ll p� tv� Expression-objekt.
 */
void swap(Expression&, Expression&);

/**
 * make_expression: Hj�lpfunktion f�r att skapa ett Expression-objekt, givet
 * ett infixuttryck i form av en str�ng.
 */
Expression make_expression(const std::string& infix);

#endif
