/**
 * gauss.cu
 */
#include "header/gauss.h"

#include <unistd.h>
void print_matrix(int **matrix, int size) {
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			printf("%d\t", matrix[i][j]);
		}
		printf("\n");
	}
}

//Avec des matrix2D
Vector_List *gaussjordan_noyau(char **matrix, int size) {
	int pivo,jc,jl,k,j,nl,nc,l,a;
	matrix2D Mat;
	Mat.mat = matrix;
	Mat.colsNb = size;
	Mat.rowsNb = size;
	matrix2D *tmpMat = copyMatrix2D(Mat);
	nl = tmpMat->rowsNb;
	nc = tmpMat->colsNb;
	//on met des 0 sous la diagonale
	jc = 0;
	jl = 0;

	// on traite toutes les colonnes
	while (jc < nc and jl < nl) {
		//choix du pivot que l'on veut mettre en M[jl,jc]
		k = jl;
		while (tmpMat->mat[k][jc] == 0 and k < nl-1) {
			k = k + 1;
		}
		//on ne fait la suite que si on a pivo!=0
		if (tmpMat->mat[k][jc] != 0) {
			pivo = tmpMat->mat[k][jc];
			//echange de la ligne jl et de la ligne k
			swapLineMatrix2D(tmpMat, jl, k);
			//fin du choix du pivot qui est M[jl,jc]
			//on met 1 sur la diagonale de la colonne jc
			for (l = 0; l < nc; l++) {
				tmpMat->mat[jl][l] = tmpMat->mat[jl][l] / pivo;
			}

			//on met des 0 au dessus de la diagonale
			// de la colonne jc
			for (k = 0; k < jl; k++) {
				a = tmpMat->mat[k][jc];
				for (l = 0; l < nc; l++) {
					tmpMat->mat[k][l] = tmpMat->mat[k][l] - tmpMat->mat[jl][l] * a;
				}
			}
			//on met des 0 sous la diag de la colonne jc
			for (k = jl + 1; k < nl; k++) {
				a = tmpMat->mat[k][jc];
				for (l = jc; l < nc; l++) {
					tmpMat->mat[k][l] = tmpMat->mat[k][l] - tmpMat->mat[jl][l] * a;
				}
			}
		} else {
			//on ajoute une ligne de 0 si ce n'est pas le dernier 0
			if (jl < nc - 1) {
				tmpMat = addLineToMatrix2D(tmpMat, 0, jl);
				nl = nl + 1;
			}
		}
		//ds tous les cas,le numero de colonne et
		//le numero de ligne augmente de 1
		jc = jc + 1;
		jl = jl + 1;
		//il faut faire toutes les colonnes
		if (jl == nl and jl < nc) {
			tmpMat = addLineToMatrix2D(tmpMat, 0, nl);
			nl++;
		}


	}

	int *noyau;
	Vector_List *listNoyau = createVectorList();
	//on enleve les lignes en trop pour avoir
	//une matrice carree de dim nc
	//on retranche la matrice identite
	for (int tmp = 0; tmp < nc; tmp++) {
		tmpMat->mat[tmp][tmp] = tmpMat->mat[tmp][tmp] - 1;
	}
	for(j = 0; j < nc; j++) {
		noyau = (int *) malloc(tmpMat->rowsNb * sizeof(int));
		if (tmpMat->mat[j][j] == -1) {
			for (int i = 0; i < nc; i++) {
				noyau[i] = tmpMat->mat[i][j];
			}
			addVector(listNoyau, noyau, tmpMat->rowsNb);
		}
		free(noyau);
	}
	for (int i =0;i<tmpMat->colsNb;i++){
		free(tmpMat->mat[i]);
	}
	free(tmpMat->mat);
	free(tmpMat);
	return listNoyau;
}
