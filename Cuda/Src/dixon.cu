#include "dixon.h"
#include <unistd.h>
#include "fillEns.h"

int alea(int a, int b) {
	return rand()%(b-a) +a;
}

int produitDiv(Int_List Div) {
	int res = 1;
	for (int i = 0; i < Div.size; i++) {
		res *= getVal(Div, i);
	}
	return res;
}

int notIn(Int_List Div, int val) {
	for (int i = 0; i < Div.size; i++) {
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
	int somme = 0;
	for (int i = 0; i < sizePL; i++) {
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

Int_List *dixon(int n) {
	//Declarations

	//int borne = sqrt(exp(sqrt(log(n)*log(log(n)))));
	int borne = ceil(sqrt(exp(sqrt(2 * log(n) * log(log(n))))));
	int sizePL;
	int *premList = generatePrimeList(borne, &sizePL);
	Couple_List *R = createCoupleList();

	Int_List *Div = createIntList();
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
			addInt(Div, premList[index]);
			nbr /= premList[index];
		} else {
			index++;
		}
	}
	if (Miller(nbr, 10)) {
		addInt(Div, nbr);
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
				addInt(Div, pgcdUint(u - v, nbr));
				nbr /= pgcdUint(u - v, nbr);
			} else if ((pgcdUint(u + v, nbr) != 1) && (pgcdUint(u + v, nbr) != nbr)) {
				addInt(Div, pgcdUint(u + v, nbr));
				nbr /= pgcdUint(u + v, nbr);
			}
			if (Miller(nbr, 10)) {
				addInt(Div, nbr);
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

Int_List *dixon2(int n) {
	//Declarations

	int borne = ceil(sqrt(exp(sqrt(2 * log(n) * log(log(n))))));
	int sizePL;
	int *premList = generatePrimeList(borne, &sizePL);
	Couple_List *R = createCoupleList();
	Couple *dev_R;
	Couple *Rtmp= (Couple*)malloc(sizePL*sizeof(Couple));
	Int_List *Div = createIntList();
	Int_List * dev_Div;
	Couple tmpC;
	int **matrix;
	int **matrixMod;
	int *noyau;
	int u, v;
	int nbr = n;
	int *rand;
	int *dev_sizeR;
	int *dev_sizeDiv;
	int *dev_matrix[sizePL];
	int *dev_rand;
	Vector_List *listNoyau;
	VEC_ELEM *tmp;
	curandState_t *dev_state;
	int * dev_premList;
	int sqrtNBR = (int) sqrt(n);
	cudaMalloc(&dev_premList,sizePL*sizeof(int));
	cudaMalloc(&dev_state,sizePL*sizeof(int));
	cudaMalloc(&dev_R,sizePL*sizeof(Couple));
	cudaMalloc(&dev_Div,Div->size*sizeof(Int_List));
	cudaMalloc(&dev_sizeR,sizeof(int));
	cudaMalloc(&dev_sizeDiv,sizeof(int));
	cudaMalloc(&dev_rand,sizePL*sizeof(int));

	//Allocations

	matrixMod = (int **) malloc(sizePL * sizeof(int *));
	for (int i  = 0; i < sizePL; i++) {
		matrixMod[i] = (int *) malloc(sizePL * sizeof(int));
		cudaMalloc(&dev_matrix[i],sizePL*sizeof(int*));
	}

	while (produitDiv(*Div) != nbr) {
		cudaMemcpy(dev_Div,Div,Div->size*sizeof(Int_List),cudaMemcpyHostToDevice);
		cudaMemcpy(dev_sizeDiv,&(Div->size),sizeof(int),cudaMemcpyHostToDevice);
		Generation<<<1,sizePL>>>(dev_state,n+1,sqrtNBR,dev_rand);
		fillEnsR<<<1,sizePL>>>(dev_state,dev_R,dev_sizeR,dev_Div,dev_sizeDiv,dev_premList,sizePL,dev_rand,nbr,dev_matrix);
		cudaMemcpy(&(R->size),dev_sizeR,sizeof(int),cudaMemcpyDeviceToHost);
		cudaMemcpy(Rtmp,dev_R,R->size * sizeof(int),cudaMemcpyDeviceToHost);


		cudaMemset(dev_state,0,sizePL*sizeof(curandState_t));
		cudaMemset(dev_rand,0,sizePL*sizeof(int));
		cudaMemset(dev_sizeDiv,0,sizeof(int));
		cudaMemset(dev_Div,0,Div->size*sizeof(Int_List));
		cudaDeviceSynchronize();

		for(int i = 0; i< R->size;i++){
			addCouple(R,Rtmp[i]);
			cudaMemcpy(matrix[i],dev_matrix[i],R->size * sizeof(int *),cudaMemcpyDeviceToHost);

		}
		cudaDeviceSynchronize();

			listNoyau = gaussjordan_noyau(matrixMod, sizePL);

		while (listNoyau->list != NULL) {
			noyau = listNoyau->list->vec;
			u = (calcul_u(*R, noyau, n));
			v = (calcul_v(premList, sizePL, *R, matrix, noyau,n));
			if ((pgcdUint(u - v, nbr) != 1) && (pgcdUint(u - v, nbr) != nbr)) {
				addInt(Div, pgcdUint(u - v, nbr));
				nbr /= pgcdUint(u - v, nbr);
				break;
			} else if ((pgcdUint(u + v, nbr) != 1) && (pgcdUint(u + v, nbr) != nbr)) {
				addInt(Div, pgcdUint(u + v, nbr));
				nbr /= pgcdUint(u + v, nbr);
				break;
			}
			if (Miller(nbr, 10)) {
				addInt(Div, nbr);
				return Div;
			}
			tmp = listNoyau->list;

			listNoyau->list = listNoyau->list->suiv;
			free(tmp);
		}
		for (int i = 0; i < sizePL; i++) {
			free(matrix[i]);
		}
		free(matrix);
		free(noyau);
		free(listNoyau);

		resetCoupleList(R);
	}
	cudaFree(dev_state);
	cudaFree(dev_rand);
	cudaFree(dev_sizeDiv);
	cudaFree(dev_Div);
	for (int i = 0; i < sizePL; i++) {
		free(matrixMod[i]);
	}
	free(matrixMod);
	free(R);
	free(premList);
	cudaFree(dev_premList);


	return Div;
}

