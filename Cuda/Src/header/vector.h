/*
 * vector.h
 *
 *  Created on: 6 avr. 2014
 *      Author: didelify
 */

#ifndef VECTOR_H_
#define VECTOR_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

struct VEC_ELEM {
	int *vec;
	struct VEC_ELEM *suiv;
};

typedef struct {
	struct VEC_ELEM *list;
	int vecNb;
} Vector_List;

 __host__ Vector_List *createVectorList();
 __host__ void addVector(Vector_List *list, const int *vec, int size);
 __host__ int *getVector(const Vector_List list, int index);
 __host__ void removeLastVector(Vector_List *list);
 __host__ void resetVectorList(Vector_List *list);
 __host__ int isNullVector(int *vec, int size);

#endif /* VECTOR_H_ */
