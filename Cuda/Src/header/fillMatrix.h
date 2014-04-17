#ifndef _FILLMATRIX_H
#define _FILLMATRIX_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "coupleList.h"

int **fillMatrix(uint64_t *premList, int sizePL, const Couple_List *R);

#endif
