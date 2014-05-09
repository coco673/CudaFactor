/**
 * prime.cu
 */
#include "header/prime.h"

__global__ void fillList(int *list, uint64_t borne) {
	int id = blockIdx.x;
	if (id > 1 && id <= borne) {
		list[id - 2] = id;
	}
}

__global__ void eratosthene(int *list) {
	int bid = blockIdx.x;
	int tid = threadIdx.x;
	if (tid > 1 && tid != list[bid]) {
		if (list[bid] % tid == 0) {
			list[bid] = 0;
		}
	}
}

int *generatePrimeList(int borne, int *size) {
	int *list = (int *) malloc((borne - 1) * sizeof(int));
	int *dev_list;
	int cures = cudaMalloc((int **)&dev_list, (borne - 1) * sizeof(int));
	if (cures != cudaSuccess) {
		fprintf(stderr, "1 ; %s", cudaGetErrorString(cudaGetLastError()));
		exit(1);
	}
	fillList<<<borne + 1, 1>>>(dev_list, borne);
	eratosthene<<<borne - 1, borne - 1>>>(dev_list);
	cures = cudaMemcpy(list, dev_list, (borne - 1) * sizeof(int), cudaMemcpyDeviceToHost);
	if (cures != cudaSuccess) {
		fprintf(stderr, "2 ; %s", cudaGetErrorString(cudaGetLastError()));
		exit(1);
	}
	*size = 0;
	for (int i = 0; i < (borne - 1); i++) {
		if (list[i] != 0) {
			(*size)++;
		}
	}
	int *res = (int *) malloc((*size) * sizeof(int));
	for (int i = 0, j = 0; i < (borne - 1); i++) {
		if (list[i] != 0) {
			res[j] = list[i];
			j++;
		}
	}
	cures = cudaFree(dev_list);
	if (cures != cudaSuccess) {
		fprintf(stderr, "3 ; %s", cudaGetErrorString(cudaGetLastError()));
		exit(1);
	}
	free(list);
	return res;
}
