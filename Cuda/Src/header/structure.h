/*
 * structure.h
 *
 *  Created on: 5 févr. 2014
 *      Author: tony
 */

#ifndef STRUCTURE_H_
#define STRUCTURE_H_

typedef struct couple {
  int x;
  int y;
} couple;

struct cell {
  union {
    int val;
    couple couple;
  }ind;
 // struct cell *next;
};
typedef struct cell* ensemble;

__host__ __device__ ensemble initEns(int *size);
__host__ __device__ ensemble addCouple(ensemble ens, int x, int y,int *size);
__host__ __device__ ensemble addVal(ensemble ens, int x,int *size);
#endif /* STRUCTURE_H_ */
