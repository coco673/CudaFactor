/*
 * gauss.h
 *
 *  Created on: 1 avr. 2014
 *      Author: didelify
 */

#ifndef GAUSS_H_
#define GAUSS_H_

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "matrix.h"
#include "vector.h"

void print_matrix(int **matrix, int size);
Vector_List *gaussjordan_noyau(int **matrix, int size);
void test();

#endif /* GAUSS_H_ */
