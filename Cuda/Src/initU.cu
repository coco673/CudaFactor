/*
 * init.cu
 *
 *  Created on: 27 mars 2014
 *      Author: clement
 */



#include "header/initU.h"

/*
__global__ void prodPuissG(int *x, int puiss, int *res, int block) {
	int id = threadIdx.x + blockIdx.x * blockDim.x;
	if (id < puiss-1) {
		res[id] = x[block] * x[block];
	} else {
		res[id] = x[block];
	}
}

__global__ void sommeG(int *e, int *som, int size) {
	int id = threadIdx.x + blockIdx.x * blockDim.x;
		if (id < size-1) {
			som[id] = e[2*id] + e[2*id+1];
		} else {
			som[id] = e[2*id];
		}
}*/

int initU(int *x, int m, int *e) {
	int res = 1;
	for (int i = 0; i < m; i++) {
		if (e[i] != 0) {
			res = res * (x[i] * x[i]);
		}
	}
	return res;
}
/*
__global__ void initUG(int *x, int *e, int *prod) {
	int id = threadIdx.x + blockIdx.x * blockDim.x;
	int puiss = 2 * e[id];
	//int nbBlock;
	//int nbThread;
	int a = ceil(puiss/2);
	int b = floor(puiss/2)+1;
	int *res = (int*) malloc(a*sizeof(int));
	prodPuissG<<<1,a>>>(x, puiss, res, id);
	while (a > 1) {
		//nbBlock = ceil(puiss/1024);
		//nbThread = puiss%1024;
		b = floor(a/2)+1;
		a = ceil(a/2);
		prodPuissG<<<1,a>>>(res, b, res, id);
	}
	prod[id] = res[0];
}

int initU(int *x, int m, int *e) {
	int u;
	int *prodC;
	cudaMalloc(&prodC, m*sizeof(int));
	int *somC;
	cudaMalloc(&somC, (ceil(m/2))*sizeof(int));
	//int nbBlock = ceil(m/1024);
	//int nbThread = m%1024;
	int taille = m;
	int t;
	do {
		t = floor(taille/2)+1;
		taille = ceil(taille/2);
		sommeG<<<1,taille>>>(e, somC, t);
	} while (taille > 1);
	int somme;
	somme = 2 * somC[0];
	//cudaMemcpy(&somme, somC[0], sizeof(int), cudaMemcpyDeviceToHost);
	initUG<<<1,somme>>>(x, e, prodC);
	int *prod = (int*) malloc(m*sizeof(int));
	return u;
}*/
