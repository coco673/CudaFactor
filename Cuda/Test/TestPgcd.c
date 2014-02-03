/*
 * main.c
 *
 *  Created on: 27 janv. 2014
 *      Author: tony
 */



#include <string.h>
#include "../Src/header/pgcd.h"

int main(int argc, char **argv){
	long double a = strtold(argv[1],NULL);
	long double b = strtold(argv[2],NULL);


	long double c = pgcd(a,b);
	printf("Le pgcd est : %i\n",(int)c);



	return 0;
}
