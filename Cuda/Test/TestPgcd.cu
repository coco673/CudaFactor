
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

int TestPgcdG(){
	uint64_t a = 123456789 * 13; //1604938257
	uint64_t b = 123456789 * 12; //1481481468
	uint64_t c = pgcdUint(a,b);

	uint64_t res = 123456789;

	assert(c == res);

	return 0;
}
