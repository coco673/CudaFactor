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
	if(list == NULL){
		fprintf(stderr,"list null\n");
		return -1;
	}
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
__device__ bool isInf(int *list, int size, int y){
	int i = threadIdx.x;
	volatile __shared__ bool res;
	if(i == 0){
		res = true;
	}
	__syncthreads();
	if(i < size){

		if(list[i] > y){
			res=false;
		}
		__syncthreads();
		if(!res){
			return res;
		}
	}
	return res;
}

/**
 * Mode GPU
 * Verifie si la valeur y est B-friable.
 * list est la liste des premiers de la borne
 * result le resultat retourné
 */
__global__ void isBSmoothG(int *list,int size, int y,int *result){
	int i =threadIdx.x;
	volatile __shared__ int found;
	if(threadIdx.x == 0) found = 0;
	__syncthreads();

	if(found== 0 && i < size){
		bool inf = isInf(list,size,y);
		if(inf){
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

__global__ void isInEnsembleG(ensemble ens, int y,int size, int *res){
	int i =threadIdx.x;
	volatile __shared__ bool found;
	if(i == 0 ){
		found = false;
	}
	__syncthreads();

	if(i <size ){
		if(ens[i].ind.val == y){
			found = true;
			*res=found;
		}
		__syncthreads();
		*res = found;
	}

}


/**
 * Construit l'ensemble R. (version CPU)
 */
void fillEnsemble(ensemble r,int nbr,int borne,ensemble div,int sizeDiv){
	int m=0;
	int k;
	int *p = generatePrimeList(borne,&k);
	r = initEns(&m);

	int x;
	int y;
	int racN=sqrt(nbr);

	srand(time(NULL));

	while(m <= k+1){
		x = racN+(rand() % ((nbr-1) - racN));
		y = pow(x,2);
		y=y%nbr;

		if(isBSmooth(p,k,y) && !isInEnsemble(div,y,sizeDiv)){
			addCouple(r,x,y,&m);

		}
	}
}

