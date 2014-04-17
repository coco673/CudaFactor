#include "prime.h"
/*
// Cette fonctions elimine les multiples de chaques nombres
// Ce qui a pour effet d'enlever les nombres non premiers
// list contient tous les nombres de 2 a borne
// borne est la borne
__global__ void eratosthene(int *list, int borne) {
	int id = blockIdx.x;
	int limite = (int) sqrt((double) borne);
	for (int i = id + 1; i <= borne; i++) {
		if (list[i] != 0 && (list[i] % list[id]) == 0) {
			list[i] = 0;
		}
	}
}

// Cette fonction remplie la liste des nombres de 2 à la borne choisie (nb de blocks cuda)
// list est la liste a remplir
__global__ void listNumbers(int *list) {
	int id = blockIdx.x;
	if (id != 0 && id != 1) {
		list[id - 2] = id;
	}
}

// Copie d'un tableau en Cuda
// src est le tableau source
// dest est le tableau de destination
// size est la taille de src
__global__ void copyTab(int *src, int *dest, int size) {
	int id = blockIdx.x;
	if (id < size) {
		dest[id] = src[id];
	}
}

// Cette fonction reduit le tableau des nombres premiers en enlevant les 0 inutiles
// list est le tableau de premiers avec les zeros inutiles
// result est le tableau contenant le resultat
// borne est la borne choisie
// Cette fonction retourne la taille de result
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

// Genere la liste d'entiers premiers
// borne est la limite max des nb premiers generes
// tailleResult est la taille du tableau retourne
// Cette fonction retourne le tableau d'entiers
int *generatePrimeList(int borne, int *tailleResult) {
	if (borne < 2) {
		return NULL;
	}
	int *numbers;
	int *dev_numbers;
	//tableaux des nombres de 2 a borne
	numbers = (int *) malloc((borne - 1) * sizeof(int));
	int ret = cudaMalloc(&dev_numbers, ((borne - 1) * sizeof(int)));
	if (ret != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		return NULL;
	}
	//borne + 1 pour inclure la borne les blocks rentrent leur id
	listNumbers<<<borne + 1, 1>>>(dev_numbers);
	eratosthene<<<borne, 1>>>(dev_numbers, borne);
	cudaMemcpy(numbers, dev_numbers, (borne - 1) * sizeof(int), cudaMemcpyDeviceToHost);
	if (ret != cudaSuccess) {
		fprintf(stderr, "%s", cudaGetErrorString(cudaGetLastError()));
		return NULL;
	}
	int *result = (int *) malloc(borne * sizeof(int));
	int taille = primeList(numbers, result, borne);
	*tailleResult = taille;
	cudaFree(dev_numbers);
	free(numbers);
	return result;
}
*/

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

uint64_t *generatePrimeList(uint64_t borne, int *size) {
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
	for (uint64_t i = 0; i < (borne - 1); i++) {
		if (list[i] != 0) {
			(*size)++;
		}
	}
	uint64_t *res = (uint64_t *) malloc((*size) * sizeof(uint64_t));
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
