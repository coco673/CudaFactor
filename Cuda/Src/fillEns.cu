/*
 * fillEns.cu
 *
 *  Created on: 3 avr. 2014
 *      Author: groupeDev
 */
#include <stdio.h>
#include "fillEnsemble.h"
#include "prime.h"
#define N 1000
/**
 * Mode GPU.
 * Verifie si chaque valeur contenue dans la liste des premiers (de taille size)
 * est inférieur a la valeur y.
 */
__device__ int isInf(int *list, int size, int y){
	int i = threadIdx.x;
	int res= 0;
	/*if(i == 0){
		res = 0;
	}*/
	__syncthreads();
	if(i < size){
		printf("size = %i\n",size);
		for(int j = 0; j <= size;j ++){
			printf("thread = %i y = %i :: list[%i] = %i j = %i\n",i,y,j,list[j]);
			if(list[j] > y){
				res=1;
				break;
			}
		}
		printf("y = %i::res = %i\n",y,res);
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
__device__ void isBSmoothG(int *list,int size, int y,int *result){
	int i =threadIdx.x+blockIdx.x;
	if(i < size){
		int y1 = y;
		if(y1 == 0){
			*result = 0;
		}else{

			for(int j = 0; j< size;j++){
				while(y1 % list[j] == 0){
					y1=y1/list[j];
				}
			}
			__syncthreads();
			if(y1 == 1){
				*result= 1;
			} else {
				*result= 0;
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

__device__ void isInEnsembleG(ensemble ens, int y,int size, int *res){
	int i = threadIdx.x+blockIdx.x;
	int found = 0;

	printf("debut\n");
	printf("size = %i\n",size);
	__syncthreads();
	if(i < size){

		for(int j=0;j<size;j++){
			if(ens == NULL || ens[j].ind.val == y){
				found = 1;
			}
		}
	}
	__syncthreads();
	*res = found;
	printf("fin ! %i\n",found);
	printf("fin 2! %i\n",*res);

}

__device__ void setup_kernel ( curandState_t *state )
{
	int id = threadIdx.x + blockIdx.x;
	//int id = threadIdx.x;
	printf("l h eure de %i\n",clock());
	curand_init ( clock()+id, id, 0, &state[id] );
}

__device__ void generate( curandState_t *globalState, int *rand, int nbr, int racN)
{

	int id = threadIdx.x + blockIdx.x ;
	//int id = threadIdx.x;
	float x;

	curandState_t localState = globalState[id];
	for(int n = 0; n < N; n++) {
		x = fmodf(curand(&localState),(nbr-racN)) + racN;
	}
	globalState[id] = localState;
	rand[id] = (int) x;
}

__global__ void Generation(curandState_t *state,int nbr, int sqrtNBR,int *rand){
	int i = threadIdx.x + blockIdx.x;
	setup_kernel(state);
}


__global__ void fillEnsR(curandState_t *state,ensemble R,int *size,ensemble Div,int *sizeDiv,int *premList,int k,int *rand,int nbr,int *matrix){
	//int tid = threadIdx.x + blockIdx.x * blockDim.x;
	int tid=threadIdx.x+blockIdx.x;
	__shared__ int sizeR;
	int bsmooth= -1;
	int present= -1;
	int x = -1;
	int y =  -1;
	int nbt = 0;
	printf("tu print batard !!!!!!\n");
	if(tid == 0){
		sizeR = 0;
	}
	__syncthreads();
	printf("sizeDiv %i\n",*sizeDiv);
	//memset(matrix,0,(k*k)*sizeof(int));
	int sqrtNBR = (int) sqrtf(nbr);
	do{

		generate(state,rand,nbr,sqrtNBR);
		printf("yahou %i::%i\n",rand[tid],tid);

		x = rand[tid];
		y = (x*x) % nbr;

		isBSmoothG(premList,k,y,&bsmooth);
		isInEnsembleG(Div,y,*sizeDiv,&present);
		++nbt;
		__syncthreads();
		printf("je suis le thread %i et je suis au %i tours de boucle ::::: bsmooth %i pres = %i\n",tid,nbt,bsmooth,present);
	}while(!bsmooth || present);
	__syncthreads();
	printf("je suis le gentil  BON THREAD numéro : %i , j'ai fait  %i tours \n", tid, nbt);

		printf("ok\n");
	printf("la size de R est %i\n",sizeof(R));
	R[tid].ind.couple.x = x;
	printf("pourquoi ?? size = %i\n",sizeR);
	R[tid].ind.couple.y = y;
	atomicAdd(&sizeR,1);
	printf("x = %i y = %i size = %i\n",R[tid].ind.couple.x,R[tid].ind.couple.y,sizeR);
	int y1 = y;
	for(int j = 0;j<k;j++){
		while(y1%premList[j] == 0){
			y1 = y1 / premList[j];
			matrix[(k*tid)+j]=(matrix[(k*tid)+j]+1)%2;
			printf("ligne : %i , colonne : %i , valeur : %i\n", tid , j, matrix[(k*tid)+j]);
		}
	}
	__syncthreads();
	size[tid] = sizeR;


}
