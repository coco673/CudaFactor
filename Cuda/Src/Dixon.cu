#include "header/Dixon.h"
#include <unistd.h>
#define CUDA_CHECK_RETURN(value) {											\
		cudaError_t _m_cudaStat = value;										\
		if (_m_cudaStat != cudaSuccess) {										\
			fprintf(stderr, "Error %s at line %d in file %s\n",					\
					cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
					exit(1);															\
		} }

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
/*
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
 */
ensemble Dixon2(int n,int *sizefinal){
	int borne = ceil(exp(sqrt(2 * log(n) * log(log(n)))));
	int nbr = n;
	int sizePrimeList;
	int *primeList = generatePrimeList(borne, &sizePrimeList);
	printf("sizePrimeList = %i\n",sizePrimeList);
	int sqrtNRB = (int)sqrt(nbr);
	int *rand = (int *) malloc(sizePrimeList*sizeof(int));
	int *dev_rand;
	curandState_t *state = (curandState_t *)malloc(sizePrimeList*sizeof(curandState_t));
	curandState_t *dev_state ;
	int *dev_primeList;
	CUDA_CHECK_RETURN(cudaMalloc((int **)&dev_primeList, sizePrimeList * sizeof(int)));
	CUDA_CHECK_RETURN(cudaMemcpy(dev_primeList, primeList, sizePrimeList * sizeof(int), cudaMemcpyHostToDevice));
	ensemble R, dev_R;
	ensemble Div = (ensemble) malloc(sizeof(struct cell));
	int *sizeDiv = (int*)malloc(sizeof(int));
	*sizeDiv = 0;
	ensemble dev_Div;
	int *sizeR=(int*)malloc(sizeof(int));
	int *dev_sizeR;
	int *dev_sizeDiv;
	printf("bonjour\n");
	for(int j = 0; j < sizePrimeList; j++){
		while(nbr % primeList[j] == 0){
			nbr = (nbr / primeList[j]);
			addVal(&Div, primeList[j], sizeDiv);
			printf("ok  size div =%i nbr = %i\n",*sizeDiv,nbr);
		}
	}
	if (nbr == 1){
		*sizefinal = *sizeDiv;
		return Div;
	}
	int *matrix;
	int *dev_matrix;
	int *kernel;
	int u, v;
	u = v = 1;
	printf("la borne est %i\n",borne);
	while(produit(Div,*sizeDiv) != n){
		printf("malloc 1\n");
		matrix= (int*)malloc(sizePrimeList * sizePrimeList * sizeof(int));
		printf("malloc 2\n");
		R = (ensemble) malloc(sizePrimeList * sizeof(struct cell));
		*sizeR = 0;
		CUDA_CHECK_RETURN(cudaMalloc(&dev_rand,sizePrimeList*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemcpy(dev_rand, rand, sizePrimeList * sizeof(int), cudaMemcpyHostToDevice));
		CUDA_CHECK_RETURN(cudaMalloc((int **)&dev_sizeR, sizePrimeList*sizeof(int)));
		CUDA_CHECK_RETURN(cudaMalloc((int **)&dev_sizeDiv, sizeof(int)));
		CUDA_CHECK_RETURN(cudaMalloc((curandState_t**)&dev_state, sizePrimeList*sizeof(curandState_t)));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeR, 0, sizeof(int)));
		CUDA_CHECK_RETURN(cudaMalloc((ensemble *)&dev_R, sizePrimeList * sizeof(struct cell)));
		CUDA_CHECK_RETURN(cudaMalloc((ensemble *)&dev_Div, *sizeDiv * sizeof(struct cell)));
		CUDA_CHECK_RETURN(cudaMemcpy(dev_R, R, *sizeR * sizeof(struct cell), cudaMemcpyHostToDevice));
		CUDA_CHECK_RETURN(cudaMemcpy(dev_sizeR, sizeR,sizeof(int), cudaMemcpyHostToDevice));
		CUDA_CHECK_RETURN(cudaMemcpy(dev_sizeDiv, sizeDiv,sizeof(int), cudaMemcpyHostToDevice));

		printf("size Div %i\n",*sizeDiv);
		printf(" Div %i\n",Div[*sizeDiv-1].ind.val);
		CUDA_CHECK_RETURN(cudaMemcpy(dev_Div, Div, *sizeDiv * sizeof(struct cell), cudaMemcpyHostToDevice));
		CUDA_CHECK_RETURN(cudaMalloc((int **)&dev_matrix, sizePrimeList * sizePrimeList * sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrix, 0, sizePrimeList * sizePrimeList * sizeof(int)));
printf("on ouvre %i thread \n",sizePrimeList);
		Generation<<<1,sizePrimeList>>>(dev_state,nbr, sqrtNRB,dev_rand);
		printf("size Div = %i\n",*sizeDiv);
		printf("on ouvre %i thread pour remplir \n",sizePrimeList);
		fillEnsR<<<1,sizePrimeList>>>(dev_state,dev_R,dev_sizeR,dev_Div,dev_sizeDiv,dev_primeList,sizePrimeList,dev_rand,nbr,dev_matrix);
		printf("OK T ES LA \n");

		CUDA_CHECK_RETURN(cudaMemcpy(sizeR, dev_sizeR, sizeof(int), cudaMemcpyDeviceToHost));
		CUDA_CHECK_RETURN(cudaMemcpy(sizeDiv, dev_sizeR, sizeof(int), cudaMemcpyDeviceToHost));
		CUDA_CHECK_RETURN(cudaMemcpy(R, dev_R, *sizeR * sizeof(struct cell), cudaMemcpyDeviceToHost));
printf("ta frangine !! \n");
		CUDA_CHECK_RETURN(cudaMemcpy(matrix, dev_matrix, sizePrimeList * sizePrimeList * sizeof(int), cudaMemcpyDeviceToHost));
		int *kernel = (int *) malloc(sizePrimeList * sizeof(int));

		gaussjordan_noyau(matrix, sizePrimeList,kernel);
		int tmp = 1;
		printf("malloc 3 + size of R = %i\n",*sizeR);

		//int *test = (int*) malloc((*sizeR)*sizeof(int));
		int test[N];
		printf("memset 1\n");

		memset(test,0,(*sizeR)*sizeof(int));
		printf("for 1\n");

		for(int i = 0; i < *sizeR; i++){
			if(kernel[i] != 0){
				tmp = tmp * (R[i].ind.couple.y);
				v = v * (R[i].ind.couple.x);
			}
		}
		printf("FIN U\n");
		u = 1;
		for(int i = 0; i < *sizeR; i++){
			while(tmp % primeList[i]){
				tmp = (tmp / primeList[i]);
				test[i] += 1;
			}
			test[i] = floor(test[i] / 2);
			u = u * (primeList[i] * test[i]);
		}
		printf("FIN V\n");
		if (pgcdUint(u+v,nbr) != 1){
			addVal(&Div, (u+v), sizeDiv);
		}
		printf("FIN PGCD\n");
		//CUDA_CHECK_RETURN(cudaFree(dev_Div));
		printf("free -1\n");

		//CUDA_CHECK_RETURN(cudaFree(dev_sizeDiv));
		printf("free -21\n");

		//CUDA_CHECK_RETURN(cudaFree(dev_R));
		printf("free -31\n");

		//CUDA_CHECK_RETURN(cudaFree(dev_matrix));
		printf("free -41\n");

		//CUDA_CHECK_RETURN(cudaFree(dev_sizeR));
		printf("free 1\n");
		free(R);
		printf("free 2\n");
		//free(test);
		printf("free 3\n");
		//free(matrix);
		printf("free 4\n");
		//free(kernel);
		printf("free 5\n");
	}
	*sizefinal = *sizeDiv;
	return Div;
}

