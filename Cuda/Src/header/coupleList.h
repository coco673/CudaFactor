#ifndef _COUPLELIST_H
#define _COUPLELIST_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "ensemble.h"

__device__ __host__ Couple_List *createCoupleList();
__device__ __host__ void addCouple(Couple_List *list, Couple c);
__device__ __host__ Couple getCouple(const Couple_List list, int index);
__device__ __host__ void removeLastCouple(Couple_List *list);
__device__ __host__ void resetCoupleList(Couple_List *list);
void printCouple(Couple c);
void printCoupleList(const Couple_List list);

#endif
