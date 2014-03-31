/*
*fillEnsemble.h
*
* Created on: 5 Feb. 2014
* Author : tony
*/

#ifndef FILLENSEMBLE_H_
#define FILLENSEMBLE_H_
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <float.h>
#include <math.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "structure.h"
#include <curand.h>
#include <curand_kernel.h>

__device__ void isInEnsembleG(ensemble ens, int y,int size,int *res);
__global__ void fillEnsembleG(ensemble ens,int *p,int k,int n,int base,ensemble div,int sizeDiv,int *sizeR,int *matrix);
__device__ void isBSmoothG(int *list,int size, int y, int *result);
__device__ int isInf(int *list, int size, int y);

__device__ void generate( curandState_t *globalState, int *rand, int nbr, int racN);
__device__ void setup_kernel ( curandState_t *state );

bool isBSmooth(int *list,int size, int y);
bool isInEnsemble(ensemble ens, int y,int size);
void fillEnsemble(ensemble ens,int n,int base,ensemble div,int sizeDiv);

#endif /* FILLENSEMBLE_H_ */
