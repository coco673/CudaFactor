#ifndef _ENSEMBLE_H
#define _ENSEMBLE_H

#include <stdint.h>

struct IL {
	uint64_t val;
	struct IL *suiv;
};

typedef struct Int_L {
	struct IL *list;
	int size;
} Int_List;

typedef struct {
	uint64_t *List;
	int Size;
} Int_List_GPU;

typedef struct {
	uint64_t x;
	uint64_t y;
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
