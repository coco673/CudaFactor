#ifndef _ENSEMBLE_H
#define _ENSEMBLE_H

struct IL {
	int val;
	struct IL *suiv;
};

typedef struct Int_L {
	struct IL *list;
	int size;
} Int_List;

typedef struct {
	int *List;
	int Size;
} Int_List_GPU;

typedef struct {
	int x; 
	int y;
} Couple;

struct CL {
	Couple c;
	struct CL *suiv;
};

typedef struct Couple_L {
	struct CL *list;
	int size;
} Couple_List;

#endif
