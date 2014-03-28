/*
 * fillMatrix.h
 *
 *  Created on: 2 mars 2014
 *      Author: yusha
 */

#ifndef FILLMATRIX_H_
#define FILLMATRIX_H_

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

__device__ __host__ void intToBinWithSize(int *, int, int);
//__device__ int *intToBin(int, int *);
//__global__ void fillMatrix(int *, int *, int, int *);
int **fillMatrixNaif(int*, int, int*, int);
#endif /* FILLMATRIX_H_ */
