#include "dixon.h"
#include <unistd.h>
#include "fillEns.h"
#include <assert.h>
#define CUDA_CHECK_RETURN(value) {											\
	cudaError_t _m_cudaStat = value;										\
	if (_m_cudaStat != cudaSuccess) {										\
		fprintf(stderr, "Error %s at line %d in file %s\n",					\
				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
		exit(1);															\
	} }
int alea(int a, int b) {
	return rand()%(b-a) +a;
}

int produitDiv(Int_List_GPU Div) {
	int res = 1;
	for (int i = 0; i < Div.Size; i++) {
		res *= getVal(Div, i);
	}
	return res;
}

int notIn(Int_List_GPU Div, int val) {
	for (int i = 0; i < Div.Size; i++) {
		if (getVal(Div, i) == val) {
			return 1;
		}
	}
	return 0;
}

int calcul_u(Couple_List R, int *noyau, int n) {
	int res = 1;
	for (int i = 0; i < R.size; i++) {
		if (noyau[i] == 1) {
			res = (res * (getCouple(R, i).x * getCouple(R, i).x)) %n;
		}
	}
	return res;
}

int calcul_v(int *premList, int sizePL, Couple_List R, int **matrix, int *noyau, int n) {
	int res = 1;
	int somme;
	for (int i = 0; i < sizePL; i++) {
		somme = 0;
		for (int j = 1; j < R.size; j++) {
			if (noyau[j] == 1)
				somme += matrix[j][i] * noyau[j];
		} 
		somme = floor(somme / 2);
		res *= (int)(pow(premList[i], somme));
		res %= n;
	}
	printf("on va sortir la \n");
	return res;
}

Int_List_GPU *dixon(int n) {
	//Declarations

	//int borne = sqrt(exp(sqrt(log(n)*log(log(n)))));
	int borne = ceil(sqrt(exp(sqrt(2 * log(n) * log(log(n))))));
	int sizePL;
	int *premList = generatePrimeList(borne, &sizePL);
	Couple_List *R = createCoupleList();

	Int_List_GPU *Div = createIntList();
	Couple tmpC;
	int **matrix;
	int **matrixMod;
	int *noyau;
	int u, v;
	int nbr = n;
	Vector_List *listNoyau;
	VEC_ELEM *tmp;

	//Allocations
	matrixMod = (int **) malloc(sizePL * sizeof(int *));

	for (int i  = 0; i < sizePL; i++) {
		matrixMod[i] = (int *) malloc(sizePL * sizeof(int));
	}

	int index = 0;
	while(index < sizePL) {
		if (nbr % premList[index] == 0) {
			addInt(&Div, premList[index]);
			nbr /= premList[index];
		} else {
			index++;
		}
	}
	if (Miller(nbr, 10)) {
		addInt(&Div, nbr);
		return Div;
	}
	printf("entree dans Dixon\n");
	while (produitDiv(*Div) != nbr) {
		while (R->size < sizePL) {
			int x = alea(sqrt(nbr), nbr + 1);
			int y = ((int)pow(x, 2)) % nbr;

			if (isBSmoothG(premList, sizePL, y) && notIn(*Div, y) == 0) {
				tmpC.x = x;
				tmpC.y = y;
				addCouple(R, tmpC);
			}
		}
		matrix = fillMatrix(premList, sizePL, R);

		for (int i = 0; i < R->size; i++) {
			for (int j = 0; j < sizePL; j++) {
				matrixMod[i][j] = matrix[i][j] % 2;
			}
		}
		listNoyau = gaussjordan_noyau(matrixMod, sizePL);

		while (listNoyau->list != NULL) {
			noyau = listNoyau->list->vec;
			u = (calcul_u(*R, noyau, n));
			v = (calcul_v(premList, sizePL, *R, matrix, noyau,n));
			if ((pgcdUint(u - v, nbr) != 1) && (pgcdUint(u - v, nbr) != nbr)) {
				addInt(&Div, pgcdUint(u - v, nbr));
				nbr /= pgcdUint(u - v, nbr);
			} else if ((pgcdUint(u + v, nbr) != 1) && (pgcdUint(u + v, nbr) != nbr)) {
				addInt(&Div, pgcdUint(u + v, nbr));
				nbr /= pgcdUint(u + v, nbr);
			}
			if (Miller(nbr, 10)) {
				addInt(&Div, nbr);
				return Div;
			}
			tmp = listNoyau->list;

			listNoyau->list = listNoyau->list->suiv;
			free(tmp);
			free(noyau);

		}
		for (int i = 0; i < sizePL; i++) {
			free(matrix[i]);
		}
		free(matrix);
		free(listNoyau);

		resetCoupleList(R);
	}
	for (int i = 0; i < sizePL; i++) {
		free(matrixMod[i]);
	}
	free(matrixMod);
	free(R);
	free(premList);

	return Div;
}
int **matrix1DTo2D(int *matrix, int size) {
        int **mat = new int*[size];
        for(int i = 0;i< size ; i++){
        	mat[i] = new int[size];
        }
        int row = 0, col = 0;
        for (int i = 0; i < size * size; i++) {
                mat[row][col] = matrix[i];
                col = (col + 1) % size;
                if (col == 0) {
                        row++;
                }
        }
        return mat;
}

