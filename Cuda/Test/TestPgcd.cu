
/*
 * main.c
 *
 *  Created on: 27 janv. 2014
 *      Author: tony
 */


#include "TestPgcd.h"

int TestPgcd(){
	long double a = 1078;
	long double b = 322;
	int res = 14;
	
      	int c = (int) pgcd(a,b);

	assert(c == res);


	return 0;
}


