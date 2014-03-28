#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <assert.h>
#include "../src/header/fillMatrix.h"
#include "../src/header/prime.h"
#include "TestFillMatrix.h"

int main(int argc, char **argv) {
	int *yList = (int *) malloc(3 * sizeof(int));
	yList[0] = 3;
	yList[1] = 5;
	yList[2] = 6;
	int sizeYList = 3;
	int sizePrimeList;
	int *primeList = generatePrimeList(10, &sizePrimeList);
    for (int i = 0; i < sizePrimeList; i++) {
        printf("%d\n", primeList[i]);
    }
	/*int nbVect = pow(2, sizePrimeList);
	//taille des vecteurs
	int sizeVect = floor((double) log(sizePrimeList)/ (double) log(2)) + 1;
	int res = (int *) malloc(sizeYList * sizeVect * sizeof(int));
	int dev_res, dev_yList, dev_primeList;
	cudaMalloc(dev_res, sizeYList * sizeVect * sizeof(int));
	cudaMalloc(dev_yList, 3 * sizeof(int));
	cudaMalloc(sizePrimeList * sizeof(int));
	cudaMemcpy(dev_yList, yList, dev_yList, 3 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_primeList, primeList, sizePrimeList * sizeof(int), cudaMemcpyHostToDevice);
	fillMatrix<<<sizeYList, nbVect>>>(dev_yList, dev_primeList, sizeVect, dev_res);
	cudaMemcpy(res, dev_res, sizeYList * sizeVect * sizeof(int), cudaMemcpyDeviceToHost);
	assert(res[0] == 0);
	assert(res[1] == 1);
	for(int i = 2; i < sizeVect; i++) {
		assert(res[i] == 0);
	}
	assert(res[sizeVect] == 0);
	assert(res[sizeVect + 1] == 0);
	assert(res[sizeVect + 2] == 1);
	for (int i = sizeVect + 3; i < 2 * sizeVect; i++) {
		assert(res[i] == 0);
	}
	assert(res[2 * sizeVect] == 1);
	assert(res[2 * sizeVect + 1] == 1);
	for (int i = 2 * sizeVect + 2; i < 3 * sizeVect; i++) {
		assert(res[i] == 0);
	}*/
    int **result = fillMatrixNaif(yList, sizeYList, primeList, sizePrimeList);
    for (int i = 0; i < sizeYList; i++) {
        printf("yList[%d] : [", i);
        for (int j = 0; j < sizePrimeList; j++) {
            printf("%d", result[i][j]);
            if (j != sizePrimeList - 1) {
                printf(" : ");
            }
        }
        printf("]\n");
    }
    return EXIT_SUCCESS;
}
