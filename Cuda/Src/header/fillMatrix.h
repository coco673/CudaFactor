/**
* \file fillMatrix.h
* \brief Remplissage de la matrice de vecteurs
* 
*/
#ifndef _FILLMATRIX_H
#define _FILLMATRIX_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "coupleList.h"

/**
* \fn int **fillMatrix(int *premList, int sizePL, const Couple_List *R)
* \brief Remplissage de la matrice de vecteurs
* \param premList Liste des entiers pour calculer les vecteurs
* \param sizePL Taille de la premList passée en paramètre
* \param R Ensemble des couples (x,y) nécésaires au calcul des vecteurs
*
*
* \return matrix La matrice de vecteurs
*/ 
int **fillMatrix(int *premList, int sizePL, const Couple_List *R);

#endif
