#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

int calcul_v(int *premList, int sizePremList, int m, int *matrix, int sizeMatrix, int *noyau) {
	int res_somme;
printf("OK on rentre\n");
	int res_produit = 1;
	printf("On passe apres le produit\n");
	for (int i = 0; i < sizePremList; i++) {
		//printf("debut de la boucle\n");
		res_somme = 0;
		for (int j = 0; j < m; j++) {
			//printf("debut de la deuxieme boucle %i %i\n",j,m);
			//printf("%i\n",res_somme);
			res_somme += matrix[j * sizeMatrix + i] * noyau[j];
		}
		//printf("on va diviser le res somme\n");
		res_somme /= 2;
		//printf("Middle\n");
		res_produit *= pow(premList[i], res_somme);
		//printf("result par la puissance\n");
	}
	printf("let's gO\n");
	return res_produit;
}
