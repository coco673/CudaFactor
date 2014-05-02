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

#define MAX_FACTORS_PER_BLOCK 20
#define NB_BLOCKS 65535
#define MAX_TEMPORARILY_FACTORS NB_BLOCKS * MAX_FACTORS_PER_BLOCK

__device__ __constant__ int devPremList[10000];

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
	return res;
}

Int_List_GPU *dixon(int n) {
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
}

__host__ __device__ int **matrix1DTo2D(int *matrix, int size) {
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

Int_List_GPU *mergeDiv(Int_List_GPU *src1, Int_List_GPU *src2) {
	Int_List_GPU *result = createIntList();
	for (int i = 0; i < src1->Size; i++) {
		addInt(&result, src1->List[i]);
	}
	for (int i = 0; i < src2->Size; i++) {
		addInt(&result, src2->List[i]);
	}
	return result;
}

Int_List_GPU *factor(uint64_t n) {
	int borne = ceil(sqrt(exp(sqrt(2 * log(n) * log(log(n))))));
	int sizePL;
	int *premList = generatePrimeList(borne, &sizePL);
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
		//tmpDiv = dixonGPU(nbr, n, premList, sizePL, ptr);
		tmpDiv = dixonDevice(nbr, n, premList, sizePL, ptr);
		return mergeDiv(tmpDiv, mergeDiv(Div, tmpDiv));
	}
	if (Miller(nbr, 10)) {
		addInt(&Div, nbr);
		return Div;
	}
	//tmpDiv = dixonGPU(nbr, n, premList, sizePL, ptr);
	tmpDiv = dixonDevice(nbr, n, premList, sizePL, ptr);
	return mergeDiv(Div, tmpDiv);
}

/*Int_List_GPU *dixonGPU(uint64_t nbr, uint64_t n, int *premList, int sizePL, int *ptr) {
	Couple_List *R = createCoupleList();
	int * sizeR = (int *) malloc(sizeof(int));
	Int_List_GPU *Div = createIntList();
	Couple *tmpC = (Couple *) malloc(sizePL * sizeof(Couple));
	int **matrix;
	int **matrixMod;
	int *noyau;
	int u, v;
	Vector_List *listNoyau;
	VEC_ELEM *tmp;

	curandState_t *dev_state;
	Couple *dev_R;
	int *dev_sizeR;
	uint64_t *dev_Div;
	int *dev_sizeDiv;
	uint64_t *dev_rand;
	int *dev_matrix;
	int *dev_matrixMod;
	int *tmpmatrix = (int*) malloc(sizePL*sizePL * sizeof(int));
	int *tmpmatrixMod= (int*) malloc(sizePL*sizePL * sizeof(int));


	//Allocations
	matrixMod = (int **) malloc(sizePL * sizeof(int *));

	for (int i  = 0; i < sizePL; i++) {
		matrixMod[i] = (int *) malloc(sizePL * sizeof(int));
	}
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_state,sizePL*sizeof(curandState_t)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_R,sizePL*sizeof(Couple)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_sizeR,sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_sizeDiv,sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_rand,sizePL*sizeof(int)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_matrix,sizePL*sizePL*sizeof(int*)));
	CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_matrixMod,sizePL*sizePL*sizeof(int)));

	while (produitDiv(*Div) != nbr) {
		CUDA_CHECK_RETURN(cudaMalloc((void **)&dev_Div,Div->Size*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_state,0,sizePL*sizeof(curandState_t)));
		CUDA_CHECK_RETURN(cudaMemset(dev_R,0,sizePL*sizeof(Couple)));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeR,0,sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeDiv,0,sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_rand,0,sizePL*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrix,0,sizePL*sizePL*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrixMod,0,sizePL*sizePL*sizeof(int)));

		CUDA_CHECK_RETURN(cudaMemcpy(dev_Div,Div->List,Div->Size*sizeof(int),cudaMemcpyHostToDevice));

		Generation<<<1,sizePL>>>(dev_state,nbr,(uint64_t)sqrtf(nbr),dev_rand);
		fillEnsR<<<1,sizePL>>>(dev_state,dev_R,dev_sizeR,dev_Div,Div->Size,ptr, sizePL,dev_rand,nbr,dev_matrix);
		CUDA_CHECK_RETURN(cudaMemcpy(sizeR,dev_sizeR,sizeof(int),cudaMemcpyDeviceToHost));

		CUDA_CHECK_RETURN(cudaMemcpy(tmpC,dev_R, *sizeR * sizeof(Couple),cudaMemcpyDeviceToHost));

		CUDA_CHECK_RETURN(cudaMemcpy(tmpmatrix,dev_matrix, sizePL*sizePL*sizeof(int),cudaMemcpyDeviceToHost));

		matrix = matrix1DTo2D(tmpmatrix,sizePL);
		cudaDeviceSynchronize();

		for (int i = 0; i < *sizeR; i++) {
			for (int j = 0; j < sizePL; j++) {
				matrixMod[i][j] = matrix[i][j] % 2;
			}
			addCouple(R,tmpC[i]);
		}
		listNoyau = gaussjordan_noyau(matrixMod, sizePL);

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

		for (int i = 0; i < sizePL; i++) {
			free(matrix[i]);
		}

		free(matrix);
		free(listNoyau);
		CUDA_CHECK_RETURN(cudaFree(dev_Div));
		resetCoupleList(R);
	}
	for (int i = 0; i < sizePL; i++) {
		free(matrixMod[i]);
	}

	CUDA_CHECK_RETURN(cudaFree(dev_state));
	CUDA_CHECK_RETURN(cudaFree(dev_R));
	CUDA_CHECK_RETURN(cudaFree(dev_sizeR));
	CUDA_CHECK_RETURN(cudaFree(dev_rand));

	CUDA_CHECK_RETURN(cudaFree(dev_matrix));
	CUDA_CHECK_RETURN(cudaFree(dev_matrixMod));
	free(matrixMod);
	free(R);
	free(premList);

	return Div;
}*/


