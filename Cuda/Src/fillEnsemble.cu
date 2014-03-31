/*
 * fillEnsemble.cu
 *
 * Created on: 5 Feb. 2014
 * 	  Autor : tony
 */

#include "header/fillEnsemble.h"
#include "header/prime.h"
#include <string.h>
#include <curand_kernel.h>
#include <curand.h>
#include <cuda.h>
#include <cuda_runtime.h>
//nombre de bits à générer
#define N 1000

/**
 * retourne true si l'entier est B-friable false sinon. (Version cpu)
 */
bool isBSmooth(int *list,int size, int y){

	int i =0;
	bool val = true;
	if(list == NULL){
		fprintf(stderr,"list null\n");
		return -1;
	}
	while(i < size){
		if(list[i] > y){
			return false;
		}
		i++;
	}
	return val;
}
/**
 * Retourne true si l'entier fait partie de l'ensemble false sinon
 * (version CPu)
 */
bool isInEnsemble(ensemble ens, int y,int size){
	int i =0;
	if(ens == NULL){
		return false;
	}
	while(i <size ){
		if(ens[i].ind.val == y){
			return true;
		}
		i++;
	}
	return false;
}

/**
 * Mode GPU.
 * Verifie si chaque valeur contenue dans la liste des premiers (de taille size)
 * est inférieur a la valeur y.
 */
__device__ int isInf(int *list, int size, int y){
	int i = threadIdx.x;
	volatile __shared__ int res;
	if(i == 0){
		res = 0;
	}
	__syncthreads();
	if(i < size){

		if(list[i] > y){
			res=1;
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
__device__ void isBSmoothG(int *list,int size, int y,int *result){
	int i =threadIdx.x;
	volatile __shared__ int found;
	if(threadIdx.x == 0) found = 0;
	__syncthreads();

	if(found== 0 && i < size){
		bool inf = isInf(list,size,y);
		if(!inf){
			found = 1;
			*result = found;
		}
		__syncthreads();
		*result = found;
	}
}

/**
 * Mode GPU
 * Verifie si la valeur y fait partie de l'ensemble ens et stocke le resultat
 * res.
 * size est la taille de l'ensemble.
 */

__device__ void isInEnsembleG(ensemble ens, int y,int size, int *res){
	int i = threadIdx.x;
	volatile __shared__ int found;

	if (i == 0){
		found =0;
	}

	if(i < size){
		__syncthreads();
		if(ens == NULL || ens[i].ind.val == y){
			found = 1;
			*res = found;
		}
		__syncthreads();
		*res = found;

	}else if(size == 0){
		*res= found;
	}
}

/**
 * Construit l'ensemble R. (version CPU)
 */
void fillEnsemble(ensemble r,int nbr,int borne,ensemble div
		,int sizeDiv){
	int m=0;
	int k;
	int *p = generatePrimeList(borne,&k);
	k--;
	r = initEns(&m);

	int x;
	int y;
	int racN=sqrt(nbr);

	srand(time(NULL));

	while(m < k+1){
		x = racN+(rand() % ((nbr-1) - racN));
		y = pow(x,2);
		y=y%nbr;

		if(isBSmooth(p,k,y) && !isInEnsemble(div,y,sizeDiv)){
			addCouple(&r,x,y,&m);

		}
	}
}

__device__ void setup_kernel ( curandState_t *state )
{
	//int id = threadIdx.x + blockIdx.x+ blockDim.x;
	int id = threadIdx.x + blockIdx.x;
	curand_init ( clock64()+id, id, 0, &state[id] );
}

__device__ void generate( curandState_t *globalState, int *rand, int nbr, int racN)
{
	//int id = threadIdx.x + blockIdx.x+ blockDim.x;
	int id = threadIdx.x + blockIdx.x;
	float x;

	curandState_t localState = globalState[id];
	for(int n = 0; n < N; n++) {
		x = fmodf(curand(&localState),(nbr-racN)) + racN;
	}
	globalState[id] = localState;
	rand[id] = (int) x;
}


__device__ int generateRonce(ensemble r,int *p,int k,int nbr,ensemble div,int sizeDiv, int *sizeR,int *matrix){
	int i =  threadIdx.x;
	uint x;
	uint y;

	volatile __shared__ int ret;
	if (i == 0) {
		ret = -1;
	}
	__syncthreads();

	int racN = (int)sqrtf(nbr);

	int *rand=(int*)malloc((blockDim.x*gridDim.x)*sizeof(int));
	int *bsmooth = (int *)malloc(sizeof(int));
	int *present = (int *)malloc(sizeof(int));
	curandState_t *devStates;
	devStates=(curandState_t *) malloc ((blockDim.x*gridDim.x)*sizeof( curandState_t ) );

	// setup seeds
	setup_kernel( devStates);
	do{
		// generate random numbers
		generate( devStates, rand,nbr,racN);

		if(i < k+1){
			x = rand[i];
			y= (uint)(x*x)%nbr;

			isBSmoothG(p,k,y,bsmooth);
			isInEnsembleG(div,y,sizeDiv,present);
		}
		} while(!(*bsmooth) && (*present));

		if(i<k+1){
			__syncthreads();

			if((*bsmooth) && !(*present)){
				r[i].ind.couple.x = x;
				r[i].ind.couple.y = y;

				int y1 = y;
				for(int j = 0;j<k;j++){

					while(y1%p[j] == 0){
						y1 = y1 / p[j];
						matrix[(k*i)+j]=(matrix[(k*i)+j]+1)%2;
					}
				}
				ret = 0;
			}
			__syncthreads();
		}


		free(rand);
		free(bsmooth);
		free(present);
		free(devStates);

		return ret;
	}
	__global__ void fillEnsembleG(ensemble r,int *p,int k,int nbr,int borne
			,ensemble div,int sizeDiv,int *sizeR,int *matrix){
		int res = 0;
		__shared__ int i;
		int size = 0;
		int tid=threadIdx.x;

		if( tid == 0) {
			i = 0;
			size = 0;
		}
		__syncthreads();
		res = generateRonce(r,p,k,nbr,div,sizeDiv,&size,matrix);

		if(res == 0){
			atomicAdd(&i,1);

		}
		*sizeR=i;
	}

