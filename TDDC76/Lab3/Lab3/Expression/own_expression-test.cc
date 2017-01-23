/*
 * expression-test.cc
 */
#include "Expression.h"
#include "Expression_Tree.h"
#include <iostream>
#include <stdexcept>
using namespace std;

int main()
{
   Times* tree1 = new Times{new Real{3.15}, new Integer{3}};
   Plus* tree2 = new Plus{tree1, new Real{5.4}};
   Assign* tree3 = new Assign{new Variable{'x'}, tree3};
   Expression e1{tree3}; 

   return 0;
}
