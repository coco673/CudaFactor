/**
* \file matrix.h
* \brief Outils pour la manipulation de matrices
*
*/ 

#ifndef MATRIX_H_
#define MATRIX_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct {
	char **mat;
	int rowsNb;
	int colsNb;
} matrix2D;

typedef struct {
	char *mat;
	int rowsNb;
	int colsNb;
} matrix1D;

/**
 * \fn __host__ matrix2D *createEmptyMatrix2D() 
 * \brief Cree une matrice 2D (mat[][]) vide
 * \return matrix : pointeur sur la matrice créée
 */
 __host__ matrix2D *createEmptyMatrix2D();

 /**
 * \fn __host__ matrix2D *createMatrix2D(int rows, int cols) 
 * \brief Crée une matrice aux dimensions passées en paramètre
 * \param rows Nombre de lignes
 * \param cols Nombre de colonnes
 *
 * Crée et initialise une matrice vide aux dimensions spécifiées
 * \return matrix : pointeur sur la structure matrix qui contient aussi sa taille
 */
 __host__ matrix2D *createMatrix2D(int rows, int cols);

 /**
 * \fn __host__ matrix2D *copyMatrix2D(matrix2D src) 
 * \brief Effectue la copie d'une matrice à 2 dimensions
 * \param src Matrice à copier
 *
 * \return matrix Copie de la matrice passée en paramètre
 */
 __host__ matrix2D *copyMatrix2D(matrix2D src);

 /**
 * \fn __host__ matrix2D *addLineToMatrix2D(matrix2D *src, int val, int index) 
 * \brief Ajoute une ligne à la matrice passée en paramètre 
 * \param src Matrice à laquelle ajouter une ligne
 * \param val Toute la ligne ajoutée est initialisée à \a val
 * \val index Position où insérer la ligne dans la matrice
 * \return matrix : Copie de la matrice à laquelle on a rajouté la ligne
 */
 __host__ void addLineToMatrix2D(matrix2D *src, int val, int index);
 
/**
 * \fn __host__ void swapLineMatrix2D(matrix2D *src, int line1, int line2) 
 * \brief Intervertis deux lignes de la matrice
 * \param src Matrice sur laquelle on travaille
 * \param line1 Première ligne à swap
 * \param line2 Seconde ligne à swap 
 */
 __host__ void swapLineMatrix2D(matrix2D *src, int line1, int line2);


/**
 * \fn __host__ matrix1D *createEmptyMatrix1D()
 * \brief Crée et renvoie une matrice à 1D (matrix[])
 * \return Retourne la matrice initialisée
 */
 __host__ matrix1D *createEmptyMatrix1D();

 /**
 * \fn __host__ matrix1D *createMatrix1D(int rows, int cols)
 * \brief Créee renvoie une matrice à 1D de la taille spécifiée en paramètre
 * \param rows Nombre de lignes
 * \param cols Nombre de colonnes
 * \return matrix : pointeur sur la structure matrice initialisée 
 */
 __host__ matrix1D *createMatrix1D(int rows, int cols);

 /**
 * \fn __host__ matrix1D *copyMatrix1D(matrix1D src)  
 * \brief Effectue la copie d'une matrice à 1D
 * \param src Matrice 1D à copier
 * \return matrix : copie de la matrice
 */
 __host__ matrix1D *copyMatrix1D(matrix1D src);

 /**
 * \fn __host__ matrix1D *addLineToMatrix1D(matrix1D *src, int val, int index) 
 * \brief Ajoute une ligne à la matrice passée en paramètre
 * \param val Toute la ligne ajoutée est initialisée à \a val
 * \val index Position où insérer la ligne dans la matrice
 * \return matrix : Copie de la matrice à laquelle on a rajouté la ligne
 */
 __host__ matrix1D *addLineToMatrix1D(matrix1D *src, int val, int index);
 
/**
 * \fn __host__ void swapLineMatrix1D(matrix1D *src, int line1, int line2) 
 * \brief
 * \brief Intervertis deux lignes de la matrice
 * \param src Matrice sur laquelle on travaille
 * \param line1 Première ligne à swap
 * \param line2 Seconde ligne à swap 
 */
 __host__ void swapLineMatrix1D(matrix1D *src, int line1, int line2);

 /**
  * \fn char **matrix1DTo2D(char *matrix, int size)
  * \brief Transforme un matrice à 1D en matrice à 2D
  * \param matrix Matrice à transformer
  * \param size Taille de la matrice
  * \return mat : La matrice 2D attendue
  */
 char **matrix1DTo2D(char *matrix, int size);

#endif /* MATRIX_H_ */
