#include "header/coupleList.h"

 __host__ Couple_List *createCoupleList() {
	Couple_List *list = (Couple_List *) malloc(sizeof(Couple_List));
	list->list = NULL;
	list->size = 0;
	return list;
}

 __host__ void addCouple(Couple_List *list, const Couple c) {
	Couple tmp;
	tmp.x = c.x;
	tmp.y = c.y;
	if (list->size == 0) {
		list->list = (struct CL*) malloc(sizeof(struct CL));
		list->list->c = tmp;
		list->list->suiv = NULL;
	} else {
		struct CL *cl = (struct CL*) malloc(sizeof(struct CL));
		cl->c = tmp;
		cl->suiv = list->list;
		list->list = cl;
	}
	list->size++;
}

 __host__ Couple getCouple(const Couple_List list, int index) {
	int i = 0;
	Couple_List tmp = list;
	if (index > list.size - 1 || index < 0) {
		Couple error;
		error.x = 0;
		error.y = 0;
		return error;
	} else {
		while (i != index) {
			tmp.list = tmp.list->suiv;
			i++;
		}
		return tmp.list->c;
	}
}

 __host__ void removeLastCouple(Couple_List *list) {
	if (list->size != 0) {
		struct CL *ptr;
		ptr = list->list;
		while (ptr->suiv != NULL) {
			if (ptr->suiv->suiv == NULL) {
				struct CL *tmp;
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

 __host__ void resetCoupleList(Couple_List *list) {
	while (list->size != 0) {
		removeLastCouple(list);
	}
}

void printCouple(Couple c) {
	printf("x : %lud ; y : %lud\n", c.x, c.y);
}

void printCoupleList(const Couple_List list) {
	printf("Taille de la liste : %i\n", list.size);
	for (int i = 0; i < list.size; i++) {
		printCouple(getCouple(list, i));
	}
}
