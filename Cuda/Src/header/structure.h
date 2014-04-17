/*
 * structure.h
 *
 *  Created on: 5 févr. 2014
 *      Author: tony
 */

#ifndef STRUCTURE_H_
#define STRUCTURE_H_
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdint.h>

struct couple {
	int x;
	int y;
};
typedef struct couple couple;

union nb {
	int val;
	couple couple;
};
struct cell {
	union nb ind;
};
typedef struct cell* ensemble;

__host__ __device__ ensemble initEns(int *size);
__host__ __device__ int addCouple(ensemble *ens, uint64_t x, uint64_t y,int *size);
__host__ __device__ int addVal(ensemble *ens, uint64_t x,int *size);
#endif /* STRUCTURE_H_ */
