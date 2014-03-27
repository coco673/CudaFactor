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


 int pgcd(int a, int b);
 char *convert(int a);
 char *equalNBit(char *res,int size);
 uint64 pgcdUint(uint64 u, uint64 v);


#endif /* PGCD_H_ */
