/**
 * \file structure.h
 * \brief Suite d'outils pour la gestion des structures (Ensemble R, couples(x,y), ...)
 */

#ifndef STRUCTURE_H_
#define STRUCTURE_H_
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdint.h>

struct couple {
	int x;
	int y;
};
typedef struct couple couple;

union nb {
	int val;
	couple couple;
};
struct cell {
	union nb ind;
};
typedef struct cell* ensemble;

/**
 * \fn __host__  ensemble initEns(int *size)
 * \brief Alloue de l'espace memoire pour l'ensemble. Retourne un ensemble vide et initialise size à 0.
 * \param Taille de l'ensemble à initialiser
 * \return L'ensemble initialisé
 */
__host__  ensemble initEns(int *size);

/**
 * \fn __host__  int addCouple(ensemble *ens, uint64_t x, uint64_t y,int *size) 
 * \brief Ajout en tête d'un couple dans l'ensemble
 *
 * \param ens Ensemble dans lequel ajouter le couple
 * \param x couple( \a x , y ) 
 * \param y coupl ( x , \a y )
 * \param size Taille de l'ensemble
 * 
 * \return  taille de l'ensemble si tout c'est bien passé sinon retourne NULL. 
 * \bug possible fuite mémoire 
 */
__host__  int addCouple(ensemble *ens, uint64_t x, uint64_t y,int *size);

 /**
 * \fn __host__  int addCouple(ensemble *ens, uint64_t x, uint64_t y,int *size) 
 * \brief Ajout en tête une valeur dans l'ensemble
 *
 * \param ens Ensemble dans lequel ajouter le couple
 * \param x valeur à insérer dans l'ensemble
 * \param size Taille de l'ensemble
 */
__host__  int addVal(ensemble *ens, uint64_t x,int *size);
#endif /* STRUCTURE_H_ */
