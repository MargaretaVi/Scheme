

#ifndef _MONETARY_H_

#define _MONETARY_H_

#include <string>

#include <iostream>

#include <stdexcept>

using namespace std;

namespace monetary{
  /*
  /Money classen
  */

  class Money{

   private:

    string ccy = "";

    int integer = 0;

    int fraction = 0;



   public:

    //Constructors

    Money();

    Money(const int &integer_);

    Money(const int &integer_, const int &fraction_);

    Money(const string &ccy_);

    Money(const string &ccy_, const int &integer_);

    Money(const string &ccy_, const int &integer_, const int &fraction_);

    Money(const Money &money);



    //Operators

    Money& operator=(const Money& money);

    Money operator+(const Money& money) const;

    Money operator-(const Money& money) const;

    bool operator==(const Money& money) const;

    bool operator<(const Money& money) const;

    bool operator!=(const Money& money) const;

    bool operator>(const Money& money) const;

    bool operator<=(const Money& money) const;

    bool operator>=(const Money& money) const;

    Money& operator++();

    Money operator++(int);

    Money& operator--();

    Money operator--(int);

    Money& operator+=(const Money& money);

    Money& operator-=(const Money& money);
    
    //Members

    string currency() const;

    void print() const;

    void print(ostream &out) const;

    //Friends

    friend ostream& operator<<(ostream& out, const Money& money);
    friend istream& operator>>(istream& in, Money& money);

  //Private functions

   private:

    void checkparameters(const string& ccy_, const int& integer_, const int& fraction);

  };


  /*

  /Exception class

  */

  class monetary_exception : std::logic_error{

   private:

    std::string what_;

   public:

   monetary_exception(string m="Icke tillåten operation för Money.") : 

    std::logic_error(m), what_(m) {}

    virtual const char* what() const throw();

    virtual ~monetary_exception() throw (){}

  };

}

#endif

