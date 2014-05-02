#include "header/dixon.h"
#include <unistd.h>
#include "header/fillEns.h"
#include <assert.h>

#define CUDA_CHECK_RETURN(value) {											\
		cudaError_t _m_cudaStat = value;										\
		if (_m_cudaStat != cudaSuccess) {										\
			fprintf(stderr, "Error %s at line %d in file %s\n",					\
					cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
					exit(1);															\
		} }

__device__ __constant__ int devPremList[10000];


int adjust_bl(int value){
	if(value < 32){
		return 1;
	}
	return(ceil(value/NB_TH_PER_BLOCK)+1);
}

int adjust_th( int value){
	if(value < NB_TH_PER_BLOCK){
		return value;
	}
	return NB_TH_PER_BLOCK;
}
uint64_t alea(uint64_t a, uint64_t b) {
	return rand()%(b-a) +a;
}

uint64_t produitDiv(Int_List_GPU Div) {
	uint64_t res = 1;
	for (int i = 0; i < Div.Size; i++) {
		res *= getVal(Div, i);
	}
	return res;
}

int notIn(Int_List_GPU Div, uint64_t val) {
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

int calcul_v(int *premList, int sizePL, Couple_List R, char **matrix, int *noyau, int n) {
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
	return res;
}

/*Int_List_GPU *dixon(int n) {
	//timer


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
			uint64_t x = alea(sqrt(nbr), nbr + 1);
			uint64_t y = ((uint64_t)pow(x, 2)) % nbr;

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

	//timer


	return Div;
}*/

char **matrix1DTo2D(char *matrix, int size) {
	char **mat = new char*[size];
	for(int i = 0;i< size ; i++){
		mat[i] = new char[size];
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

Int_List_GPU *mergeDiv(Int_List_GPU *src1, Int_List_GPU *src2) {
	Int_List_GPU *result = createIntList();
	for (int i = 0; i < src1->Size; i++) {
		addInt(&result, src1->List[i]);
	}
	for (int i = 0; i < src2->Size; i++) {
		addInt(&result, src2->List[i]);
	}
	delete[](src1);
	delete[](src2);
	return result;
}

Int_List_GPU *factor(uint64_t n) {
	int borne = ceil(sqrt(exp(sqrt(2 * log(n) * log(log(n))))));
	int sizePL;
	int *premList = generatePrimeList(borne, &sizePL);
	printf("size pl = %i\n",sizePL);
	CUDA_CHECK_RETURN(cudaMemcpyToSymbol(devPremList, premList, sizePL * sizeof(int), 0, cudaMemcpyHostToDevice));
	int *ptr;
	cudaGetSymbolAddress((void **)&ptr, devPremList);
	Int_List_GPU *Div = createIntList();
	uint64_t nbr = n;
	int index = 0;
	while(index < sizePL) {
		if (nbr % premList[index] == 0) {
			addInt(&Div, premList[index]);
			nbr /= premList[index];
		} else {
			index++;
		}
	}
	if (nbr == 1) {
		return Div;
	}
	Int_List_GPU *tmpDiv;
	float racine = sqrt(nbr);
	if (ceil(racine) == racine) {
		if (Miller((int) racine, 10)) {
			addInt(&Div, (int) racine);
			addInt(&Div, (int) racine);
			return Div;
		}
		tmpDiv = dixonGPU(nbr, n, premList, sizePL, ptr);
		return mergeDiv(tmpDiv, mergeDiv(Div, tmpDiv));
	}
	if (Miller(nbr, 10)) {
		addInt(&Div, nbr);
		return Div;
	}
	tmpDiv = dixonGPU(nbr, n, premList, sizePL, ptr);
	free(premList);
	return mergeDiv(Div, tmpDiv);
}

Int_List_GPU *dixonGPU(uint64_t nbr, uint64_t n, int *premList, int sizePL, int *ptr) {
	Couple_List *R = createCoupleList();
	//int * sizeR = (int *) malloc(sizeof(int));
	int sizeR = 0;
	Int_List_GPU *Div = createIntList();
	Couple *tmpC = NULL;
	char **matrix = NULL;
	char **matrixMod= NULL;
	int *noyau=NULL;
	int u, v;
	Vector_List *listNoyau = NULL;
	VEC_ELEM *tmp=NULL;

	curandState_t *dev_state= NULL;
	Couple *dev_R=NULL;
	int *dev_sizeR=NULL;
	uint64_t *dev_Div=NULL;
	int *dev_sizeDiv=NULL;
	uint64_t *dev_rand=NULL;
	char *dev_matrix=NULL;
	char *dev_matrixMod=NULL;
	char *tmpmatrix=NULL;


	//Allocations

	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_state,(sizePL+32)*sizeof(curandState_t)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_R,(sizePL+32)*sizeof(Couple)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_sizeR,sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_sizeDiv,sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_rand,(sizePL+32)*sizeof(uint64_t)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_matrix,(sizePL+32)*(sizePL+32)*sizeof(char)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_matrixMod,(sizePL+32)*(sizePL+32)*sizeof(char)));

	printf("entree dans Dixon\n");
	while (produitDiv(*Div) != nbr) {
		matrixMod = (char **) malloc(sizePL * sizeof(char *));

		for (int i  = 0; i < sizePL; i++) {
			matrixMod[i] = (char *) malloc(sizePL * sizeof(char));
		}
		tmpC = (Couple *) malloc(sizePL * sizeof(Couple));
		tmpmatrix = (char*) malloc((sizePL+32)*(sizePL+32) * sizeof(char));
		CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_Div,Div->Size*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_state,0,(sizePL+32)*sizeof(curandState_t)));
		CUDA_CHECK_RETURN(cudaMemset(dev_R,0,(sizePL+32)*sizeof(Couple)));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeR,0,sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeDiv,0,sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_rand,0,(sizePL+32)*sizeof(uint64_t)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrix,0,(sizePL+32)*(sizePL+32)*sizeof(char)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrixMod,0,(sizePL+32)*(sizePL+32)*sizeof(char)));

		CUDA_CHECK_RETURN(cudaMemcpy(dev_Div,Div->List,Div->Size*sizeof(int),cudaMemcpyHostToDevice));
		Generation<<<adjust_bl(sizePL),adjust_th(sizePL)>>>(dev_state,nbr,(uint64_t)sqrtf(nbr),dev_rand);
		fillEnsR<<<adjust_bl(sizePL),adjust_th(sizePL)>>>(dev_state,dev_R,dev_sizeR,dev_Div,Div->Size,ptr, sizePL,dev_rand,nbr,dev_matrix);


		CUDA_CHECK_RETURN(cudaMemcpy(&sizeR,dev_sizeR,sizeof(int),cudaMemcpyDeviceToHost));
		int tp = sizeR - sizePL;
		sizeR -= tp;
		CUDA_CHECK_RETURN(cudaMemcpy(tmpC,dev_R, sizeR * sizeof(Couple),cudaMemcpyDeviceToHost));

		CUDA_CHECK_RETURN(cudaMemcpy(tmpmatrix,dev_matrix, sizePL*sizePL*sizeof(char),cudaMemcpyDeviceToHost));
		matrix = matrix1DTo2D(tmpmatrix,sizePL);
		for (int i = 0; i < sizeR; i++) {
			for (int j = 0; j < sizePL; j++) {
				matrixMod[i][j] = matrix[i][j] % 2;
			}
			addCouple(R,tmpC[i]);
		}
		free(tmpmatrix);
		free(tmpC);
		listNoyau = gaussjordan_noyau(matrixMod, sizePL);
		for (int i = 0; i < sizePL; i++) {
					free(matrixMod[i]);
				}
				free(matrixMod);

				while (listNoyau->list != NULL) {
			noyau = listNoyau->list->vec;

			u = (calcul_u(*R, noyau, n));

			v = (calcul_v(premList, sizePL, *R, matrix, noyau,n));

			uint64_t pgcd1 = pgcdUint(u - v, nbr);
			uint64_t pgcd2 = pgcdUint(u + v, nbr);

			if ((pgcd1 != 1) && (pgcd1 != nbr)) {
				addInt(&Div, pgcd1);
				nbr /= pgcd1;
				while (nbr % pgcd1 == 0) {
					addInt(&Div, pgcd1);
					nbr /= pgcd1;
				}
			} else if ((pgcd2 != 1) && (pgcd2 != nbr)) {
				addInt(&Div, pgcd2);
				nbr /= pgcd2;
				while (nbr % pgcd2 == 0) {
					addInt(&Div, pgcd2);
					nbr /= pgcd2;
				}
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


		delete[](matrix);
		free(listNoyau);
		CUDA_CHECK_RETURN(cudaFree(dev_Div));
		resetCoupleList(R);
		printf("c est pas fini\n");
	}


	CUDA_CHECK_RETURN(cudaFree(dev_state));
	CUDA_CHECK_RETURN(cudaFree(dev_R));
	CUDA_CHECK_RETURN(cudaFree(dev_sizeR));
	CUDA_CHECK_RETURN(cudaFree(dev_rand));

	CUDA_CHECK_RETURN(cudaFree(dev_matrix));
	CUDA_CHECK_RETURN(cudaFree(dev_matrixMod));

	free(R);
	//free(sizeR);
	free(premList);

	return Div;
}
