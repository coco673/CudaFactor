/**
 * \file dixon.h
 * \brief Algorithme de Dixon
 */

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


/**
 * \fn int adjust_bl(int value) 
 * \brief Détermine le nombre de blocs optimal à utiliser
 * \param value Taille de la liste des premiers
 * \return Nombre de blocs optimal
 */
int adjust_bl(int value);

/**
 * \fn int adjust_th(int value)
 * \brief Détermine le nombre de threads optimal à utiliser par bloc
 * \param value Taille de la liste des premiers
 * \return Nombre de threads optimal
 */
int adjust_th( int value);

/**
 * \fn uint64_t alea(uint64_t a, uint64_t b) 
 * \brief Génère un nombre aléatoire entre les bornes \a a et \a b passées en paramètre
 * \param a borne inférieure
 * \param b borne supérieure
 */
uint64_t alea(uint64_t a, uint64_t b);

/**
 * \fn uint64_t produitDiv(Int_List_GPU Div)
 * \brief Renvoie le produit des facteurs contenus dans div
 * \param Div Ensemble des factuers
 * \return res : Le résultat du produit
 */
uint64_t produitDiv(Int_List Div);

/**
 * \fn int notIn(Int_List_GPU Div, uint64_t val) 
 * \brief Vérifie si le facteur est déja dans Div
 * \param Div La liste des facteurs
 * \param val Le facteur à vérifier
 * \return 1 : Le facteur est dans Div | 0 : Le facteur n'est pas dans Div
 */
int notIn(Int_List Div, uint64_t val);

/**
 * \fn int calcul_u(Couple_List R, int *noyau, int n) 
 * \brief Effectue le calcul de \a U conformément à l'algorithme
 * \param R Liste des couples \a(x,y)
 * \param noyau Noyau de la matrice
 * \param n Le nombre à factoriser
 * \return res : Le résultat \a u 
 */
int calcul_u(Couple_List R, int *noyau);

/**
 * \fn int calcul_v(int *premList, int sizePL, Couple_List R, char **matrix, int *noyau, int n) 
 * \brief Effectue le calcul de \a V conformément à l'algorithme
 * \param premList Liste des premiers
 * \param sizePL Taille de la premList
 * \param matrix Matrice des vecteurs
 * \param noyau Noyau de la matrice
 * \param n Nombre à factoriser  
 * \return res : Le résultat \a u
 */
int calcul_v(int *premList, int sizePL, Couple_List R, char **matrix, int *noyau, int n);

/**
 * \fn char **matrix1DTo2D(char *matrix, int size) 
 * \brief Transforme un matrice à 1D en matrice à 2D
 * \param matrix Matrice à transformer
 * \param size Taille de la matrice
 * \return mat : La matrice 2D attendue
 */
char **matrix1DTo2D(char *matrix, int size); 

/**
 * \fn Int_List_GPU *mergeDiv(Int_List_GPU *src1, Int_List_GPU *src2)
 * \brief Fusionne deux ensembles Int_List_GPU et supprime les deux ensembles source
 * \param src1 Premier ensemble
 * \param src2 Second ensemble
 * \return result : L'ensemble formé après la fusion
 */
Int_List_GPU *mergeDiv(Int_List_GPU *src1, Int_List_GPU *src2);


Int_List_GPU *dixon(uint64_t n);

/**
 * \fn Int_List_GPU *factor(uint64_t n) 
 * \brief Parties de l'algorithme de Dixon qui s'exécutent sur le CPU
 * \param n Nombre à factoriser
 * \return Liste des facteurs premiers de \a N
 */
Int_List_GPU *factor(uint64_t n);

/**
 * \fn Int_List_GPU *dixonGPU(uint64_t nbr, uint64_t n, int *premList, int sizePL, int *ptr) 
 * \brief Coeur de l'algorithme de Dixon sur le GPU
 * \param nbr Nombre à factoriser divisé par les facteurs déja trouvés 
 * \param n Nombre à factoriser
 * \param premList Liste des nombres premiers
 * \param sizePL Taille de la premList
 * \param ptr Pointeur vers la mémoire de données constante du Device
 * \return Div : Liste des facteurs premiers de N
 */
Int_List_GPU *dixonGPU(uint64_t nbr, uint64_t n, int *premList, int sizePL, int *ptr);

#endif
