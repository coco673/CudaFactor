#ifndef _INTLIST_H
#define _INTLIST_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "ensemble.h"

/*__device__ __host__ Int_List *createIntList();
__device__ __host__ void addInt(Int_List *list, int c);
__device__ __host__ int getVal(const Int_List list, int index);
__device__ __host__ void removeLastInt(Int_List *list);
__device__ __host__ void resetIntList(Int_List *list);
void printIntList(const Int_List list);*/

__device__ void copyTabDev(uint64_t *src, uint64_t *dest, int size);
__global__ void copyTabGPU(uint64_t *src, uint64_t *dest, int size);
__host__ Int_List_GPU *createIntList();
__host__ void addInt(Int_List_GPU **list, int v);
__device__ void addIntGPU(int **list, int size, int v);
__host__ uint64_t getVal(Int_List_GPU l, int index);
__device__ uint64_t getValGPU(uint64_t *l, int index);
__host__ void removeLastInt(Int_List_GPU **list);
__device__ void removeLastInt(int **list, int size);
__host__ void resetIntList(Int_List_GPU **list);
__device__ void resetIntListGPU(int **list, int size);
__host__ void printIntList(Int_List_GPU l);

#endif
