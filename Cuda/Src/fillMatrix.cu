#include "fillMatrix.h"

int **fillMatrix(int *premList, int sizePL, const Couple_List *R) {
	int **matrix = (int **) malloc(R->size * sizeof(int *));
	for (int i  = 0; i < R->size; i++) {
		matrix[i] = (int *) malloc(sizePL * sizeof(int));

		for (int j = 0; j < sizePL; j++) {
			matrix[i][j] = 0;
		}
	}

	int tmp, index;
	for (int i = 0; i < R->size; i++) {
		tmp = getCouple(*R, i).y;
		index = 0;
		while (tmp != 1) {
			if (tmp % premList[index] == 0) {
				tmp /= premList[index];
				matrix[i][index]++;
			} else {
				index++;
				if (index == sizePL) {
					fprintf(stderr, "Decomposition impossible, borne trop petite\n");
					exit(EXIT_FAILURE);
				}
			}
		}
	}
	return matrix;
}
