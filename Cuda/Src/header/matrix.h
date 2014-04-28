/*
 * matrix.h
 *
 *  Created on: 6 avr. 2014
 *      Author: didelify
 */

#ifndef MATRIX_H_
#define MATRIX_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct {
	char **mat;
	int rowsNb;
	int colsNb;
} matrix2D;

typedef struct {
	char *mat;
	int rowsNb;
	int colsNb;
} matrix1D;

 __host__ matrix2D *createEmptyMatrix2D();
 __host__ matrix2D *createMatrix2D(int rows, int cols);
 __host__ matrix2D *copyMatrix2D(matrix2D src);
 __host__ matrix2D *addLineToMatrix2D(matrix2D *src, int val, int index);
 __host__ void swapLineMatrix2D(matrix2D *src, int line1, int line2);

 __host__ matrix1D *createEmptyMatrix1D();
 __host__ matrix1D *createMatrix1D(int rows, int cols);
 __host__ matrix1D *copyMatrix1D(matrix1D src);
 __host__ matrix1D *addLineToMatrix1D(matrix1D *src, int val, int index);
 __host__ void swapLineMatrix1D(matrix1D *src, int line1, int line2);


#endif /* MATRIX_H_ */
