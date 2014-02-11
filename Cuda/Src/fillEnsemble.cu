/*
 * fillEnsemble.cu
 *
 * Created on: 5 Feb. 2014
 * 	  Autor : tony
 */

#include "header/fillEnsemble.h"
#include "header/prime.h"
#include <string.h>



/**
 * retourne true si l'entier est B-friable false sinon. (Version cpu)
 */
bool isBSmooth(int *list,int size, int y){

	int i =0;
	bool val = true;

	while(i < size){
		if(list[i] > y){
			val = false;
			break;
		}
		i++;
	}
	return val;
}
/**
 * retourne true si l'entier fait partie de l'ensemble false sinon
 * (version CPu)
 */
bool isInEnsemble(ensemble ens, int y,int size){
	int i =0;

	while(i <size ){
		if(ens[i].ind.val == y){
			return true;
		}
		i++;
	}
	return false;
}
__device__ bool isInf(int *list, int size, int base){
	int i = threadIdx.x;
	if(i < size){


		if(list[i] > base){
			return false;
		} else {
			return true;
		}
	}
}
__global__ void isBSmoothh(int *list,int size, int base, int y,int *result){
	printf("blahh\n");
int i =threadIdx.x;
	volatile __shared__ int found;
	if(threadIdx.x == 0) found = 1;
	__syncthreads();

	if(found== 1 && i < size){
		bool inf = isInf(list,size,base);
		if(!inf){
			found = 0;
			*result = found;
		}
		if(threadIdx.x == 0 && *result){
			found = false;
		}
		__syncthreads();
	}
*result=true;
}



__global__ void isInEnsembleG(ensemble ens, int y,int size, int *res){
	int i =0;
printf("kkkk");

	while(i <size ){
		if(ens[i].ind.val == y){
			*res = 1;
			break;
		}
		i++;
	}
	*res = 0;
}


/**
 * Construit l'ensemble R. (version CPU)
 */
void fillEnsemble(ensemble ens,int n,int base,ensemble div,int sizeDiv){
	int m=0;
	int k,sizeE;
	int size;
	ensemble e = initEns(&size);
	int *res = generatePrimeList(base,&k);

	while(m < k+1){
		int r = sqrt(n);
		srand(time(NULL));
		int x = (int)rand()/(double)RAND_MAX * (n-1) + r;
		int y = pow(x,2);
		y=y%n;
		int ysize;
		int *list = generatePrimeList(y,&ysize);
		if(isBSmooth(list,ysize,y) && !isInEnsemble(div,y,sizeDiv)){
			printf("x : %i\n y : %i",x,y);
			if((e=addCouple(ens,x,y,&sizeE)) == NULL){
				fprintf(stderr,"fillEnsemble: erreur lors de l'ajout du couple "
						"dans l'ensemble\n");
				exit(EXIT_FAILURE);
			}
			m = sizeE;
		}
	}
	ens = e;
}

