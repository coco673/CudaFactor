/*
 * fillEns.cu
 *
 */

#include <stdio.h>
#include "header/fillEns.h"
#include "header/intList.h"
#include "header/prime.h"
#include <assert.h>
#define N 1000

__device__ curandState_t localState;

/**
 * Mode GPU.
 * Verifie si chaque valeur contenue dans la liste des premiers (de taille size)
 * est inférieur a la valeur y.
 */
__device__ int isInf(uint64_t *list, int size, uint64_t y){
	int i = threadIdx.x;
	int res= 0;
	__syncthreads();
	if (i < size) {
		for (int j = 0; j <= size; j++) {
			if (list[j] > y) {
				res = 1;
				break;
			}
		}
		__syncthreads();
	}
	return res;
}

/**
 * Mode GPU
 * Verifie si la valeur y est B-friable.
 * list est la liste des premiers de la borne
 * result le resultat retourné
 */
__device__ void isBSmoothG(int *devPremList, int size, uint64_t y,int *result){
	int i = threadIdx.x+blockIdx.x*blockDim.x;
	if(i < size) {
		uint64_t y1 = y;
		if (y1 == 0) {
			*result = 0;
		} else {

			for (int j = 0; j < size; j++) {
				while (y1 % devPremList[j] == 0) {
					y1 = y1 / devPremList[j];
				}
			}
			__syncthreads();
			if (y1 == 1) {
				*result = 1;
			} else {
				*result = 0;
			}
		}
	}
}

/**
 * Mode GPU
 * Verifie si la valeur y fait partie de l'ensemble ens et stocke le resultat
 * res.
 * size est la taille de l'ensemble.
 */

__device__ void isInEnsembleG(uint64_t *ens, uint64_t y,int size, int *res){
	int i = threadIdx.x+blockIdx.x*blockDim.x;
	int found = 0;

	__syncthreads();
	if(i < size) {

		for (int j = 0; j < size; j++) {
			if (getValGPU(ens,j) == y) {
				found = 1;
			}
		}
	}
	__syncthreads();
	*res = found;
}

__device__ void setup_kernel ( curandState_t *state ) {
	int id = threadIdx.x + blockIdx.x*blockDim.x;
	curand_init ( clock64()+id, id, 0, &state[id] );
}

__device__ void generate( curandState_t *globalState, uint64_t *rand, uint64_t nbr, uint64_t racN) {

	int id = threadIdx.x + blockIdx.x*blockDim.x ;
	uint64_t x;

	localState = globalState[id];
	x = (uint64_t)fmodf(curand(&localState),(nbr-racN)) + racN;
	globalState[id] = localState;
	rand[id] = (uint64_t) x;
}

__global__ void Generation(curandState_t *state,uint64_t nbr, uint64_t sqrtNBR,uint64_t *rand){
	setup_kernel(state);
}

__global__ void fillEnsR(curandState_t *state,Couple *R,int *size,uint64_t *Div,int sizeDiv,int * devPremList,int k,uint64_t *rand,uint64_t nbr,uint64_t sqrtNBR,char *matrix){	int tid = threadIdx.x + blockIdx.x * blockDim.x;

	__shared__ int sizeR;
	Couple tmp;
	__shared__ char *matTmp;
	int bsmooth= -1;
	int present= -1;
	uint64_t x = 0;
	uint64_t y =  0;
	if (tid % blockDim.x == 0) {
		sizeR = 0;
		matTmp = (char *)malloc((k*k)*sizeof(char));
		memset(matTmp,0,(k*k)*sizeof(char));
	}
	__syncthreads();


	do {
		generate(state,rand,nbr,sqrtNBR);

		x = rand[tid];
		y = (x * x) % nbr;

		if (devPremList == NULL ) {
			printf("PrimeList est NULL\n");
		}
		if (k <= 0 ) {
			printf("valeur de K <= 0 \n");
		}

		isBSmoothG(devPremList, k,y,&bsmooth);

		isInEnsembleG(Div,y,sizeDiv,&present);


	} while(!bsmooth || present);

	tmp.x = x;
	tmp.y = y;
	__syncthreads();
	atomicAdd(&sizeR,1);
	uint64_t y1 = y;
	for (int j = 0; j < k; j++) {
		while (y1 % devPremList[j] == 0) {
			y1 = y1 / devPremList[j];
			matTmp[threadIdx.x*k+j] = (matTmp[threadIdx.x*k+j] + 1);
		}
	}
	__syncthreads();

	R[tid] = tmp;

	for (int j = 0; j < k; j++) {
		matrix[tid*k+j] = matTmp[threadIdx.x*k+j];
	}	
	if (tid % blockDim.x == 0) {
		free(matTmp);
		atomicAdd(size, sizeR);
	}
}
