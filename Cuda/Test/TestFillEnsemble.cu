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

	assert(isBSmooth(list, size, val));

	val = 10;
	assert(!isBSmooth(list, size, val));

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

	return 0;
}
__global__ void isInfKernel(int *dev_list,bool *result,int size,int val){
	int i =threadIdx.x;
	volatile __shared__ bool found;
	if(threadIdx.x == 0) found = false;
	__syncthreads();

	if(found== false  && i < size){
		bool inf = isInf(dev_list,size,val);
		if(inf){
			found = true;
			*result = found;
		}
		__syncthreads();
		*result = found;
	}
}

int TestIsInf(){
	int borne = 99;
	int val = 20;
	int size;
	int *list = generatePrimeList(borne,&size);
	int *dev_list;
	bool *dev_result;
	bool *result=(bool *) malloc(sizeof(bool));

	cudaMalloc(&dev_list,size*sizeof(int));
	cudaMalloc(&dev_result,sizeof(bool));
	cudaMemcpy(dev_list,list,size*sizeof(int),cudaMemcpyHostToDevice);
	int i;

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

	//free(result);
	free(list);
	cudaFree(dev_result);
	cudaFree(dev_list);

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

	int *dev_list;
	int *dev_result;
	int *result=(int *) malloc(sizeof(int));

	cudaMalloc(&dev_list,size*sizeof(int));
	cudaMalloc(&dev_result,sizeof(int));
	cudaMemcpy(dev_list,list,size*sizeof(int),cudaMemcpyHostToDevice);

	IsBSmoothKernel<<<1,size>>>(dev_list,size,borne,dev_result);
	cudaMemcpy(result,dev_result,sizeof(int),cudaMemcpyDeviceToHost);

	assert(*result == 1);

	cudaFree(dev_result);
	free(result);
	free(list);
	size = 0;
	val = 200;
	list = generatePrimeList(val,&size);

	cudaMalloc(&dev_list,size*sizeof(int));
	cudaMalloc(&dev_result,sizeof(int));
	cudaMemcpy(dev_list,list,size*sizeof(int),cudaMemcpyHostToDevice);

	result = (int *) malloc(sizeof(int));
	IsBSmoothKernel<<<1,size>>>(dev_list,size,borne,dev_result);
	cudaMemcpy(result,dev_result,sizeof(int),cudaMemcpyDeviceToHost);

	assert(*result == 0);
	cudaFree(dev_result);
	free(result);
	free(list);
	return 0;
}

__global__ void IsInEnsembleKernel(ensemble ens,int size, int y,int *result){

	isInEnsembleG(ens,size,y,result);
	//*result = 1;

}

int TestIsInEnsembleG(){

	int size;
	ensemble ens = initEns(&size);
ensemble dev_ens;
	int val = 22;

	int *dev_result;
	int i;
	for (i = 0; i < 32; i++){
		addVal(ens,i,&size);
	}

	int *result=(int *) malloc(size*sizeof(int));

		cudaMalloc(&dev_ens,size*sizeof(struct cell));
		cudaMalloc(&dev_result,size*sizeof(int));
		cudaMemcpy(dev_ens,ens,size*sizeof(struct cell),cudaMemcpyHostToDevice);

		IsInEnsembleKernel<<<1,size>>>(dev_ens,size,val,dev_result);
		cudaMemcpy(result,dev_result,size*sizeof(int),cudaMemcpyDeviceToHost);

	assert(*result == 1);
	free(result);
	cudaFree(dev_result);
	val = 20045;
	cudaMalloc(&dev_result,sizeof(int));
	int *result2 = (int *) malloc(sizeof(int));
	IsInEnsembleKernel<<<1,size>>>(ens,size,val,dev_result);
	cudaMemcpy(result2,dev_result,sizeof(int),cudaMemcpyDeviceToHost);
printf("result %i\n",*result2);
	assert(*result == 0);

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
	int *size;
	cudaMalloc(&size,5*sizeof(int));
	int k;
	int nbr = 257;
	int borne = 10;
	ensemble div = initEns(&sizediv);
	ensemble e ;
	int *p =generatePrimeList(borne,&k);
	int *x=(int *)malloc(5*sizeof(int));
	fillEnsembleG<<<5,1>>>(e,p,k,nbr,borne,div,sizediv,size);
	cudaMemcpy(x,size,5*sizeof(int),cudaMemcpyDeviceToHost);
	printf("x :%i\n",x[0]);
	printf("x :%i\n",x[1]);
	printf("x :%i\n",x[2]);
	printf("x :%i\n",x[3]);
	return 0;
}

