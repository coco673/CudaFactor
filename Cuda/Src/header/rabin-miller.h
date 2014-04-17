/*
 * rabin-miller.h
 *
 *  Created on: 8 avr. 2014
 *      Author: didelify
 */

#ifndef RABIN_MILLER_H_
#define RABIN_MILLER_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

int modulo(int a,int b,int c);
long long mulmod(long long a,long long b,long long c);
bool Miller(long long p,int iteration);

#endif /* RABIN_MILLER_H_ */
