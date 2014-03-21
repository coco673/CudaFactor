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
		addVal(&e,i,&size);
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
	int val = 12;

	int *dev_result;
	int i;
	for (i = 0; i < 16; i++){
		addVal(&ens,i,&size);

	}

	int *result=(int *) malloc(sizeof(int));
	cudaMalloc(&dev_ens,size*sizeof(struct cell));
	cudaMalloc(&dev_result,sizeof(int));

	cudaMemcpy(dev_ens,ens,size*sizeof(struct cell),cudaMemcpyHostToDevice);
	IsInEnsembleKernel<<<1,size>>>(dev_ens,size,val,dev_result);
	cudaMemcpy(result,dev_result,sizeof(int),cudaMemcpyDeviceToHost);

	assert(*result == 1);

	cudaFree(dev_result);
	val = 20045;
	result=(int *) malloc(size*sizeof(int));

	cudaMalloc(&dev_result,size*sizeof(int));
	IsInEnsembleKernel<<<1,size>>>(dev_ens,size,val,dev_result);
	cudaMemcpy(result,dev_result,size*sizeof(int),cudaMemcpyDeviceToHost);

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
	ensemble dev_div;
	ensemble r ;
	ensemble dev_r;
	int *p =generatePrimeList(borne,&k);
	k--;
	int *dev_p;

	cudaMalloc(&dev_p,k*sizeof(int));
	cudaMalloc(&dev_size,sizeof(int));
	cudaMalloc(&dev_r,sizeof(struct cell));
	cudaMalloc(&dev_div,sizediv*sizeof(struct cell));
	cudaMalloc(&dev_div,sizediv*sizeof(struct cell));

	cudaMemcpy(dev_p,p,k*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_p,p,k*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_div,div,sizediv*sizeof(struct cell),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_size,size,sizeof(int),cudaMemcpyHostToDevice);

	fillEnsembleG<<<1,k>>>(dev_r,dev_p,k,nbr,borne,dev_div,sizediv,dev_size);

	cudaMemcpy(size,dev_size,sizeof(int),cudaMemcpyDeviceToHost);
	cudaMemcpy(r,dev_r,(*size)*sizeof(struct cell),cudaMemcpyDeviceToHost);
printf("size %i\n",*size);
for (int i =0; i<(*size);i++){
	printf("x = %i ; y= %i\n",r[i].ind.couple.x,r[i].ind.couple.y);

}
	return 0;
}

__global__ void setup_kernelGen(int *rand){
	int id = threadIdx.x;
	int nbr = 29;
	int racN = 12;
	int *tprand = (int*) malloc(gridDim.x*sizeof(int));

	curandState_t *local = (curandState_t*)malloc((blockDim.x*gridDim.x)*sizeof(curandState_t));
	setup_kernel(local);
	generate(local,tprand,nbr,racN);
	rand[id] = tprand[id];

}
int TestGenerateOnce(){
	int *rand = (int *)malloc(10*sizeof(int));
	int *dev_rand;

	cudaMalloc(&dev_rand,10*sizeof(int));


	setup_kernelGen<<<1,10>>>(dev_rand);
	cudaMemcpy(rand,dev_rand,10*sizeof(int),cudaMemcpyDeviceToHost);

}