Int_List_GPU *dixon3(int n) {
	//Declarations

	//int borne = sqrt(exp(sqrt(log(n)*log(log(n)))));
	int borne = ceil(sqrt(exp(sqrt(2 * log(n) * log(log(n))))));
	int sizePL;
	int *premList = generatePrimeList(borne, &sizePL);
	Couple_List *R = createCoupleList();
	int * sizeR = (int *) malloc(sizeof(int));
	Int_List_GPU *Div = createIntList();
	Couple *tmpC = (Couple *) malloc(sizePL * sizeof(Couple));
	int **matrix;
	int **matrixMod;
	int *noyau;
	int u, v;
	int nbr = n;
	Vector_List *listNoyau;
	VEC_ELEM *tmp;

	curandState_t *dev_state;
	Couple *dev_R;
	int *dev_sizeR;
	int *dev_Div;
	int *dev_sizeDiv;
	int *dev_premList;
	int *dev_rand;
	int *dev_matrix;
	int *dev_matrixMod;
int *tmpmatrix = (int*) malloc(sizePL*sizePL * sizeof(int));
int *tmpmatrixMod= (int*) malloc(sizePL*sizePL * sizeof(int));


	//Allocations
	matrixMod = (int **) malloc(sizePL * sizeof(int *));

	for (int i  = 0; i < sizePL; i++) {
		matrixMod[i] = (int *) malloc(sizePL * sizeof(int));
	}

	int index = 0;
	while(index < sizePL) {
		if (nbr % premList[index] == 0) {
			addInt(&Div, premList[index]);
			nbr /= premList[index];
		} else {
			index++;
		}
	}
	if (Miller(nbr, 10)) {
		addInt(&Div, nbr);
		return Div;
	}
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_state,sizePL*sizeof(curandState_t)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_R,sizePL*sizeof(Couple)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_sizeR,sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_premList,sizePL*sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_sizeDiv,sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_rand,sizePL*sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_matrix,sizePL*sizePL*sizeof(int*)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_matrixMod,sizePL*sizePL*sizeof(int)));

		CUDA_CHECK_RETURN(cudaMemcpy(dev_premList,premList,sizePL*sizeof(int),cudaMemcpyHostToDevice));

	printf("entree dans Dixon\n");
	while (produitDiv(*Div) != nbr) {
		CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_Div,Div->Size*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_state,0,sizePL*sizeof(curandState_t)));
		CUDA_CHECK_RETURN(cudaMemset(dev_R,0,sizePL*sizeof(Couple)));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeR,0,sizeof(int)));
		//cudaMemset(dev_Div,0,Div->Size*sizeof(Int_List_GPU));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeDiv,0,sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_rand,0,sizePL*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrix,0,sizePL*sizePL*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrixMod,0,sizePL*sizePL*sizeof(int)));

		CUDA_CHECK_RETURN(cudaMemcpy(dev_Div,Div->List,Div->Size*sizeof(int),cudaMemcpyHostToDevice));

		Generation<<<1,sizePL>>>(dev_state,nbr,(int)sqrtf(nbr),dev_rand);

		fillEnsR<<<1,sizePL>>>(dev_state,dev_R,dev_sizeR,dev_Div,Div->Size,dev_premList,sizePL,dev_rand,nbr,dev_matrix);

		CUDA_CHECK_RETURN(cudaMemcpy(sizeR,dev_sizeR,sizeof(int),cudaMemcpyDeviceToHost));
		printf("la taille de R %i\n",*sizeR);
