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
#include <stdint.h>
#include "matrix.h"
#include "vector.h"

void print_matrix(char **matrix, int size);
Vector_List *gaussjordan_noyau(char **matrix, int size);
void test();

#endif /* GAUSS_H_ */
