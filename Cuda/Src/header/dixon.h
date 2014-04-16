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

int alea(int a, int b);
int produitDiv(Int_List Div);
int notIn(Int_List Div, int val);
int calcul_u(Couple_List R, int *noyau);
int calcul_v(int *premList, int sizePL, Couple_List R, int **matrix, int *noyau);
Int_List_GPU *dixon(int n);
Int_List_GPU *dixon3(int n);

#endif