*sizeR=*sizeR-1;
		CUDA_CHECK_RETURN(cudaMemcpy(tmpC,dev_R, *sizeR * sizeof(Couple),cudaMemcpyDeviceToHost));
		CUDA_CHECK_RETURN(cudaMemcpy(tmpmatrix,dev_matrix, sizePL*sizePL*sizeof(int),cudaMemcpyDeviceToHost));

		matrix = matrix1DTo2D(tmpmatrix,sizePL);
		cudaDeviceSynchronize();

		for (int i = 0; i < *sizeR; i++) {
			for (int j = 0; j < sizePL; j++) {
				addCouple(R,tmpC[j]);
				matrixMod[i][j] = matrix[i][j] % 2;
			}
		}
		printf("on arrive à gauss\n");
		listNoyau = gaussjordan_noyau(matrixMod, sizePL);
printf("ok gauss\n");
int nbX= 0;
		while (listNoyau->list != NULL) {
			printf("valeur nbX %i\n",nbX);
			noyau = listNoyau->list->vec;
			printf("calcul de u\n");

			printf("*-------------------------------------------*\n");
			u = (calcul_u(*R, noyau, n));
			printf("good U\n");
printf("size PL %i\n",sizePL);
			for(int i = 0; i< sizePL ; i++){
				printf("%i:: %i \n",noyau[i],i);
			}
			v = (calcul_v(premList, sizePL, *R, matrix, noyau,n));

			printf("good V\n");
			if ((pgcdUint(u - v, nbr) != 1) && (pgcdUint(u - v, nbr) != nbr)) {
				addInt(&Div, pgcdUint(u - v, nbr));
				nbr /= pgcdUint(u - v, nbr);
			} else if ((pgcdUint(u + v, nbr) != 1) && (pgcdUint(u + v, nbr) != nbr)) {
				addInt(&Div, pgcdUint(u + v, nbr));
				nbr /= pgcdUint(u + v, nbr);
			}
			if (Miller(nbr, 10)) {
				addInt(&Div, nbr);
				return Div;
			}
			tmp = listNoyau->list;

			listNoyau->list = listNoyau->list->suiv;
			free(tmp);
			free(noyau);
nbX++;
		}
		for (int i = 0; i < sizePL; i++) {
			free(matrix[i]);
		}
		free(matrix);
		free(listNoyau);
		cudaFree(dev_Div);
		resetCoupleList(R);
	}
	for (int i = 0; i < sizePL; i++) {
		free(matrixMod[i]);
	}
	cudaFree(dev_state);
	cudaFree(dev_R);
	cudaFree(dev_sizeR);
	//cudaFree(dev_Div);
	cudaFree(dev_rand);

	cudaFree(dev_matrix);
	cudaFree(dev_matrixMod);
	free(matrixMod);
	free(R);
	free(premList);

	return Div;
}
