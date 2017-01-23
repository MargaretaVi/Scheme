

#include "Monetary.h"
//#include <iostream>
#include <iomanip>

namespace monetary{

  /*
    /Saker f√∂r monetary g√∂rs h√§r
  */

  /*
    /Constructors
  */
  //Default constructor
  Money::Money(){
    
    integer = 0;
    fraction = 0;

  }

  Money::Money(const int &integer_ = 0){

    checkparameters("", integer_, 0);
    integer = integer_;
    fraction = 0;

  }
  
  //Unspecified currency
  Money::Money(const int &integer_ = 0, const int &fraction_ = 0){
  
    checkparameters("", integer_, fraction_);
    integer = integer_;
    fraction = fraction_;

  }

  Money::Money(const string &ccy_ = ""){

    checkparameters(ccy_, 0, 0);
    ccy = ccy_;
    integer = 0;
    fraction = 0;

  }

  Money::Money(const string &ccy_ = "", const int &integer_ = 0){

    checkparameters(ccy_, integer_, 0);
    ccy = ccy_;
    integer = integer_;
    fraction = 0;

  }

  //All parameters provided
  Money::Money(const string &ccy_ = "",const int &integer_ = 0,
    const int &fraction_ = 0){
    checkparameters(ccy_, integer_, fraction_);
    ccy = ccy_;
    integer = integer_;
    fraction = fraction_;
  }

  //Create a copy
  Money::Money(const Money &money){
    ccy = money.ccy;
    integer = money.integer;
    fraction = money.fraction;
  }

  /*
    /Operators
  */

  //Tilldelning
  Money& Money::operator=(const Money& money){
    if(money.ccy == "" || ccy == money.ccy || ccy == ""){
      integer = money.integer;
      fraction = money.fraction;
      if(ccy == ""){
	     ccy = money.ccy;
      }
    }
    else{
      throw monetary_exception("Olika valutor, g√•r ej.");
    }
    return *this;
  }

  //Addition
  Money Money::operator+(const Money& money) const{
    //Kastar undantag direkt
    if((ccy != "" && money.ccy != "") && ccy != money.ccy){
      throw monetary_exception("Olika valutor kan ej adderas.");
    }

    Money temp{*this};

    temp.integer += money.integer;
    temp.fraction += money.fraction;
    if(temp.fraction > 99){
      temp.fraction -= 100;
      temp.integer += 1;
    }

    return temp;
  }

  //Subtraktion
  Money Money::operator-(const Money& money) const{
    Money temp{*this};
    //Kastar undantag direkt
    if((ccy != "" && money.ccy != "") && ccy != money.ccy){
      throw monetary_exception("Olika valutor kan ej subtraheras.");
    }

    if(integer - money.integer < 0){
      throw monetary_exception("Subtrahering ger valuta mindre ‰n 0.");
    }
    else if(integer - money.integer == 0 && fraction - money.fraction < 0){
      throw monetary_exception("Subtrahering ger valuta mindre ‰n 0.");
    }
    else{
      temp.fraction -= money.fraction;
      if(temp.fraction < 0){
	     temp.integer = temp.integer - money.integer - 1;
	     temp.fraction = 100 + temp.fraction;
      }
      else{
	     temp.integer -= money.integer;
      }
    }
    return temp;
  }

  //J√§mf√∂relse
  bool Money::operator==(const Money& money) const{
    //Kastar undantag direkt
    if((ccy != "" && money.ccy != "") && ccy != money.ccy){
      throw monetary_exception("Olika valutor kan ej j√§mf√∂ras.");
    }

    if(integer == money.integer && fraction == money.fraction){
      return true;
    }

    return false;
  }

  //Mindre √§n
  bool Money::operator<(const Money& money) const{
    //Kastar undantag direkt
    if((ccy != "" && money.ccy != "") && ccy != money.ccy){
      throw monetary_exception("Olika valutor kan ej j√§mf√∂ras.");
    }
    //Om heltalet √§r st√∂rre, eller om det √§r lika stort men med br√•kdelen st√∂rre...
    // cout << "majs" << endl;
    if(integer < money.integer || (integer == money.integer && fraction < money.fraction)){
      return true;
    }

    return false;
  }

