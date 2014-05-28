/**
 * \file rabin-miller.h
 * \brief Algorithme de Rabin-Miller pour test de primalité
 *
 */

#ifndef RABIN_MILLER_H_
#define RABIN_MILLER_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

/**
* \fn int modulo(int a,int b,int c)
* \brief Réimplémentation de l'opération modulo
* \param a 
* \param b
* \param c
* \return b % c
*/
int modulo(int a,int b,int c);

/**
* \fn long long mulmod(long long a,long long b,long long c)
* \brief Multiplication modulaire
* \param a \a A * B mod C
* \param b A * \a B mod C
* \param c A * B mod \a C
*/
long long mulmod(long long a,long long b,long long c);

/**
* \fn bool Miller(long long p,int iteration)
* \brief Test de primalité probabiliste de Rabin-Miller
* \param p Le nombre à évaluer
* \param iteration Nombre d'itérations
* \return true : le nombre est premier | false : le nombre n'est pas premier
*/
bool Miller(long long p,int iteration);

#endif /* RABIN_MILLER_H_ */
