/**
 * \file fillEns.h
 * \brief Première boucle de l'algorithme, remplissage de l'ensemble R (couples (x,y) )
 */
#include <curand_kernel.h>
#include <curand.h>
#include <stdint.h>
#include "ensemble.h"
#include "intList.h"
#ifndef FILLENS_H_
#define FILLENS_H_

#define NB_TH_PER_BLOCK 32

/**
 * \fn __device__ int isInf(uint64_t *list, int size, uint64_t y)
 * \brief (GPU) Vérifie si les valeurs dans la premlist est inférieure à y
 * 
 * 
 * Mode GPU.
 * Verifie si chaque valeur contenue dans la liste des premiers (de taille size)
 * est inférieur a la valeur y.
 *
 *
 * \param list Liste à vérifier
 * \param size Taille de la liste
 * \param y borne
 */
__device__ int isInf(uint64_t *list, int size, uint64_t y);

/**
 * \fn __device__ void isBSmoothG(int *devPremList, int size, uint64_t y,int *result)
 * \brief (GPU) Vérifie si la valeur est B-friable
 *
 * \param devPremList Liste des premiers (GPU)
 * \param size Taille de la devPremList
 * \param y valeur à évaluer
 *
 * Mode GPU
 * Verifie si la valeur y est B-friable.
 * list est la liste des premiers de la borne
 * result le resultat retourné
 *
 * \return result - 0 : Pas B-Friable | 1 : B-Friable
 */
__device__ void isBSmoothG(int *devPremList, int size, uint64_t y,int *result);

/**
 * \fn __device__ void isBSmoothG(int *devPremList, int size, uint64_t y,int *result)
 * \brief (GPU) Vérifie si la valeur est B-friable
 *
 * \param devPremList Liste des premiers (GPU)
 * \param size Taille de la devPremList
 * \param y valeur à évaluer
 *
 * Mode GPU
 * Verifie si la valeur y est B-friable.
 * list est la liste des premiers de la borne
 * result le resultat retourné
 *
 * \return result - 0 : Pas B-Friable | 1 : B-Friable
 */
__device__ void isBSmoothG(int *devPremList, int size, uint64_t y,int *result);



/**
 * \fn __device__ void isInEnsembleG(uint64_t *ens, uint64_t y,int size, int *res)
 * \brief (GPU) Vérifie si la valeur y est dans l'ensemble 
 *
 * \param ens Ensemble dans lequel vérifier
 * \param y Valeur à évaluer
 * \param size Taille de l'ensemble
 * \param res Pointeur pour renvoyer le résultat
 *
 * Mode GPU
 * Verifie si la valeur y fait partie de l'ensemble ens et stocke le resultat
 * res.
 * size est la taille de l'ensemble.
 */
__device__ void isInEnsembleG(uint64_t *ens, uint64_t y,int size, uint64_t *res);

 /**
 * \fn __device__ void setup_kernel ( curandState_t *state )
 * \brief Initialisation de l'aléatoire
 */
__device__ void setup_kernel ( curandState_t *state );

 /**
 * \fn __device__ void generate( curandState_t *globalState, uint64_t *rand, uint64_t nbr, uint64_t racN)
 * \brief (GPU) Génération de valeurs aléatoires pour l'algorithme de Dixon
 * 
 * \param globalState Seed pour générer des nombres aléatoires
 * \param rand Tableau où stocker les nombres aléatoires générés
 * \param nbr Taille de l'ensemble à générer
 * \param borne jusqu'à laquelle générer les nombres aléatoires (sqrt(N))
 *
 */
__device__ void generate( curandState_t *globalState, uint64_t *rand, uint64_t nbr, uint64_t racN);

 /**
 * \fn __device__ void Generation(curandState_t *state,uint64_t nbr, uint64_t sqrtNBR,uint64_t *rand)
 * \brief (GPU) Appel la fonction setup_kernel sur le paramètre state
 * 
 * \param state Seed pour générer des nombres aléatoires
 * \param nbr Taille de l'ensemble à générer
 * \param sqrtNbr Taille jusqu'à laquelle générer les nombres aléatoires (racine de N)
 * \param rand Tableau où stocker les nombres aléatoires générés
 *
 */
__global__ void Generation(curandState_t *state,uint64_t nbr, uint64_t sqrtNBR,uint64_t *rand);

/**
 * \fn __global__ void fillEnsR(curandState_t *state,Couple *R,int *size,uint64_t *Div,int sizeDiv,int * devPremList,int k,uint64_t *rand,uint64_t nbr,char *matrix)
 * \brief (GPU) Remplissage de l'ensemble R et de la matrice de vecteurs
 *
 * \param state Seed pour générer les \a x aléatoires
 * \param R Tableau des couples \a x et \a y répondant aux critères de l'algorithme
 * \param size Taille de l'ensemble R
 * \param Div Ensemble des facteurs déja trouvés pour N
 * \param sizeDiv Taille de l'ensemble Div
 * \param devPremList Ensemble des premiers
 * \param k Taille de la devPremList
 * \param rand Liste aléatoire pour générer les \x
 * \param nbr Nombre à factoriser
 * \param matrix Matrice des vecteurs à remplir à partir de R
 *
 * Construction de l'ensemble des couples (\a x , \a y ) répondant aux critères puis remplissage de la matrice nécéssaire pour le calcul de u et v
 * Ces deux étapes importantes de l'algorithme ont été réunies pour éviter d'avoir à fermer les threads et les blocs, ce qui serait une perte de performances
 */
__global__ void fillEnsR(curandState_t *state,Couple *R,int *size,uint64_t *Div,int sizeDiv,int *, int k,uint64_t *rand,uint64_t nbr,char *matrix);
#endif /* FILLENS_H_ */
