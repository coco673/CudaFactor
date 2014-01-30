/*
 * main.c
 *
 *  Created on: 27 janv. 2014
 *      Author: tony
 */



#include <string.h>
#include "header/pgcd.h"

int main(int argc, char **argv){
	long double a = strtold(argv[1],NULL);
	long double b = strtold(argv[2],NULL);


	pgcd(a,b);



	return 0;
}
