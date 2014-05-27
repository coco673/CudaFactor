/**
 * \file intList.h
 * \brief Gestion de listes d'entiers pour les échanges entre CPU et GPU
 */
#ifndef _INTLIST_H
#define _INTLIST_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "ensemble.h"

/**
 * \fn __device__ void copyTabDev(uint64_t *src, uint64_t *dest, int size) 
 * \brief Copie d'un tableau sur le device 
 * \param src Tableau d'entrée
 * \param dest Tableau copié (device)
 * \param size Taille du tableau
 */
__device__ void copyTabDev(uint64_t *src, uint64_t *dest, int size);

/**
 * \fn __global__ void copyTabGPU(uint64_t *src, uint64_t *dest, int size)
 * \brief Copie d'un tableau sur le GPU
 * \param src Tableau d'entrée
 * \param dest Tableau copié 
 * \param size Taille du tableau
 */
__global__ void copyTabGPU(uint64_t *src, uint64_t *dest, int size);

/**
 * \fn __host__ Int_List_GPU *createIntList()
 * \brief Création d'une liste d'entiers sur le GPU
 * \return Retourne la liste d'entiers
 */
__host__ Int_List_GPU *createIntList();

/**
 * \fn __host__ void addInt(Int_List_GPU **list, int v)
 * \brief Ajout en queue d'un entier dans la liste 
 * \param list Liste d'entiers GPU
 * \param v Entier à ajouter
 */
__host__ void addInt(Int_List_GPU **list, int v);


/**
 * \fn __device__ void addIntGPU(uint64_t **list, int size, int v)
 * \brief Ajout en queue d'un entier dans la liste 
 * \param list Liste d'entiers GPU
 * \param size Taille de la liste
 * \param v Entier à ajouter
 */
__device__ void addIntGPU(int **list, int size, int v);

/**
 * \fn __host__ uint64_t getVal(Int_List_GPU l, int index)
 * \brief Retourne la valeur dans la liste siué à l'index demandé sur l'hôte
 * \param l Liste d'entiers GPU
 * \param index Index demandé
 * \return retourne l'élément de la liste à l'index index
 */
__host__ uint64_t getVal(Int_List_GPU l, int index);

/**
 * \fn __device__ uint64_t getValGPU(uint64_t *l, int index)
 * \brief Retourne la valeur dans la liste siué à l'index demandé sr le GPU
 * \param l Liste d'entiers GPU
 * \param index Index demandé
 * \return retourne l'élément de la liste à l'index index
 */
__device__ uint64_t getValGPU(uint64_t *l, int index);

/**
 * \fn __host__ void removeLastInt(Int_List_GPU **list) 
 * \brief Enlève le dernier entier de la liste sur l'hôte
 * \param list Liste d'entiers
 */
__host__ void removeLastInt(Int_List_GPU **list);

/**
 * \fn __host__ void resetIntList(Int_List_GPU **list) 
 * \brief Réinitialise la liste à vide sur le GPU
 * \param liste Liste d'entiers sur GPU
 */
__device__ void removeLastInt(int **list, int size);

/**
 * \fn __device__ void resetIntListGPU(uint64_t **list, uint64_t size) 
 * \brief Réinitialise la liste à vide sur le CPU
 * \param liste Liste d'entiers
 */
__host__ void resetIntList(Int_List_GPU **list);

/**
 * \fn __host__ void printIntList(Int_List_GPU l)
 * \brief Affiche la liste d'entiers sur le GPU
 * \param l Liste d'entiers GPU
 */
__device__ void resetIntListGPU(int **list, int size);

/*
 * \fn __host__ void printIntList(Int_List_GPU l)
 * \brief Affiche la liste d'entiers sur le CPU
 * \param l Liste d'entiers GPU
 */
__host__ void printIntList(Int_List_GPU l);

/**
 * \fn uint64_t produitDiv(Int_List_GPU Div)
 * \brief Renvoie le produit des facteurs contenus dans div
 * \param Div Ensemble des factuers
 * \return res : Le résultat du produit
 */
uint64_t produitDiv(Int_List_GPU Div);

/**
 * \fn int notIn(Int_List_GPU Div, uint64_t val)
 * \brief Vérifie si le facteur est déja dans Div
 * \param Div La liste des facteurs
 * \param val Le facteur à vérifier
 * \return 1 : Le facteur est dans Div | 0 : Le facteur n'est pas dans Div
 */
int notIn(Int_List Div, uint64_t val);

/**
 * \fn Int_List_GPU *mergeDiv(Int_List_GPU *src1, Int_List_GPU *src2)
 * \brief Fusionne deux ensembles Int_List_GPU et supprime les deux ensembles source
 * \param src1 Premier ensemble
 * \param src2 Second ensemble
 * \return result : L'ensemble formé après la fusion
 */
Int_List_GPU *mergeDiv(Int_List_GPU *src1, Int_List_GPU *src2);


#endif
