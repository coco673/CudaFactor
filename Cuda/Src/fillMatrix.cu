#include "header/fillMatrix.h"

/*
 * Calcul la representation binaire d'un int avec une taille fixée
 * Parametres :
 *     tab : Le tableau contenant la representation binaire
 *     n : le nombre a decomposer
 *     size : la taille de la representation binaire
 */
__device__ __host__ void intToBinWithSize(int *tab, int n, int size) {
    int i;
    for(i = 0; i < size; i++)
        tab[i] = (n >> ((size - 1) - i)) & 0x1;
}

/*__device__ int *intToBin(int n, int *tab_size) {
	int size = ((int) ((double) floor((double) log(n)/ (double) log(2)))) + 1;
	int *tab = (int *) malloc(size * sizeof(int));
	intToBinWithSize(tab, n, size);
	*tab_size = size;
	return tab;
}*/

/*
 * Parametres :
 *     yList : La liste des y de l'ensemble des couples
 *     premList : La liste des premiers construite au départ
 *     size : La taille de la representation binaire du thread le plus grand
 *     result : le vecteur trouvé, NULL s'il est pas trouvé
 * Contraintes :
 *     A lancer avec taille(yList) blocks et 2^(taille(premList)) threads
 * Resultat :
 *     La matrice des vecteurs qui sont décomposition des y de yList en facteurs premiers stockée dans result
 */
__global__ void fillMatrix(int *yList, int *premList, int size, int **result) {
	__shared__ volatile int found;
	int blockId = blockIdx.x;
	int threadId = threadIdx.x;
	if (threadId == 0) {
		found = 0;
		//result[blockId] = (int *) malloc(size * sizeof(int));
	}
	__syncthreads();
	int *listCoeff = (int *) malloc(size * sizeof(int));
	intToBinWithSize(listCoeff, threadId, size);
	int res = 1;
	for (int i = 0; i < size; i++) {
		res *= (int) ((double) pow((double) premList[i], (double) listCoeff[i]));
	}
	if (yList[blockId] == res) {
		found = 1;
		result[blockId] = listCoeff;
	}
	__syncthreads();
	if (found == 0) {
		result[blockId] = NULL;
	}
}


