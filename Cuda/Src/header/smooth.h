/**
 * \file smooth.cu
 * \brief TEst si un entier est friable
 */

#ifndef _SMOOTH_H
#define _SMOOTH_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


/**
 * \fn int isBSmoothG(int *primeList, int size, uint64_t y)
 * \brief Vérifie si le nombre passé en paramètre est B-smooth
 * \param primeList Liste des entiers premiers 
 * \param size Taille de la primeList
 * \param y Nombre à évaluer
 * 
 * \return 1 : Est B-Smooth | 0 : N'est pas B-smoot | -1 : Erreur
 */
int isBSmoothG(int *primeList, int size, uint64_t y);

#endif
