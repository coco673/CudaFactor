#include <stdio.h>
#include <stdlib.h>
#include "dixon.h"

int main(int argc, char **argv) {
	Int_List *Div;
	int n;
	n = atoi(argv[1]);
	printf("%i\n",n);
	Div = dixon(n);
	printf("Le nombre entrée est %i\n",n);
	printIntList(*Div);
	free(Div);



	//Test gauss
	/*int **matrix = (int **) malloc(4 * sizeof(int *));
	for (int i = 0; i < 3; i++) {
		matrix[i] = (int *) malloc(4 * sizeof(int));
	}
	matrix[0][0] = 0;
	matrix[0][1] = 1;
	matrix[0][2] = 0;
	//matrix[0][3] = 4;
	matrix[1][0] = 1;
	matrix[1][1] = 0;
	matrix[1][2] = 1;
	//matrix[1][3] = 6;
	matrix[2][0] = 1;
	matrix[2][1] = 1;
	matrix[2][2] = 1;
	//matrix[2][3] = 10;
	Vector_List *list;
	list = gaussjordan_noyau(matrix, 3);
	while(list->list != NULL) {
		for (int i = 0; i < 3; i++) {
			printf("%i\t", list->list->vec[i]);
		}
		printf("\n");
		list->list = list->list->suiv;
	}*/
}
