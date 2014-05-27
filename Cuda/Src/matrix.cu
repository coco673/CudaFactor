#include "header/matrix.h"
#include <unistd.h>
#include<errno.h>
/*******************************************************************************
 * 																			   *
 * 									Matrix2D								   *
 * 																			   *
 ******************************************************************************/

__host__ matrix2D *createEmptyMatrix2D() {
	matrix2D *matrix = (matrix2D *) malloc(sizeof(matrix2D));
	matrix->mat = NULL;
	matrix->colsNb = 0;
	matrix->rowsNb = 0;
	return matrix;
}

__host__ matrix2D *createMatrix2D(int rows, int cols) {
	matrix2D *matrix = (matrix2D *) malloc(sizeof(matrix2D));
	matrix->mat = (char **) malloc(rows * sizeof(char*));

	for (int i = 0; i < rows; i++) {
		matrix->mat[i] = (char *) malloc(cols * sizeof(char));
		if (matrix->mat[i] == NULL) {
			char s[30];
			sprintf(s," create matrix %i",i);
			perror(s);
		} else {
			if (memset(matrix->mat[i],0,cols*sizeof(char)) == NULL) {
				perror("createMatrix2D \n");
			}
		}

	}
	matrix->colsNb = cols;
	matrix->rowsNb = rows;
	return matrix;
}

__host__ matrix2D *copyMatrix2D(matrix2D src) {
	matrix2D *matrix = (matrix2D *) malloc(sizeof(matrix2D));
	if (matrix == NULL) {
		perror("copy mat");
	}
	matrix->mat = (char **) malloc(src.rowsNb * sizeof(char*));
	if (matrix->mat == NULL) {
		perror("matrix mat");
	}
	for (int i = 0; i < src.rowsNb; i++) {
		matrix->mat[i] = (char *) malloc(src.colsNb * sizeof(char));
		if(matrix->mat[i] == NULL){
			perror("mattrix mat[i]");
		}

		memcpy(matrix->mat[i],src.mat[i],src.colsNb*sizeof(char));
	}
	matrix->rowsNb = src.rowsNb;
	matrix->colsNb = src.colsNb;
	return matrix;
}

__host__ void addLineToMatrix2D(matrix2D *src, int val, int index) {
	char *vector = (char *) malloc(src->colsNb * sizeof(char));
	if (vector == NULL) {
		perror("add line vector");
	}
	for (int i = 0; i < src->colsNb; i++) {
		vector[i] = val;
	}
	matrix2D *matrix = createMatrix2D(src->rowsNb + 1, src->colsNb);
	if (matrix == NULL) {
		perror("add line matrix");
	}

	for (int i = 0; i < index; i++) {
		memcpy(matrix->mat[i],src->mat[i],src->colsNb * sizeof(char));
	}
	memcpy(matrix->mat[index],vector,src->colsNb * sizeof(char));
	for (int i = index + 1; i < matrix->rowsNb; i++) {
		memcpy(matrix->mat[i],src->mat[i-1],src->colsNb*sizeof(char));
	}
	for(int i=0;i<src->rowsNb;i++){
		free(src->mat[i]);
	}
	free(src->mat);
	src->mat=(char **)malloc(matrix->rowsNb*sizeof(char*));

	for (int i =0;i<matrix->rowsNb;i++){
		src->mat[i]=((char*)malloc(matrix->colsNb * sizeof(char)));
		memcpy(src->mat[i],matrix->mat[i],matrix->colsNb * sizeof(char));

	}
	src->colsNb = matrix->colsNb;
	src->rowsNb = matrix->rowsNb;
	for(int i=0;i<src->rowsNb;i++){
		free(matrix->mat[i]);
	}
	free(matrix->mat);
	free(matrix);
}

__host__ void swapLineMatrix2D(matrix2D *src, int line1, int line2) {
	char *tmpLine = (char *) malloc(src->colsNb * sizeof(char));
	if(tmpLine == NULL) {
		perror("swapLine");
	}
	for (int i = 0; i < src->colsNb; i++) {
		tmpLine[i] = src->mat[line2][i];
	}
	free(src->mat[line2]);
	src->mat[line2] = src->mat[line1];
	src->mat[line1] = tmpLine;

}

/*******************************************************************************
 * 																			   *
 * 									Matrix1D								   *
 * 																			   *
 ******************************************************************************/

__host__ matrix1D *createEmptyMatrix1D() {
	matrix1D *matrix = (matrix1D *) malloc(sizeof(matrix1D));
	matrix->mat = NULL;
	matrix->colsNb = 0;
	matrix->rowsNb = 0;
	return matrix;
}

__host__ matrix1D *createMatrix1D(int rows, int cols) {
	matrix1D *matrix = (matrix1D *) malloc(sizeof(matrix1D));
	matrix->mat = (char *) malloc(rows * cols * sizeof(char));
	for (int j = 0; j < cols; j++) {
		matrix->mat[j] = 0;
	}
	matrix->colsNb = cols;
	matrix->rowsNb = rows;
	return matrix;
}

__host__ matrix1D *copyMatrix1D(matrix1D src) {
	matrix1D *matrix = (matrix1D *) malloc(sizeof(matrix1D));
	matrix->mat = (char *) malloc(src.rowsNb * src.colsNb * sizeof(char));
	for (int j = 0; j < src.colsNb * src.rowsNb; j++) {
		matrix->mat[j] = src.mat[j];
	}
	matrix->rowsNb = src.rowsNb;
	matrix->colsNb = src.colsNb;
	return matrix;
}

__host__ matrix1D *addLineToMatrix1D(matrix1D *src, int val, int index) {
	matrix1D *matrix = createMatrix1D(src->rowsNb + 1, src->colsNb);
	for (int i = 0; i < index * src->colsNb; i++) {
		matrix->mat[i] = src->mat[i];
	}
	for (int i = 0; i < src->colsNb; i++) {
		matrix->mat[index * src->colsNb + i] = val;
	}
	for (int i = index * src->colsNb + 1; i < matrix->rowsNb * src->colsNb; i++) {
		matrix->mat[i] = src->mat[i - 1];
	}
	return matrix;
}

__host__ void swapLineMatrix1D(matrix1D *src, int line1, int line2) {
	char *tmpLine = (char*) malloc(src->rowsNb * sizeof(char));
	for (int i = 0; i < src->rowsNb; i++) {
		tmpLine[i] = src->mat[line1 * src->colsNb + i];
		src->mat[line2 * src->colsNb + i] = src->mat[line1 * src->colsNb + i];
		src->mat[line1 * src->colsNb + i] = tmpLine[i];
	}
}

char **matrix1DTo2D(char *matrix, int size) {
	char **mat = new char*[size];

	for (int i = 0;i< size ; i++) {
		mat[i] = new char[size];
	}

	int row = 0, col = 0;
	for (int i = 0; i < size * size; i+=size) {
		memcpy(mat[row],matrix+i,size*sizeof(char));
		col = (col + 1) % size;
		if (col == 0) {
			row++;
		}
	}
	return mat;
}
