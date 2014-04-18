#include "header/gauss.h"


void print_matrix(int **matrix, int size) {
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			printf("%d\t", matrix[i][j]);
		}
		printf("\n");
	}
}

/*void print_matrix(int *matrix, int size) {
	for (int i = 0; i < size * size; i++) {
		//printf("%d\t", matrix[i]);
		if (i % size == 0) {
			//printf("\n");
		}
	}
}*/

/*int lcm(int x,int y) {
	int t = 0;
	while (y != 0) {
		t = y;
		y = x % y;
		x = t;
	}
	return x;
}


void gauss_elimination(int **matrix, int size) {
	int l = 0;
	int d1 = 0;
	int d2 = 0;
	for (int i = 0; i < size-1; i++) {
		for (int j = i+1; j < size; j++) {
			l = lcm(matrix[i][i], matrix[j][i]);
			if (l != 0 && (matrix[i][i] != 0 && matrix[j][i] != 0)) {
				l = (matrix[i][i] * matrix[j][i]) / l;
				d1 = l / matrix[i][i];
				d2 = l / matrix[j][i];
				matrix[j][i] = 0;
				for (int k = i+1; k < size; k++) {
					matrix[j][k] = (d2 * matrix[j][k]) - (d1 * matrix[i][k]);
				}
			}
		}
	}
}

void gauss_jordan_elimination(int **gauss_matrix, int size) {
	int l = 0;
	int d1 = 0;
	int d2 = 0;
	for (int i = size-1; i > 0; i--) {
		for (int j = i-1; j >= 0; j--) {
			l = lcm(gauss_matrix[i][i], gauss_matrix[j][i]);
			if (l != 0 && (gauss_matrix[i][i] != 0 && gauss_matrix[j][i] != 0)) {
				l = (gauss_matrix[i][i] * gauss_matrix[j][i]) / l;
				d1 = l / gauss_matrix[i][i];
				d2 = l / gauss_matrix[j][i];
				for (int k = 0; k <= size; k++) {
					gauss_matrix[j][k] = (d2 * gauss_matrix[j][k]) - (d1 * gauss_matrix[i][k]);
				}
			}
		}
	}
}

int *kernel(int **matrix, int size) {
	int *kernel = (int *) malloc(size * sizeof(int));
	gauss_elimination(matrix, size);
	gauss_jordan_elimination(matrix, size);
	for (int i = 0; i < size; i++) {
		kernel[i] = matrix[i][i];
	}
	return kernel;
}*/

/*int *gaussjordan_noyau(int **matrix, int size) {
	int pivo,j,temp,a,k,l;
	int nl = size;
	int nc = size;
	//on met des 0 sous la diagonale
	int jc = 0;
	int jl = 0;
	// on traite toutes les colonnes
	while (jc < nc && jl < nl) {
		//choix du pivot que l'on veut mettre en M[jl,jc]
		k = jl;
		while (matrix[k][jc] == 0 && k < nl-1) {
			k = k+1;
		}
		//on ne fait la suite que si on a pivo!=0
		if (matrix[k][jc] != 0) {
			pivo = matrix[k][jc];
			//echange de la ligne jl et de la ligne k
			for (l = jc; l < nc; l++){
				temp = matrix[jl][l];
				matrix[jl][l] = matrix[k][l];
				matrix[k][l] = temp;
			}
			//fin du choix du pivot qui est M[jl,jc]
			//on met 1 sur la diagonale de la colonne jc
			for (l = 0; l < nc; l++) {
				matrix[jl][l] = matrix[jl][l] / pivo;
			}
			//on met des 0 au dessus de la diagonale
			// de la colonne jc
			for (k = 0; k < jl; k++) {
				a = matrix[k][jc];
				for (l = 0; l < nc; l++) {
					matrix[k][l] = matrix[k][l] - matrix[jl][l] * a;
				}
			}
			//on met des 0 sous la diag de la colonne jc
			for (k = jl+1; k < nl; k++) {
				a = matrix[k][jc];
				for (l = jc; l < nc; l++) {
					matrix[k][l] = matrix[k][l] - matrix[jl][l] * a;
				}
			}
		} else {
			//on ajoute une ligne de 0 si ce n'est pas le dernier 0
			if (jl < nc-1) {
				for (j = nl; j > jl; j--) {
					//matrix[j] = matrix[j-1];
					for (int tmp = 0; tmp < size; tmp++) {
						matrix[j][tmp] = matrix[j-1][tmp];
					}
				}
				//M[jl] = makelist(0,1,nc);
				for (int tmp = 0; tmp < size; tmp++) {
					matrix[jl][tmp] = 0;
				}
				nl = nl + 1;
			}
		}
		//ds tous les cas,le numero de colonne et
		//le numero de ligne augmente de 1
		jc = jc + 1;
		jl = jl + 1;
		//il faut faire toutes les colonnes
		if (jl == nl && jl < nc) {
			//matrix[nl] = makelist(0,1,nc);
			for (int tmp = 0; tmp < size; tmp++) {
				matrix[nl][tmp] = 0;
			}
			nl = nl + 1;
		}
	}
	int *noyau = (int *) malloc(size * sizeof(int));
	//on enleve les lignes en trop pour avoir
	//une matrice carree de dim nc
	//on retranche la matrice identite
	//matrix = matrix[0..nc-1] - idn(nc);
	for (int tmp = 0; tmp < nc; tmp++) {
		matrix[tmp][tmp] = matrix[tmp][tmp] - 1;
	}
	for(int j = 0; j < nc; j++){
		if (matrix[j][j] == -1) {
			//noyau = append(noyau,M[0..nc-1,j]);
			for (int tmp = 0; tmp < nc; tmp++) {
				noyau[tmp] = matrix[tmp][j];
			}
		}
	}
	return noyau;
}*/

