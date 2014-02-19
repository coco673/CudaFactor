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

union nb{
   int val;
   couple couple;
 };
struct cell {
 nb ind ;
};
typedef struct cell* ensemble;

 ensemble initEns(int *size);
 __host__ __device__ int addCouple(ensemble ens, int x, int y,int *size);
__host__ __device__ int addVal(ensemble ens, int x,int *size);
#endif /* STRUCTURE_H_ */
