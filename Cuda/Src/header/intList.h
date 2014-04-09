#ifndef _INTLIST_H
#define _INTLIST_H

#include <stdio.h>
#include <stdlib.h>
#include "ensemble.h"

__device__ __host__ Int_List *createIntList();
__device__ __host__ void addInt(Int_List *list, int c);
__device__ __host__ int getVal(const Int_List list, int index);
__device__ __host__ void removeLastInt(Int_List *list);
__device__ __host__ void resetIntList(Int_List *list);
void printIntList(const Int_List list);

#endif