/*int *gaussjordan_noyau(int *matrix, int size) {
	int pivo,j,temp,a,k,l;
	int nl = size;
	int nc = size;
	//on met des 0 sous la diagonale
	int jc = 0;
	int jl = 0;
	// on traite toutes les colonnes
	while (jc < nc && jl < nl) {
		//choix du pivot que l'on veut mettre en M[jl,jc]
		k = jl;
		while (matrix[k * size + jc] == 0 && k < nl-1) {
			k = k+1;
		}
		//on ne fait la suite que si on a pivo!=0
		if (matrix[k * size + jc] != 0) {
			pivo = matrix[k * size + jc];
			//echange de la ligne jl et de la ligne k
			for (l = jc; l < nc; l++){
				temp = matrix[jl * size + l];
				matrix[jl * size + l] = matrix[k * size + l];
				matrix[k * size + l] = temp;
			}
			//fin du choix du pivot qui est M[jl,jc]
			//on met 1 sur la diagonale de la colonne jc
			for (l = 0; l < nc; l++) {
				matrix[jl * size + l] = matrix[jl * size + l] / pivo;
			}
			//on met des 0 au dessus de la diagonale
			// de la colonne jc
			for (k = 0; k < jl; k++) {
				a = matrix[k * size + jc];
				for (l = 0; l < nc; l++) {
					matrix[k * size + l] = matrix[k * size + l] - matrix[jl * size + l] * a;
				}
			}
			//on met des 0 sous la diag de la colonne jc
			for (k = jl+1; k < nl; k++) {
				a = matrix[k * size + jc];
				for (l = jc; l < nc; l++) {
					matrix[k * size + l] = matrix[k * size + l] - matrix[jl * size + l] * a;
				}
			}
		} else {
			//on ajoute une ligne de 0 si ce n'est pas le dernier 0
			if (jl < nc-1) {
				for (j = nl; j > jl; j--) {
					//matrix[j] = matrix[j-1];
					for (int tmp = 0; tmp < size; tmp++) {
						matrix[j * size + tmp] = matrix[(j-1) * size + tmp];
					}
				}
				//M[jl] = makelist(0,1,nc);
				for (int tmp = 0; tmp < size; tmp++) {
					matrix[jl * size + tmp] = 0;
				}
				nl = nl + 1;
			}
		}
		//ds tous les cas,le numero de colonne et
		//le numero de ligne augmente de 1
		jc = jc + 1;
		jl = jl + 1;
		//il faut faire toutes les colonnes
		if (jl == nl && jl < nc) {
			//matrix[nl] = makelist(0,1,nc);
			for (int tmp = 0; tmp < size; tmp++) {
				matrix[nl * size + tmp] = 0;
			}
			nl = nl + 1;
		}
	}
	int *noyau = (int *) malloc(size * sizeof(int));
	//on enleve les lignes en trop pour avoir
	//une matrice carree de dim nc
	//on retranche la matrice identite
	//matrix = matrix[0..nc-1] - idn(nc);
	for (int tmp = 0; tmp < nc; tmp++) {
		matrix[tmp * size + tmp] = matrix[tmp * size + tmp] - 1;
	}
	for(int j = 0; j < nc; j++){
		if (matrix[j * size + j] == -1) {
			//noyau = append(noyau,M[0..nc-1,j]);
			for (int tmp = 0; tmp < nc; tmp++) {
				noyau[tmp] = matrix[tmp * size + j];
			}
		}
	}
	return noyau;
}


void test() {
	int *matrix = (int *) malloc(16 * sizeof(int));
	for (int i = 0; i < 16; i++) {
		matrix[i] = 1;
	}
	matrix[0 * 4 + 1] = 0;
	matrix[1 * 4 + 2] = 0;
	matrix[2 * 4 + 0] = 0;
	matrix[2 * 4 + 2] = 0;
	int *k = gaussjordan_noyau(matrix, 4);
	for (int i = 0; i < 4; i++) {
		//printf("%d\n", k[i]);
	}
}*/


