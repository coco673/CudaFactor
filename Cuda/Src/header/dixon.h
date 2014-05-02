#ifndef _DIXON_H
#define _DIXON_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include "prime.h"
#include "coupleList.h"
#include "intList.h"
#include "smooth.h"
#include "gauss.h"
#include "pgcd.h"
#include "fillMatrix.h"
#include "rabin-miller.h"

uint64_t alea(uint64_t a, uint64_t b);
uint64_t produitDiv(Int_List Div);
int notIn(Int_List Div, uint64_t val);
int calcul_u(Couple_List R, int *noyau);
int calcul_v(uint64_t *premList, int sizePL, Couple_List R, int **matrix, int *noyau);
Int_List_GPU *dixon(uint64_t n);
//Int_List_GPU *dixonGPU(uint64_t n);
Int_List_GPU *factor(uint64_t n);
Int_List_GPU *dixonGPU(uint64_t nbr, uint64_t n, int *premList, int sizePL, int *ptr);
Int_List_GPU *dixonDevice(uint64_t nbr, uint64_t n, int *premList, int sizePL, int *ptr);


#endif
