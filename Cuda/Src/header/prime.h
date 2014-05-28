/**
* \file prime.h
* \brief Outils de génération de la liste de premiers
*
* Ensemble de fonctions pour la génération de l'ensemble des 
* premiers nécéssaire au fonctionnement de l'algorithme de Dixon.
*
*/ 

#ifndef PRIME_H_
#define PRIME_H_

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdint.h>


/**
* \fn __global__ void fillList(int *list, uint64_t borne) 
* \param list la liste a remplir
* \param borne la borne
*/
__global__ void fillList(int *list, uint64_t borne);

/**
* \fn __global__ void eratosthene(int *list)
* \brief Cette fonction elimine les multiples de chaque nombre 
* 
* Cette fonction elimine les multiples de chaque nombre
* Ce qui a pour effet d'enlever les nombres non premiers
* (crible d'Eratosthene)
*
* \param list Contient tous les nombres de 2 a borne
* 
*/
__global__ void eratosthene(int *list, uint64_t borne);

/**
* \fn int *generatePrimeList(int borne, int *size)
* \brief Genere la liste d'entiers premiers
* \param borne est la limite max des nb premiers generes
* \param size est la taille du tableau retourné
* \return res : Liste des Premiers
* 
*Cette fonction retourne le tableau d'entiers
*/
int *generatePrimeList(int borne, int *size);


#endif /* PRIME_H_ */
