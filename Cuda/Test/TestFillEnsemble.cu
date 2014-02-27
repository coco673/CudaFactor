/*
 *  TestFillEnsemble.c
 *  
 *
 *  Created by Tony on 21/02/2014.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */

#include "TestFillEnsemble.h"
#include "../Src/header/prime.h"
#include "../Src/header/fillEnsemble.h"
#include <cuda.h>
#include <cuda_runtime.h>
#include <curand.h>
#include <curand_kernel.h>

int TestIsBSmooth(){
	int size;
	int borne = 100;
	int val = 200;
	int *list = generatePrimeList(borne,&size);
	size--;
	assert(isBSmooth(list, size, val));

	val = 10;
	assert(!isBSmooth(list, size, val));
	free(list);
	return 0;
}
int TestIsInEnsemble(){
	int size,i;
	ensemble e = initEns(&size);

	for (i = 0; i < 32; i++){
		addVal(e,i,&size);
	}
	assert(isInEnsemble(e,12,size) == 1);
	assert(isInEnsemble(e,44,size) == 0);
	free(e);
	return 0;
}
__global__ void isInfKernel(int *dev_list,bool *result,int size,int val){
	int i =threadIdx.x;
	volatile __shared__ bool found;
	if(threadIdx.x == 0) found = false;
	__syncthreads();
	//Attention size prend une valeur de trop et bien superieur à la borne !!
	//TODO Rectifier la fonction generatePrimeList
	if(found== false  && i < size-1){
		int inf = isInf(dev_list,size-1,val);
		if(inf){
			found = true;
			*result = found;
		}
		__syncthreads();
		*result = found;
	}
}

int TestIsInf(){
	int borne = 20;
	int val = 8;
	int size;

	int *list = generatePrimeList(borne,&size);
	int *dev_list;
	bool *dev_result;
	bool *result=(bool *) malloc(sizeof(bool));

	cudaMalloc(&dev_list,size*sizeof(int));
	cudaMalloc(&dev_result,sizeof(bool));
	cudaMemcpy(dev_list,list,size*sizeof(int),cudaMemcpyHostToDevice);


	isInfKernel<<<1,size>>>(dev_list,dev_result,size,val);
	cudaMemcpy(result,dev_result,sizeof(bool),cudaMemcpyDeviceToHost);
	assert(*result == true);

	free(result);
	cudaFree(dev_result);

	val = 200;
	cudaMalloc(&dev_result,sizeof(bool));
	cudaMemcpy(dev_list,list,size*sizeof(int),cudaMemcpyHostToDevice);

	isInfKernel<<<1,size>>>(dev_list,dev_result,size,val);
	cudaMemcpy(result,dev_result,sizeof(bool),cudaMemcpyDeviceToHost);
	assert(*result == false);


	cudaFree(dev_result);
	cudaFree(dev_list);
	//free(result);
	free(list);
	return 0;
}
__global__ void IsBSmoothKernel(int *list,int size, int y,int *result){

	isBSmoothG(list,size,y,result);
}
int TestIsBSmoothG(){
	int borne = 99;
	int val = 20;
	int size;
	int *list = generatePrimeList(val,&size);
	//Rectification temporaire
	size--;
	int *dev_list;
	int *dev_result;
	int *result=(int *) malloc(sizeof(int));

	cudaMalloc(&dev_list,size*sizeof(int));
	cudaMalloc(&dev_result,sizeof(int));
	cudaMemcpy(dev_list,list,size*sizeof(int),cudaMemcpyHostToDevice);

	IsBSmoothKernel<<<1,size>>>(dev_list,size,borne,dev_result);
	cudaMemcpy(result,dev_result,sizeof(int),cudaMemcpyDeviceToHost);

	assert(*result == 1);

	cudaFree(dev_list);
	cudaFree(dev_result);
	free(result);
	free(list);
	size = 0;
	val = 200;
	list = generatePrimeList(val,&size);
	//Rectification temporaire
	size--;
	cudaMalloc(&dev_list,size*sizeof(int));
	cudaMalloc(&dev_result,sizeof(int));
	cudaMemcpy(dev_list,list,size*sizeof(int),cudaMemcpyHostToDevice);

	result = (int *) malloc(sizeof(int));
	IsBSmoothKernel<<<1,size>>>(dev_list,size,borne,dev_result);
	cudaMemcpy(result,dev_result,sizeof(int),cudaMemcpyDeviceToHost);

	assert(*result == 0);

	cudaFree(dev_list);
	cudaFree(dev_result);
	free(result);
	free(list);
	return 0;
}

__global__ void IsInEnsembleKernel(ensemble ens,int size, int y,int *result){

	isInEnsembleG(ens,y,size,result);

}

int TestIsInEnsembleG(){

	int size;
	ensemble ens = initEns(&size);
	ensemble dev_ens;
	int val = 22;

	int *dev_result;
	int i;
//TODO revoir addVall
	for (i = 0; i < 16; i++){
		addVal(ens,i,&size);
		printf("sizeof %i ::ens[%i] = %i :: size = %i :: i = %i\n",sizeof(ens),i,ens[i].ind.val,size,i);

	}
	int *result=(int *) malloc(sizeof(int));
	cudaMalloc(&dev_ens,size*sizeof(struct cell));
	cudaMalloc(&dev_result,sizeof(int));
	cudaMemcpy(dev_ens,ens,size*sizeof(struct cell),cudaMemcpyHostToDevice);
	IsInEnsembleKernel<<<1,size>>>(dev_ens,size,val,dev_result);
	cudaMemcpy(result,dev_result,sizeof(int),cudaMemcpyDeviceToHost);
	printf("%i\n",*result);
	assert(*result == 1);


	//free(result);
	cudaFree(dev_result);
	val = 20045;
	result=(int *) malloc(size*sizeof(int));

	cudaMalloc(&dev_result,size*sizeof(int));
	printf("val : %i\n",val);
	IsInEnsembleKernel<<<1,size>>>(dev_ens,size,val,dev_result);
	cudaMemcpy(result,dev_result,size*sizeof(int),cudaMemcpyDeviceToHost);
	printf("%i\n",*result);
	assert(*result == 0);


	cudaFree(dev_result);
	free(ens);
	cudaFree(dev_ens);

	return 0;
}


int TestfillEnsemble(){
	int size;
	int nbr = 257;
	int borne = 10;
	ensemble div = initEns(&size);
	ensemble e ;
	fillEnsemble(e,nbr,borne,div,size);

	return 0;
}
int TestfillEnsembleG(){
	int sizediv;
	int *size=(int *)malloc(sizeof(int));

	int *dev_size;
	int k;
	int nbr = 257349;
	int borne = 10;
	ensemble div = initEns(&sizediv);
	ensemble r =initEns(size);
	ensemble dev_r;
	int *p =generatePrimeList(borne,&k);
	k--;


	cudaMalloc(&dev_size,sizeof(int));
	cudaMalloc(&dev_r,sizeof(struct cell));

	cudaMemcpy(dev_r,r,sizeof(struct cell),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_size,size,sizeof(int),cudaMemcpyHostToDevice);

	fillEnsembleG<<<5,1>>>(dev_r,p,k,nbr,borne,div,sizediv,dev_size);

	cudaMemcpy(size,dev_size,sizeof(int),cudaMemcpyDeviceToHost);
	cudaMemcpy(r,dev_r,*size*sizeof(struct cell),cudaMemcpyDeviceToHost);

	return 0;
}

