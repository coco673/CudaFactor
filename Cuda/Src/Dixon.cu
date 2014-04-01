#include "header/Dixon.h"


int produit(ensemble div, int sizeDiv) {
	int result = 1;
	if (sizeDiv == 0) {
		return 0;
	}

	for (int i = 0; i < sizeDiv; i++) {
		result *= div[i].ind.val;
	}
	return result;
}

ensemble Dixon(int n) {
	int borne = ceil(exp(sqrt(2 * log(n) * log(log(n)))));
	printf("borne = %i \n",borne);
	int cuda_result;
	int sizePrimeList;
	int *primeList = generatePrimeList(borne, &sizePrimeList);
	//sizePrimeList -= 1;
	printf("j'ai réussi a passer la fonction de merde de tim\n");
	for (int lol = 0 ; lol < sizePrimeList; lol++)printf("prime = %i",primeList[lol]);
	int sizeDiv = 0;
	int *matrix;
	int *dev_matrix;
	int *m;
	int *dev_m;
	int u, v;
	int sizeR;
	ensemble R;
	ensemble dev_R;
	ensemble div = (ensemble) malloc(sizeof(struct cell));

	//Allocation de la liste des premies sur le GPU
	int *dev_primeList;
	cuda_result = cudaMalloc(&dev_primeList, sizePrimeList * sizeof(int));
	if (cuda_result != cudaSuccess) {
		printf("1 %s\n", cudaGetErrorString(cudaGetLastError()));
		return NULL;
	}
	//Copie de la liste des premiers
	cuda_result = cudaMemcpy(dev_primeList, primeList, sizePrimeList * sizeof(int), cudaMemcpyHostToDevice);
	if (cuda_result != cudaSuccess) {
		printf(" 2 %s\n", cudaGetErrorString(cudaGetLastError()));
		return NULL;
	}

	//Allocation de l'ensemble div sur le GPU
	ensemble dev_div;
	cuda_result = cudaMalloc(&dev_div, sizeof(struct cell));
	if (cuda_result != cudaSuccess) {
		printf("3 %s\n", cudaGetErrorString(cudaGetLastError()));
		return NULL;
	}

	//test primalite N
	do {
		R = (ensemble) malloc(sizePrimeList*sizeof(struct cell));

		//Allocation de l'ensemble R sur le GPU
		cuda_result = cudaMalloc(&dev_R, sizePrimeList*sizeof(struct cell));
		if (cuda_result != cudaSuccess) {
			printf("4 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}

		sizeR = 0;

		m = (int *) malloc(sizeof(int));
		*m = sizeR;
		printf("test\n");
		//Allocation de m sur le GPU
		cuda_result = cudaMalloc(&dev_m, sizeof(int));
		if (cuda_result != cudaSuccess) {
			printf("5 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}
		//Copie de m sur le GPU
		cuda_result = cudaMemcpy(dev_m, m, sizeof(int), cudaMemcpyHostToDevice);
		if (cuda_result != cudaSuccess) {
			printf(" 6 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}

		matrix = (int *) malloc(sizePrimeList * sizePrimeList * sizeof(int));


		//Allocation de la matrice sur le GPU
		cuda_result = cudaMalloc(&dev_matrix, sizePrimeList * sizePrimeList * sizeof(int));
		if (cuda_result != cudaSuccess) {
			printf("7 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}

		cuda_result = cudaMemcpy(dev_div, div, sizeDiv * sizeof(int), cudaMemcpyHostToDevice);
		if (cuda_result != cudaSuccess) {
			printf(" 8 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}
		printf("CUDA? ES TU LA ?\n");
		fillEnsembleG<<<1, sizePrimeList>>>(dev_R, dev_primeList, sizePrimeList, n, borne, dev_div, sizeDiv, dev_m, dev_matrix);
		printf("NON\n");
		//Recopie de la matrice resultante
		cuda_result = cudaMemcpy(matrix, dev_matrix, sizePrimeList * sizePrimeList * sizeof(int), cudaMemcpyDeviceToHost);
		if (cuda_result != cudaSuccess) {
			printf("9 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}

		//Recopie de m
		cuda_result = cudaMemcpy(m, dev_m, sizeof(int), cudaMemcpyDeviceToHost);
		if (cuda_result != cudaSuccess) {
			printf("10 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}

		//Recopie de l'ensemble R
		cuda_result = cudaMemcpy(R, dev_R, *m * sizeof(struct cell), cudaMemcpyDeviceToHost);
		if (cuda_result != cudaSuccess) {
			printf("11 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}
		printf("OUUUUUUI !\n");
		//Recopie de la liste des premiers
		cuda_result = cudaMemcpy(primeList, dev_primeList, sizePrimeList * sizeof(int), cudaMemcpyDeviceToHost);
		if (cuda_result != cudaSuccess) {
			printf(" 12 %s\n", cudaGetErrorString(cudaGetLastError()));
			return NULL;
		}
		printf("GAUSS ??\n");
		int *E = gaussjordan_noyau(matrix, sizePrimeList);
		u = initU(R, *m, E, n);
		v = calcul_v(primeList, sizePrimeList, *m, matrix, sizePrimeList, E);
		if (pgcdUint(u - v, n) != 1 && pgcdUint(u - v, n) != n) {
			addVal(&div, u - v, &sizeDiv);
		} else if (pgcdUint(u + v, n) != 1 && pgcdUint(u + v, n) != n) {
			addVal(&div, u + v, &sizeDiv);
		}
		printf("CALL ME MAYBE ??\n");
		free(R);
		printf("BOUM R\n");
		cudaFree(dev_R);
		printf("BOUM DEV_R\n");
		free(m);
		printf("BOUM M\n");
		cudaFree(dev_m);
		printf("BOUM DEVM\n");
		free(matrix);
		printf("PILLULE ROUGE\n");
		cudaFree(dev_matrix);
		printf("PILLULE BLEUE ! sizeDiv = %i  \n",sizeDiv);
	}while (produit(div, sizeDiv) != n);
	printf("HEY\n");
	for(int i = 0; i<sizeDiv;i++){
		printf("res = %i\n",div[i].ind.val);

	}
	return div;
}