//Avec des matrix2D
Vector_List *gaussjordan_noyau(int **matrix, int size) {
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
			//for (l = jc; l < nc; l++) {
			swapLineMatrix2D(tmpMat, jl, k);
			//}
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
		}
		else{
			//on ajoute une ligne de 0 si ce n'est pas le dernier 0
			if (jl<nc-1){
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
	//M:=M[0..nc-1]-idn(nc);
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
	free(tmpMat);
	return listNoyau;
}


/*Vector_List *gaussjordan_noyau(int *matrix, int size) {
	int pivo,jc,jl,k,j,nl,nc,l,a;
	matrix1D Mat;
	Mat.mat = matrix;
	Mat.colsNb = size;
	Mat.rowsNb = size;
	matrix1D *tmpMat = copyMatrix1D(Mat);
	nl = tmpMat->rowsNb;
	nc = tmpMat->colsNb;
	//on met des 0 sous la diagonale
	jc = 0;
	jl = 0;
	// on traite toutes les colonnes
	while (jc < nc and jl < nl) {
		//choix du pivot que l'on veut mettre en M[jl,jc]
		k = jl;
		while (tmpMat->mat[k * nc + jc] == 0 and k < nl-1) {
			k = k + 1;
		}
		//on ne fait la suite que si on a pivo!=0
		if (tmpMat->mat[k * nc + jc] != 0) {
			pivo = tmpMat->mat[k * nc + jc];
			//echange de la ligne jl et de la ligne k
			//for (l = jc; l < nc; l++) {
			swapLineMatrix1D(tmpMat, jl, k);
			//}
			//fin du choix du pivot qui est M[jl,jc]
			//on met 1 sur la diagonale de la colonne jc
			for (l = 0; l < nc; l++) {
				tmpMat->mat[jl * nc + l] = tmpMat->mat[jl * nc + l] / pivo;
			}
			//on met des 0 au dessus de la diagonale
			// de la colonne jc
			for (k = 0; k < jl; k++) {
				a = tmpMat->mat[k * nc + jc];
				for (l = 0; l < nc; l++) {
					tmpMat->mat[k * nc + l] = tmpMat->mat[k * nc + l] - tmpMat->mat[jl * nc + l] * a;
				}
			}
			//on met des 0 sous la diag de la colonne jc
			for (k = jl + 1; k < nl; k++) {
				a = tmpMat->mat[k * nc + jc];
				for (l = jc; l < nc; l++) {
					tmpMat->mat[k * nc + l] = tmpMat->mat[k * nc + l] - tmpMat->mat[jl * nc + l] * a;
				}
			}
		}
		else{
			//on ajoute une ligne de 0 si ce n'est pas le dernier 0
			if (jl<nc-1){
				tmpMat = addLineToMatrix1D(tmpMat, 0, jl);
				nl = nl + 1;
			}
		}
		//ds tous les cas,le numero de colonne et
		//le numero de ligne augmente de 1
		jc = jc + 1;
		jl = jl + 1;
		//il faut faire toutes les colonnes
		if (jl == nl and jl < nc) {
			tmpMat = addLineToMatrix1D(tmpMat, 0, nl);
			nl++;
		}
	}
	int *noyau;
	Vector_List *listNoyau = createVectorList();
	//on enleve les lignes en trop pour avoir
	//une matrice carree de dim nc
	//on retranche la matrice identite
	//M:=M[0..nc-1]-idn(nc);
	for (int tmp = 0; tmp < nc; tmp++) {
		tmpMat->mat[tmp * nc + tmp] = tmpMat->mat[tmp * nc + tmp] - 1;
	}
	for(j = 0; j < nc; j++) {
		noyau = (int *) malloc(tmpMat->rowsNb * sizeof(int));
		if (tmpMat->mat[j * nc + j] == -1) {
			for (int i = 0; i < nc; i++) {
				noyau[i] = tmpMat->mat[i * nc + j];
			}
			addVector(listNoyau, noyau, tmpMat->rowsNb);
		}
		free(noyau);
	}
	free(tmpMat);
	return listNoyau;
}*/
