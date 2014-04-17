#include "matrix.h"

/*******************************************************************************
 * 																			   *
 * 									Matrix2D								   *
 * 																			   *
 ******************************************************************************/

__device__ __host__ matrix2D *createEmptyMatrix2D() {
	matrix2D *matrix = (matrix2D *) malloc(sizeof(matrix2D));
	matrix->mat = NULL;
	matrix->colsNb = 0;
	matrix->rowsNb = 0;
	return matrix;
}

__device__ __host__ matrix2D *createMatrix2D(int rows, int cols) {
	matrix2D *matrix = (matrix2D *) malloc(sizeof(matrix2D));
	matrix->mat = (int **) malloc(rows * sizeof(int*));
	for (int i = 0; i < rows; i++) {
		matrix->mat[i] = (int *) malloc(cols * sizeof(int));
		for (int j = 0; j < cols; j++) {
			matrix->mat[i][j] = 0;
		}
	}
	matrix->colsNb = cols;
	matrix->rowsNb = rows;
	return matrix;
}

__device__ __host__ matrix2D *copyMatrix2D(matrix2D src) {
	matrix2D *matrix = (matrix2D *) malloc(sizeof(matrix2D));
	matrix->mat = (int **) malloc(src.rowsNb * sizeof(int*));
	for (int i = 0; i < src.rowsNb; i++) {
		matrix->mat[i] = (int *) malloc(src.colsNb * sizeof(int));
		for (int j = 0; j < src.colsNb; j++) {
			matrix->mat[i][j] = src.mat[i][j];
		}
	}
	matrix->rowsNb = src.rowsNb;
	matrix->colsNb = src.colsNb;
	return matrix;
}

__device__ __host__ matrix2D *addLineToMatrix2D(matrix2D *src, int val, int index) {
	int *vector = (int *) malloc(src->colsNb * sizeof(int));
	for (int i = 0; i < src->colsNb; i++) {
		vector[i] = val;
	}
	matrix2D *matrix = createMatrix2D(src->rowsNb + 1, src->colsNb);
	for (int i = 0; i < index; i++) {
		matrix->mat[i] = src->mat[i];
	}
	matrix->mat[index] = vector;
	for (int i = index + 1; i < matrix->rowsNb; i++) {
		matrix->mat[i] = src->mat[i - 1];
	}
	return matrix;
}

__device__ __host__ void swapLineMatrix2D(matrix2D *src, int line1, int line2) {
	int *tmpLine = (int *) malloc(src->colsNb * sizeof(int));
	for (int i = 0; i < src->colsNb; i++) {
		tmpLine[i] = src->mat[line2][i];
	}

	src->mat[line2] = src->mat[line1];
	src->mat[line1] = tmpLine;
}

/*******************************************************************************
 * 																			   *
 * 									Matrix1D								   *
 * 																			   *
 ******************************************************************************/

__device__ __host__ matrix1D *createEmptyMatrix1D() {
	matrix1D *matrix = (matrix1D *) malloc(sizeof(matrix1D));
	matrix->mat = NULL;
	matrix->colsNb = 0;
	matrix->rowsNb = 0;
	return matrix;
}

__device__ __host__ matrix1D *createMatrix1D(int rows, int cols) {
	matrix1D *matrix = (matrix1D *) malloc(sizeof(matrix1D));
	matrix->mat = (int *) malloc(rows * cols * sizeof(int));
	for (int j = 0; j < cols; j++) {
		matrix->mat[j] = 0;
	}
	matrix->colsNb = cols;
	matrix->rowsNb = rows;
	return matrix;
}

__device__ __host__ matrix1D *copyMatrix1D(matrix1D src) {
	matrix1D *matrix = (matrix1D *) malloc(sizeof(matrix1D));
	matrix->mat = (int *) malloc(src.rowsNb * src.colsNb * sizeof(int));
	for (int j = 0; j < src.colsNb * src.rowsNb; j++) {
		matrix->mat[j] = src.mat[j];
	}
	matrix->rowsNb = src.rowsNb;
	matrix->colsNb = src.colsNb;
	return matrix;
}

__device__ __host__ matrix1D *addLineToMatrix1D(matrix1D *src, int val, int index) {
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

__device__ __host__ void swapLineMatrix1D(matrix1D *src, int line1, int line2) {
	int *tmpLine = (int*) malloc(src->rowsNb * sizeof(int));
	for (int i = 0; i < src->rowsNb; i++) {
		tmpLine[i] = src->mat[line1 * src->colsNb + i];
		src->mat[line2 * src->colsNb + i] = src->mat[line1 * src->colsNb + i];
		src->mat[line1 * src->colsNb + i] = tmpLine[i];
	}
}
