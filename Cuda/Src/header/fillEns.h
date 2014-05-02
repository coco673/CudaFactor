/*
 * fillEns.h
 *
 *  Created on: 3 avr. 2014
 *      Author: groupeDev
 */
#include <curand_kernel.h>
#include <curand.h>
#include <stdint.h>
#include "ensemble.h"
#include "intList.h"
#ifndef FILLENS_H_
#define FILLENS_H_

__device__ void Generation(curandState_t *state,uint64_t nbr, uint64_t sqrtNBR,uint64_t *rand);
__device__ void fillEnsR(curandState_t *state,Couple *R,int *size,uint64_t *Div,int sizeDiv,int *, int k,uint64_t *rand,uint64_t nbr,int *matrix);
__device__ void isInEnsembleG(uint64_t *ens, uint64_t y,int size, uint64_t *res);

#endif /* FILLENS_H_ */
