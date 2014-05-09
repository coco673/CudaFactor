/**
* \file pgcd.h
* \brief Réimplémentation pgcd
*
*/ 

#ifndef PGDC_H_
#define PGCD_H_

#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <math.h>
#include <string.h>
#include <stdint.h>

#define N 2000

/**
* \fn uint64_t pgcdUint(uint64_t u, uint64_t v)
* \brief Calcule le plus grand commun diviseur de deux nombres
* \param u Premier nombre
* \param v Second Nombre
* \return res : Pgcd( \a u , \a v )
*/
uint64_t pgcdUint(uint64_t u, uint64_t v);


#endif /* PGCD_H_ */
