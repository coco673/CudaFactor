#include <stdio.h>
#include <stdlib.h>
#include "header/dixon.h"

int main(int argc, char **argv) {
	Int_List_GPU *Div;
	uint64_t n;
	cudaEvent_t start, stop;
	cudaDeviceReset();
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);
	if (argc > 1)
		n = atoll(argv[1]);
	else
		n = 16;
	printf("Le nombre entré est %llu\n",n);
	if (n < 0) {
		fprintf(stderr, "Le nombre entre est négatif, entrez un nombre >= 2!\n");
		return EXIT_FAILURE;
	} else if (n <= 1) {
		printf("%llu n'est pas factorisable!\n", n);
		return EXIT_SUCCESS;
	} else if (n == 2) {
		Div = createIntList();
		addInt(&Div, n);
	} else {
		Div = dixonGPU(n);
	}
	printIntList(*Div);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("temps %f\n", elapsedTime / 1000);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	free(Div);
	cudaDeviceReset();
}
