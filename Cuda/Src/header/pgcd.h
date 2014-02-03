/*
 * pgcd.h
 *
 *  Created on: 28 janv. 2014
 *      Author: tony
 */

#ifndef PGDC_H_
#define PGCD_H_

#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <math.h>
#include <string.h>

#define N 2000


long double pgcd(long double a, long double b);
char *convert(long double a);
char *equalNBit(char *res,int size);


#endif /* PGCD_H_ */