  //Inte lika med
  bool Money::operator!=(const Money& money) const{
    if(*this == money){
      return false;
    }

    return true;
  }

  //St√∂rre √§n
  bool Money::operator>(const Money& money) const{
    //L√•ter exception kastas i de andra operatorerna
    if(*this == money || *this < money){
      return false;
    }
    return true;
  }

  //Mindre eller lika med
  bool Money::operator<=(const Money& money) const{
    if(*this == money || *this < money){
      return true;
    }

    return false;

  }

  //St√∂rre eller lika med
  bool Money::operator>=(const Money& money) const{
    if(*this < money){
      return false;
    }

    return true;

  }

  //stegning 

  //stegning (increment)++ prefix
  Money& Money::operator++(){
    ++fraction;
    if(fraction > 99){
      fraction -= 100;
      integer += 01;	
    }
    return *this;
  }

  //stegning (increment)++ postfix
  Money Money::operator++(int){ 
    Money copy(ccy, integer, fraction);
    ++*this;
    return copy;
  }

  //stegning (decrement)-- prefix
  Money& Money::operator--(){
    if (fraction == 0){
      if(integer == 0){
	       throw monetary_exception("V‰rdet ‰r 0, kan ej minskas");
      }
      else{
	     --integer;
	     fraction = 99;
      }
    }
    else{
      --fraction;
    }  	

    return *this;
	
  }		
    
  //stegning (decrement)-- postfix
  Money Money::operator--(int){
    Money copy(ccy, integer, fraction);
    --*this;

    return copy;
  }	   


  Money& Money::operator+=(const Money& money){
    //undantag kastas i "+"
    *this = *this + money;
    return *this;
  }

  Money& Money::operator-=(const Money& money){
    //undantag kastas i "-"
    *this = *this - money;
    return *this;
  }



  /*
    /Member functions
  */
  string Money::currency() const{
    return ccy;
  }

  //Utskrift
  void Money::print() const{
    double value{0};
    value =  fraction+integer*100;
    value = value/100;
    cout.precision(2);
    if(ccy != ""){
      cout << ccy << " " << fixed << value;
    }
    else{
      cout << fixed<< value;
    }
  }

  //Utskrift 2
  void Money::print(ostream &out) const{
    double value{0};
    value =  fraction+integer*100;
    value = value/100;
    out.precision(2);
    if(ccy != ""){
      out << ccy << " " << fixed<< value;
    }
    else{
      out << fixed<< value;
    }
  }


  /*
    /Private member functions
  */
  void Money::checkparameters(const string& ccy_, const int& integer_,
    const int& fraction_){

    if(ccy_ != "" && ccy_.length()  != 3){
      throw monetary_exception("Valutan har fel namn");
    }

    if(integer_ < 0 || fraction_ < 0){
      throw monetary_exception("Valutan m√•ste ha positiva tal");
    }

    if(fraction_ > 99){
      throw monetary_exception("Kan ej ha en fraction h√∂gre √§n 99");
    }
  }
  //}


  /*
    /Saker f√∂r Exception g√∂rs h√§r
  */
  const char* monetary_exception::what() const throw(){
    return what_.c_str();
  }

  /*
    /÷vriga √∂verladdningar
  */

  //Overloading of ostream
  ostream& operator<<(ostream& out, const Money& money){
    money.print(out);
  }