/*__global__ void finDixon(int *matrix, int sizePL, ) {
	//Calcul de la matrice modulo
	//possible avec 1 block et (sizePL, sizePL) threads
	int **matMod = (int **) malloc(sizePL * sizeof(int *));
	for (int i = 0; i < sizePL; i++) {
		matMod[i] = (int *) malloc(sizePL * sizeof(int));
		matMod[i] = 0;
	}
	for (int i = 0; i < sizePL; i++) {
		for (int j = 0; j < sizePL; j++) {
			matMod[i][j] = matrix[i * sizePL + j] % 2;
		}
	}

	//Gauss Jordan 1 block et 1 thread
	listeNoyau = gaussjordan_noyau(matMod, sizePL);

}*/

__device__ int **BinaryMatrix(int *matrix, int size) {
	__shared__ int **matMod;
	if (threadIdx.x == 0 && threadIdx.y == 0) {
		matMod = (int **) malloc(size * sizeof(int *));
	}
	__syncthreads();
	if (threadIdx.x < size && threadIdx.y < size) {
		if (threadIdx.y == 0) {
			matMod[threadIdx.x] = (int *) malloc(size * sizeof(int));
		}
		__syncthreads();
		matMod[threadIdx.x][threadIdx.y] = matrix[threadIdx.x * size + threadIdx.y] % 2;
	}
	__syncthreads();
	return matMod;
}

