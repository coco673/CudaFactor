/*
 *fillEnsemble.h
 *
 * Created on: 5 Feb. 2014
 *     Author : tony
 */

#ifndef FILLENSEMBLE_H_
#define FILLENSEMBLE_H_
#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <math.h>
#include <cuda.h>
#include <cuda_runtime.h>

#include "structure.h"

__global__ void isInEnsembleG(ensemble ens, int y,int size,int *res);


bool isBSmooth(int *list,int size, int y);
__global__ void isBSmoothh(int *list,int size, int base, int y, int *result);

bool isInEnsemble(ensemble ens, int y,int size);

void fillEnsemble(ensemble ens,int n,int base,ensemble div,int sizeDiv);

#endif /* FILLENSEMBLE_H_ */
