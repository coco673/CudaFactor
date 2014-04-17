#include "vector.h"

__device__ __host__ Vector_List *createVectorList() {
	Vector_List *list = (Vector_List *) malloc(sizeof(Vector_List));
	list->list = NULL;
	list->vecNb = 0;
	return list;
}

__device__ __host__ void addVector(Vector_List *list, const int *vec, int size) {
	int *tmp = (int *) malloc(size * sizeof(int));
	for (int i = 0; i < size; i++) {
		tmp[i] = vec[i];
	}
	if (list->vecNb == 0) {
		list->list = (struct VEC_ELEM*) malloc(sizeof(struct VEC_ELEM));
		list->list->vec = tmp;
		list->list->suiv = NULL;
	} else {
		struct VEC_ELEM *cl = (struct VEC_ELEM*) malloc(sizeof(struct VEC_ELEM));
		cl->vec = tmp;
		cl->suiv = list->list;
		list->list = cl;
	}
	list->vecNb++;
}

__device__ __host__ int *getVector(const Vector_List list, int index) {
	int i = 0;
	Vector_List tmp = list;
	if (index > list.vecNb - 1 || index < 0) {
		return NULL;
	} else {
		while (i != index) {
			tmp.list = tmp.list->suiv;
			i++;
		}
		return tmp.list->vec;
	}
}

__device__ __host__ void removeLastVector(Vector_List *list) {
	if (list->vecNb != 0) {
		struct VEC_ELEM *ptr;
		ptr = list->list;
		while (ptr->suiv != NULL) {
			if (ptr->suiv->suiv == NULL) {
				struct VEC_ELEM *tmp;
				tmp = ptr;
				ptr = ptr->suiv;
				tmp->suiv = NULL;
			} else {
				ptr = ptr->suiv;
			}
		}
		free(ptr);
		list->vecNb--;
	}
}

__device__ __host__ void resetVectorList(Vector_List *list) {
	while (list->vecNb != 0) {
		removeLastVector(list);
	}
}

__device__ __host__ int isNullVector(int *vec, int size) {
	for (int i = 0; i < size; i++) {
		if (vec[i] != 0) {
			return 1;
		}
	}
	return 0;
}
