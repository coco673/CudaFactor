#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "initV.h"

int calcul_v(uint64_t *premList, int sizePremList, int m, int *matrix, int sizeMatrix, int *noyau) {
	int res_somme;
	int res_produit = 1;
	for (int i = 0; i < sizePremList; i++) {
		res_somme = 0;
		for (int j = 0; j < m; j++) {
			res_somme += matrix[j * sizeMatrix + i] * noyau[j];
		}
		res_somme /= 2;
		res_produit *= pow(premList[i], res_somme);
	}
	return res_produit;
}