ensemble Dixon(int n) {
	int borne = ceil(exp(sqrt(2 * log(n) * log(log(n)))));
	int sizePremList;
	int *premList = generatePrimeList(borne, &sizePremList);
	int *dev_premList;
	CUDA_CHECK_RETURN(cudaMalloc((int **)&dev_premList, sizePremList * sizeof(int)));
	CUDA_CHECK_RETURN(cudaMemcpy(dev_premList, premList, sizePremList * sizeof(int), cudaMemcpyHostToDevice));
	ensemble R, dev_R;
	ensemble Div = (ensemble) malloc(sizeof(struct cell));
	int sizeDiv = 0;
	ensemble dev_Div;
	int sizeR;
	int *dev_sizeR;
	int *matrix;
	int *dev_matrix;
	int *kernel;
	int u, v;
	//test de primalite
	while (produit(Div, sizeDiv) != n) {
		matrix = (int *) malloc(sizePremList * sizePremList * sizeof(int));
		R = (ensemble) malloc(sizePremList * sizeof(struct cell));
		sizeR = 0;

		CUDA_CHECK_RETURN(cudaMalloc((int **)&dev_sizeR, sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_sizeR, 0, sizeof(int)));
		CUDA_CHECK_RETURN(cudaMalloc((ensemble *)&dev_R, sizeR * sizeof(struct cell)));
		CUDA_CHECK_RETURN(cudaMemcpy(dev_R, R, sizeR * sizeof(struct cell), cudaMemcpyHostToDevice));
		CUDA_CHECK_RETURN(cudaMemcpy(dev_Div, Div, sizeDiv * sizeof(struct cell), cudaMemcpyHostToDevice));
		CUDA_CHECK_RETURN(cudaMalloc((int **)&dev_matrix, sizePremList * sizePremList * sizeof(int)));
		CUDA_CHECK_RETURN(cudaMemset(dev_matrix, 0, sizePremList * sizePremList * sizeof(int)));

		//fillEnsembleG<<<1, sizePremList>>>(dev_R, dev_premList, sizePremList, n, borne, Div, sizeDiv, dev_sizeR, dev_matrix);

		CUDA_CHECK_RETURN(cudaMemcpy(matrix, dev_matrix, sizePremList * sizePremList * sizeof(int), cudaMemcpyDeviceToHost));
		CUDA_CHECK_RETURN(cudaMemcpy(&sizeR, dev_sizeR, sizeof(int), cudaMemcpyDeviceToHost));
		CUDA_CHECK_RETURN(cudaMemcpy(R, dev_R, sizeR * sizeof(struct cell), cudaMemcpyDeviceToHost));
		//kernel = gaussjordan_noyau(matrix, sizePremList);
		u = initU(R, sizeR, kernel, n);
		v = calcul_v(premList, sizePremList, sizeR, matrix, sizePremList, kernel);
		if (pgcdUint(u - v, n) != 1 && pgcdUint(u - v, n) != n) {
			addVal(&Div, u - v, &sizeDiv);
		} else if (pgcdUint(u + v, n) != 1 && pgcdUint(u + v, n) != n) {
			addVal(&Div, u + v, &sizeDiv);
		}
		free(R);
		CUDA_CHECK_RETURN(cudaFree(dev_R));
		CUDA_CHECK_RETURN(cudaFree(dev_sizeR));
		free(matrix);
		CUDA_CHECK_RETURN(cudaFree(dev_matrix));
		printf("Passage");
	}
	return Div;
}
