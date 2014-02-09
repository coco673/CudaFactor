/*
 * prime.h
 *
 *  Created on: 9 févr. 2014
 *      Author: yusha
 */

#ifndef PRIME_H_
#define PRIME_H_

__global__ void eratosthene(int *list, int borne);
__global__ void listNumbers(int *list);
__global__ void copyTab(int *src, int *dest, int size);
int primeList(int *list, int *result, int borne);
int generatePrimeList(int borne);


#endif /* PRIME_H_ */
