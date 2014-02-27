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
		if(ens[i].ind.val == y){
			found = 1;
			*res = found;
		}
		__syncthreads();
		*res = found;
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

__device__ void setup_kernel ( curandState * state, unsigned long seed )
{
	int id = threadIdx.x;
	int racN=sqrtf(seed);

	curand_init ( seed+id, id, racN, &state[id] );
}

__device__ void generate( curandState* globalState, int *rand)
{
	int ind = threadIdx.x;
	curandState localState = globalState[ind];
	*rand =(int) curand_uniform( &localState );
	globalState[ind] = localState;
}

/*int generateRandom(int n)
{
	dim3 tpb(n,1,1);
	curandState* devStates;
	cudaMalloc ( &devStates, N*sizeof( curandState ) );

	// setup seeds
	//setup_kernel <<< 1, tpb >>> ( devStates, time(NULL) );

	// generate random numbers
	//generate <<< 1, tpb >>> ( devStates );

	return 0;
}*/

__device__ int generateRonce(ensemble r,int *p,int k,int nbr,ensemble div,int sizeDiv, int *sizeR){
	int i = blockIdx.x;

	//TODO ajouter l'aléa
	int y;
	int *x=(int*)malloc(sizeof(int));
	int *bsmooth = (int *)malloc(sizeof(int));
	int *present = (int *)malloc(sizeof(int));

	curandState* devStates;
	devStates=(curandState*) malloc (k*sizeof( curandState ) );
	// setup seeds
	setup_kernel( devStates, nbr );

	// generate random numbers
	generate( devStates, x);

	if(i < k+1){

		y = powf(*x,2);
		y=y%nbr;
		isBSmoothG(p,k,y,bsmooth);
		isInEnsembleG(div,y,sizeDiv,present);

		if((*bsmooth) && !(*present)){
			addCouple(&r,*x,y,sizeR);
			return 0;
		}
	}
	return -1;
}
__global__ void fillEnsembleG(ensemble r,int *p,int k,int nbr,int borne
		,ensemble div,int sizeDiv,int *sizeR){
	int res;
	//TODO la boucle.
	do{
		res = generateRonce(r,p,k,nbr,div,sizeDiv,sizeR);
	}while(res != 0);
}

