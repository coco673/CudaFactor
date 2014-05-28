/**
 * \file gauss.h
 * \brief Algorithme de Gauss pour calculer son noyau
 */
 

#ifndef GAUSS_H_
#define GAUSS_H_

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdint.h>
#include "matrix.h"
#include "vector.h"

/*
 * \fn void print_matrix(char **matrix, int size)
 * \brief Affichage de la matrice carrée \a matrix
 * \param matrix Matrice carrée à afficher
 * \param size Taille de la matrice
 */
void print_matrix(char **matrix, int size);

/*
 * \fn Vector_List *gaussjordan_noyau(char **matrix, int size)
 * \brief Calcul du noyau de la matrice \a matrix
 * \param matrix Matrice carrée 
 * \param size Taille de la matrice
 */
Vector_List *gaussjordan_noyau(char **matrix, int size);

#endif /* GAUSS_H_ */
