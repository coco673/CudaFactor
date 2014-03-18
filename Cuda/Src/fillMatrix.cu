#include "header/fillMatrix.h"

__device__ __host__ void intToBinWithSize(int *tab, int n, int size) {
    int i;
    for(i = 0; i < size; i++)
        tab[i] = (n >> ((size - 1) - i)) & 0x1;
}

/*__device__ int *intToBin(int n, int *tab_size) {
	int size = ((int) ((double) floor((double) log(n)/ (double) log(2)))) + 1;
	int *tab = (int *) malloc(size * sizeof(int));
	intToBinWithSize(tab, n, size);
	*tab_size = size;
	return tab;
}*/

__global__ void fillMatrix(int *yList, int *premList, int size, int *result) {
	__shared__ volatile int found;
	int blockId = blockIdx.x;
	int threadId = threadIdx.x;
	if (threadId == 0) {
		found = 0;
	}
	__syncthreads();
	int *listCoeff = (int *) malloc(size * sizeof(int));
	intToBinWithSize(listCoeff, threadId, size);
	int res = 1;
	for (int i = 0; i < size; i++) {
		res *= (int) ((double) pow((double) premList[i], (double) listCoeff[i]));
	}
	if (yList[blockId] == res) {
		found = 1;
		result = listCoeff;
	}
	__syncthreads();
	if (found == 0) {
		result = NULL;
	}
}


