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
