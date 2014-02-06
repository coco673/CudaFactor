#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__global__ void eratosthene(int *list, int borne) {
	int id = blockIdx.x;
	int limite = (int) sqrt((double) borne);
	for (int i = id + 1; i <= borne; i++) {
		if (list[i] != 0 && (list[i] % list[id]) == 0) {
			list[i] = 0;
		}
	}
}

__global__ void listNumbers(int *list) {
	int id = blockIdx.x;
	if (id != 0 && id != 1) {
		list[id - 2] = id;
	}
}

__global__ void copyTab(int *src, int *dest, int size) {
	int id = blockIdx.x;
	if (id < size) {
		dest[id] = src[id];
	}
}

int primeList(int *list, int *result, int borne) {
	int id = 0;
	int res;
	int *dev_res;
	int *dev_list;
	for (int i = 0; i < borne; i++) {
		if (list[i] != 0) {
			result[id] = list[i];
			id++;
		}
	}
	res = cudaMalloc(&dev_list, id);
	if (res != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		exit(EXIT_FAILURE);
	}
	res = cudaMalloc(&dev_res, id);
	if (res != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		exit(EXIT_FAILURE);
	}
	res = cudaMemcpy(dev_list, result, id, cudaMemcpyHostToDevice);
	if (res != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		exit(EXIT_FAILURE);
	}
	copyTab<<<id, 1>>>(dev_list, dev_res, id);
	res = cudaMemcpy(result, dev_res, id, cudaMemcpyDeviceToHost);
	if (res != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		exit(EXIT_FAILURE);
	}
	cudaFree(dev_list);
	cudaFree(dev_res);
	return id;
}

int main(int argc, char **argv) {
	int *numbers;
	int *dev_numbers;
	int borne;
	if (argc == 1) {
		borne = 100;
	} else {
		borne = atoi(argv[1]);
	}
	numbers = (int *) malloc((borne - 1) * sizeof(int));
	int ret = cudaMalloc(&dev_numbers, ((borne - 1) * sizeof(int)));
	if (ret != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		exit(EXIT_FAILURE);
	}
	//borne + 1 pour inclure la borne
	listNumbers<<<borne + 1, 1>>>(dev_numbers);
	eratosthene<<<borne, 1>>>(dev_numbers, borne);
	cudaMemcpy(numbers, dev_numbers, (borne - 1) * sizeof(int), cudaMemcpyDeviceToHost);
	if (ret != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		exit(EXIT_FAILURE);
	}
	int *result = (int *) malloc(borne * sizeof(int));
	int taille = primeList(numbers, result, borne);
	for (int i = 0; i < taille; i++) {
		printf("%d\n", result[i]);
	}
	cudaFree(dev_numbers);
	free(numbers);
	free(result);
	return EXIT_SUCCESS;
}