__device__ Vector_List *gaussjordan_noyau_GPU(int **matrix, int size) {
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

__device__ void calculateUV(Couple *R, int *premList, int sizePL, int **matrix, int *noyau, int n, int *u, int *v) {
	if (threadIdx.x == 0) {
		int res = 1;
		for (int i = 0; i < sizePL; i++) {
			if (noyau[i] == 1) {
				res = (res * (R[i].x * R[i].x)) %n;
			}
		}
		*u = res;
	} else if (threadIdx.x == 1) {
		int res = 1;
		int somme;
		for (int i = 0; i < sizePL; i++) {
			somme = 0;
			for (int j = 1; j < sizePL; j++) {
				if (noyau[j] == 1)
					somme += matrix[j][i] * noyau[j];
			}
			somme = floor((double) somme / 2);
			res *= (int)(pow((double) premList[i], somme));
			res %= n;
		}
		*v = res;
	}
	__syncthreads();
}

__global__ void dixonParrallele(uint64_t *Div, int sizeDiv, uint64_t *newDiv, int *sizeNewDiv, int *ptr, int sizePL, uint64_t nbr) {
	__shared__ curandState_t *dev_state;
	__shared__ uint64_t *dev_rand;
	__shared__ Couple *dev_R;
	__shared__ int *dev_sizeR;
	__shared__ int *dev_matrix;
	__shared__ int indexCurrentBlock;
	__shared__ int u;
	__shared__ int v;
	__shared__ Vector_List *listNoyau;
	__shared__ int *noyau;
	__shared__ VEC_ELEM *tmp;
	if (threadIdx.x == 0 && threadIdx.y == 0) {
		dev_state = (curandState_t *) malloc(sizePL*sizeof(curandState_t));
		dev_rand = (uint64_t *) malloc(sizePL*sizeof(int));
		dev_R = (Couple *) malloc(sizePL*sizeof(Couple));
		dev_sizeR = (int *) malloc(sizeof(int));
		dev_matrix = (int *) malloc(sizePL * sizePL * sizeof(int));
		indexCurrentBlock = 0;
		sizeNewDiv[blockIdx.x] = 0;
	}
	__syncthreads();
	if (threadIdx.x < sizePL && threadIdx.y == 0) {
		Generation(dev_state,nbr,(uint64_t)sqrtf(nbr),dev_rand);
		fillEnsR(dev_state,dev_R,dev_sizeR,Div,sizeDiv,ptr, sizePL,dev_rand,nbr,dev_matrix);
	}
	__syncthreads();
	int **matMod;
	int **mat;
	if (threadIdx.x < sizePL && threadIdx.y < sizePL) {
		matMod = BinaryMatrix(dev_matrix, sizePL);
	}
	__syncthreads();
	if (threadIdx.x == 0 && threadIdx.y == 0) {
		listNoyau = gaussjordan_noyau_GPU(matMod, sizePL);
		mat = matrix1DTo2D(dev_matrix, sizePL);
	}
	__syncthreads();
	if ((threadIdx.x == 0 || threadIdx.x == 1) && threadIdx.y == 0) {
		while (listNoyau != NULL) {
			noyau = listNoyau->list->vec;
			calculateUV(dev_R, ptr, sizePL, mat, noyau, nbr, &u, &v);
			__syncthreads();
			if (threadIdx.x == 0) {

				uint64_t pgcd1 = pgcdUint(u - v, nbr);
				uint64_t pgcd2 = pgcdUint(u + v, nbr);

				if ((pgcd1 != 1) && (pgcd1 != nbr)) {
					//addInt(&Div[blockIdx.x], pgcd1);
					if (indexCurrentBlock < MAX_FACTORS_PER_BLOCK) {
						newDiv[indexCurrentBlock * blockIdx.x] = pgcd1;
						indexCurrentBlock++;
						atomicAdd(&sizeNewDiv[blockIdx.x], 1);
						nbr /= pgcd1;
						while (nbr % pgcd1 == 0) {
							//addInt(&Div[blockIdx.x], pgcd1);
							if (indexCurrentBlock < MAX_FACTORS_PER_BLOCK) {
								newDiv[indexCurrentBlock * blockIdx.x] = pgcd1;
								indexCurrentBlock++;
								atomicAdd(&sizeNewDiv[blockIdx.x], 1);
								nbr /= pgcd1;
							}
						}
					}
				} else if ((pgcd2 != 1) && (pgcd2 != nbr)) {
					//addInt(&Div[blockIdx.x], pgcd2);
					if (indexCurrentBlock < MAX_FACTORS_PER_BLOCK) {
						newDiv[indexCurrentBlock * blockIdx.x] = pgcd2;
						indexCurrentBlock++;
						atomicAdd(&sizeNewDiv[blockIdx.x], 1);
						nbr /= pgcd2;
						while (nbr % pgcd2 == 0) {
							//addInt(&Div[blockIdx.x], pgcd2);
							if (indexCurrentBlock < MAX_FACTORS_PER_BLOCK) {
								newDiv[indexCurrentBlock * blockIdx.x] = pgcd2;
								indexCurrentBlock++;
								atomicAdd(&sizeNewDiv[blockIdx.x], 1);
								nbr /= pgcd2;
							}
						}
					}
				}
				/*if (Miller(nbr, 10)) {
					addInt(&Div[blockIdx.x], nbr);
					//return Div;
				}*/
				tmp = listNoyau->list;

				listNoyau->list = listNoyau->list->suiv;
				free(tmp);
				free(noyau);
			}
		}
	}
	__syncthreads();
}

bool isIn(uint64_t *list, uint64_t elem, int size) {
	for (int i = 0; i < size; i++) {
		if (list[i] == elem) {
			return true;
		}
	}
	return false;
}

Int_List_GPU *dixonDevice(uint64_t nbr, uint64_t n, int *premList, int sizePL, int *ptr) {
	//Declarations
	Int_List_GPU *Div = createIntList(), *tmp = createIntList();
	uint64_t *tmpDiv = (uint64_t *) malloc(NB_BLOCKS * MAX_FACTORS_PER_BLOCK * sizeof(uint64_t));
	int *sizeTmpDiv = (int *) malloc(NB_BLOCKS * sizeof(int));
	dim3 threads;
	threads.x = sizePL;
	threads.y = sizePL;

	//Copies GPU
	uint64_t *dev_currentDiv;
	uint64_t *dev_nextDiv;
	int *sizeNextDiv;
	cudaMalloc((int **) &dev_currentDiv, Div->Size * sizeof(int));
	cudaMalloc((int **) &dev_nextDiv, NB_BLOCKS * MAX_FACTORS_PER_BLOCK * sizeof(int));
	cudaMalloc((int **) &sizeNextDiv, NB_BLOCKS * sizeof(int));

	while (produitDiv(*Div) != nbr) {
		dixonParrallele<<<NB_BLOCKS, threads>>>(dev_currentDiv, Div->Size, dev_nextDiv, sizeNextDiv, ptr, sizePL, nbr);
		for (int i = 0; i < NB_BLOCKS; i++) {
			for (int j = 0; j < sizeTmpDiv[i]; j++) {
				if (!isIn(tmp->List, tmpDiv[i * MAX_FACTORS_PER_BLOCK + j], tmp->Size)) {
					addInt(&tmp, tmpDiv[i * MAX_FACTORS_PER_BLOCK + j]);
				}
			}
		}
		Div = mergeDiv(Div, tmp);
	}

	return Div;
}
