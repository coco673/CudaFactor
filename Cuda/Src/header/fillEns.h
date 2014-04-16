/*
 * fillEns.h
 *
 *  Created on: 3 avr. 2014
 *      Author: groupeDev
 */
#include <curand_kernel.h>
#include <curand.h>
#include "ensemble.h"
#include "intList.h"
#ifndef FILLENS_H_
#define FILLENS_H_

__global__ void Generation(curandState_t *state,int nbr, int sqrtNBR,int *rand);
__global__ void fillEnsR(curandState_t *state,Couple *R,int *size,int *Div,int sizeDiv,int *premList,int k,int *rand,int nbr,int *matrix);

#endif /* FILLENS_H_ */
