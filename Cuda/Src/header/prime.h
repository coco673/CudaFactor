/*
 * prime.h
 *
 *  Created on: 9 févr. 2014
 *      Author: yusha
 */

#ifndef PRIME_H_
#define PRIME_H_

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdint.h>

__global__ void eratosthene(int *list, uint64_t borne);
__global__ void listNumbers(int *list);
__global__ void copyTab(int *src, int *dest, int size);
int primeList(int *list, int *result, int borne);
int *generatePrimeList(int borne, int *size);


#endif /* PRIME_H_ */
