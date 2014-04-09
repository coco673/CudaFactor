#include "intList.h"

#include "coupleList.h"

__device__ __host__ Int_List *createIntList() {
	Int_List *list = (Int_List *) malloc(sizeof(Int_List));
	list->list = NULL;
	list->size = 0;
	return list;
}



__device__ __host__ void addInt(Int_List *list, int c) {
	if (list->size == 0) {
		list->list = (struct IL*) malloc(sizeof(struct IL));
		list->list->val = c;
		list->list->suiv = NULL;
	} else {
		struct IL *cl = (struct IL*) malloc(sizeof(struct IL));
		cl->val = c;
		cl->suiv = list->list;
		list->list = cl;
	}
	list->size++;
}

__device__ __host__ int getVal(const Int_List list, int index) {
	int i = 0;
	Int_List tmp = list;
	if (index > list.size - 1 || index < 0) {
		return -1;
	} else {
		while (i != index) {
			tmp.list = tmp.list->suiv;
			i++;
		}
		return tmp.list->val;
	}
}

__device__ __host__ void removeLastInt(Int_List *list) {
	if (list->size != 0) {
		struct IL *ptr;
		ptr = list->list;
		while (ptr->suiv != NULL) {
			if (ptr->suiv->suiv == NULL) {
				struct IL *tmp;
				tmp = ptr;
				ptr = ptr->suiv;
				tmp->suiv = NULL;
			} else {
				ptr = ptr->suiv;
			}
		}
		free(ptr);
		list->size--;
	} 
} 

__device__ __host__ void resetIntList(Int_List *list) {
	while (list->size != 0) {
		removeLastInt(list);
	}
}

void printIntList(const Int_List list) {
	printf("Taille de la liste : %i\n", list.size);
	for (int i = 0; i < list.size; i++) {
		printf("val : %i\n", getVal(list, i));
	}
}

