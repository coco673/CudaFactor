/*
 * structure.c
 *
 *  Created on: 6 févr. 2014
 *      Author: tony
 */
#include "header/structure.h"
#include <stdlib.h>
#include <stdio.h>
#include <cuda_runtime.h>
#include <cuda.h>

/**
 * Alloue de l'espace memoire pour l'ensemble. Retourne un ensemble vide
 * et initialise size à 0.
 */
__host__ __device__ ensemble initEns(int *size){
	ensemble tp  = (ensemble) malloc(sizeof(struct cell));
	*size = 0;

	return tp;
}


/**
 * Ajoute (en tete) un couple dans l'ensemble ens et retourne la taille de
 * l'ensemble si tout c'est bien passé sinon retourne NULL. !!ATTENTION POSSIBLE
 * FUITE MEMOIRE!!
 */
__host__ __device__ int addCouple(ensemble *ens, uint64_t x, uint64_t y,int *size){
	*size = *size+1;

	ensemble tp = (ensemble) malloc((*size)*sizeof(struct cell));
	if(*size > 1){

		if(tp == NULL){
			printf("malloc nok size:= %i\n",*size);
			return -1;
		}
		if( memcpy(&tp,ens,(*size-1)*sizeof(ens)) == NULL){
			printf("erreur de recopie d'ensemble\n");
			return -1;
		}

	}

	tp[*size-1].ind.couple.x =x;
	tp[*size-1].ind.couple.y = y;

	*ens =tp;



	return 1;
}
/**
 * Ajoute (en tete) une valeur dans l'ensemble ens et retourne la taille de
 * l'ensemble si tout c'est bien passé sinon retourne NULL
 */
__host__ __device__ int addVal(ensemble *ens, uint64_t x,int *size){
	/*	*size = (*size)+1;

	ensemble tp = (ensemble) malloc((*size)*sizeof(struct cell));
	if(tp == NULL){
		return -1;
	}
	if(*size > 1){
	tp = ens;
	}
	tp[(*size) - 1].ind.val=x;
	printf("%i :: %i\n",tp[*size-1].ind.val,tp[*size-2].ind.val);

	ens = tp;


	return 1;
	 */
	*size = *size+1;

	ensemble tp = (ensemble) malloc((*size)*sizeof(struct cell));
	if(*size > 1){

		tp=*ens;
		/*if( memcpy(&tp,ens,(*size-1)*sizeof(ens)) == NULL){
				printf("erreur de recopie d'ensemble\n");
				return -1;
			}*/

	}

	tp[*size-1].ind.val =x;


	*ens =tp;



	return 1;
}
