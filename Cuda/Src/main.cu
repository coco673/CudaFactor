#include <stdio.h>
#include <stdlib.h>
#include "dixon.h"

int main(int argc, char **argv) {
	Int_List *Div;
	int n;
	n = atoi(argv[1]);
	printf("Le nombre entrée est %i\n",n);
	if (n < 0) {
		fprintf(stderr, "Le nombre entre est négatif, entrez un nombre >= 2!\n");
		return EXIT_FAILURE;
	} else if (n <= 1) {
		printf("%i n'est pas factorisable!\n", n);
		return EXIT_SUCCESS;
	} else if (n == 2) {
		Div = createIntList();
		addInt(Div, n);
	} else {
		Div = dixon(n);
	}
	printIntList(*Div);
	free(Div);
}
