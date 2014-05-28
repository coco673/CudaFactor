/**
 * main.cu
 */

#include <stdio.h>
#include <stdlib.h>
#include "header/dixon.h"
#include <stdint.h>

int main(int argc, char **argv) {
	Int_List_GPU *Div;
	uint64_t n;
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);

	if (argc > 1)
	n= strtoull(argv[1],NULL,10);
	else
		n = 3061 * 3259;

	printf("Le nombre entre est %lu \n",n);

	if (n < 0) {
		fprintf(stderr, "Le nombre entre est négatif, entrez un nombre >= 2!\n");
		return EXIT_FAILURE;
	} else if (n <= 1) {
		printf("%lu n'est pas factorisable!\n", n);
		return EXIT_SUCCESS;
	} else if (n == 2) {
		Div = createIntList();
		addInt(&Div, n);
	} else {
		Div = factor(n);
	}
	printIntList(*Div);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("temps %f\n", elapsedTime / 1000);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	free(Div->List);
	free(Div);
	cudaDeviceReset();
}
