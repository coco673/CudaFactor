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
__host__  __device__ ensemble initEns(int *size){
	ensemble tp  = (ensemble) malloc(sizeof(struct cell));
	*size = 0;

	return tp;
}


/**
 * Ajoute (en tete) un couple dans l'ensemble ens et retourne la taille de
 * l'ensemble si tout c'est bien passé sinon retourne NULL
 */
__host__ __device__ ensemble addCouple(ensemble ens, int x, int y,int *size){
	*size = *size+1;
	ensemble tp = (ensemble) malloc(*size*sizeof(struct cell));
	if(tp == NULL){
			return NULL;
		}
	memcpy(&tp,&ens,sizeof(ens));
	tp[*size-1].ind.couple.x = x;
	tp[*size-1].ind.couple.y = y;

	return tp;

}
/**
 * Ajoute (en tete) une valeur dans l'ensemble ens et retourne la taille de
 * l'ensemble si tout c'est bien passé sinon retourne NULL
 */
__host__ __device__ ensemble addVal(ensemble ens, int x,int *size){
	*size = *size+1;
	ensemble tp = (ensemble) malloc(*size*sizeof(struct cell));
	if(tp == NULL){
			return NULL;
		}
	memcpy(&tp,&ens,sizeof(ens));
	tp[*size-1].ind.val=x;

	return tp;

}