  //Overloading of instream
  istream& operator>>(istream& in, Money& money){

    int peeker;
    char first;
    char dummy;
    int integ;
    int fract = 0;
    string currency{""};

    while(in.peek() == '\n' || in.peek() == ' '){
      cin >> noskipws >> first;
    }
    peeker = in.peek();
    first = peeker;
    //Kolla valuta
    if(isalpha(first)){
      //Vi har en valuta, ta in en str‰ng med valutan
      for(int i = 1; i <= 3; i++){
	     in >> noskipws >> first;
	     if(!isalpha(first)){
        in.setstate(ios::failbit);
        throw monetary_exception("Valuta mÂste ha 3 bokst‰ver");
	     }
	     currency += first;
      }

      //Exceptions
      if(currency.length() != 3){
        in.setstate(ios::failbit);
        throw monetary_exception("Fel valutanamn");
      }
      else if((currency != money.ccy) && (money.ccy != "")){
        in.setstate(ios::failbit);
	      throw monetary_exception("Valuta fÂr ej bytas");
      }
    }
    //Kolla om vi har en valuta
    if(!(in >> skipws >> integ)){
      in.setstate(ios::failbit);
      throw monetary_exception("Felinmatning");
    }
    if(in.peek() == '.'){
      //Vi har ett decimaltal
      in >> first;
      if(in.peek() == '0'){
	       //En nolla ‰r fˆrsta talet
        //Dubbelkolla om n‰sta tal ‰r 0
        in >> dummy;

        //Om n‰sta ockÂs ‰r en 0'a fÂr inte fler tal fˆrekomma
        if(in.peek() == '0'){

          //Om det inte fungerar
          if(!(in >> fract)){
            in.setstate(ios::failbit);
            throw monetary_exception("BrÂktalet felspecificerat");
          }

          //Om talet vi tar in inte ‰r endast en 0'a har fraction
          //mer ‰n 2 tal
          else if(fract > 0){
            in.setstate(ios::failbit);
            throw monetary_exception("BrÂktalet felspecificerat");
          }
        }
        else if(!(in >> fract)){
          in.setstate(ios::failbit);
          throw monetary_exception("BrÂktalet felspecificerat");
        }
        else if(fract>9){
          in.setstate(ios::failbit);
          throw monetary_exception("BrÂktalet felspecificerat");
        }
      }
      else{
        if(!(in >> fract)){
          in.setstate(ios::failbit);
          throw monetary_exception("BrÂktalet felspecificerat");
        }
        if(fract < 10){
        //Om vi har specificerat ex. 3.4 ska det bli 3.40
          fract = fract*10;
        }
      }
    }
    Money temp{currency, integ, fract};
    money = temp;
  } 
}

/*
  /Tillf√§lligt testprogram
*/
/*Gammalt testprogram, se nytt i annan fil*/
/*
using namespace monetary;
int main(){ 
    try{
    Money x("SEK", 4, 12);
    x.print();
    cout << endl;
    Money y(x);
    y.print();
    cout << endl;
    x.print();
    cout << endl;
    Money z("", 2, 4);
    z.print();
    cout << endl;
    Money p{"EUR", 12, 9};
    p.print();
    cout << endl;
    p.print(cout);
    cout << endl;
    cout << p << endl;
    p = z;
    cout << p << endl;

    Money b("SEK", 10, 79);
    Money c("SEK", 9, 88);
    Money d("EUR", 7, 13);
    Money e(1,0);
    Money f(0,0);
    int t = 3;
    int q = 4;
    cout << t << " ƒr int talet" << endl;
    b + c;
    cout << b << " ‰r talet" << endl;
    b = b + c;
    cout << b << endl;
    //b= b + e;
    cout << b << endl;

    f = --e;
    cout << f << endl; 
    //b + d;

    if(b==c){
    cout << "> Fungerar" << endl;
    }

    string s{b.currency()};
    cout << s << endl;
  
    Money test{"SEK",15, 90};
    Money ref{"SEK", 15, 96};
    for(Money i = test; i<= ref; ++i){
    cout << i << endl;
    }

    for(Money i = test; i<= ref; i++){
    cout << i << endl;
    }

    for(Money i = ref; i >= test; i--){
    cout << i << endl;
    }

    for(Money i = ref; i >= test; --i){
    cout << i << endl;
    }

    test = ref--;
    cout << test << endl;
    ref++;
    test = --ref;
    cout << test << endl;

    Money tester("SEK", 15, 90);

    cout << ref - tester << endl;
    
    Money refer("SEK", 15, 95);
    cout << tester - refer << endl;
    
    Money test2;
    cin >> ref;
    cout << ref << endl;

    Money j{"GBP", 5, 78};
    Money g{"GBP", 4, 80};
  
    j+=g;
    cout << j << endl;
    cout << g << endl;
    j-=g;
    cout << g << endl;
    cout << j << endl;
    j+=ref;

    }

    catch(const monetary_exception& e){
    cerr << e.what() << endl;
    }
}
*/
