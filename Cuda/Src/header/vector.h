/**
 * \file vector.h
 * \brief Suite d'outils pour le traitement des vecteurs
 */

#ifndef VECTOR_H_
#define VECTOR_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

struct VEC_ELEM {
	int *vec;
	struct VEC_ELEM *suiv;
};

typedef struct {
	struct VEC_ELEM *list;
	int vecNb;
} Vector_List;

/**
 * \fn __host__ Vector_List *createVectorList()
 * \brief Création/Initialisation d'une liste vide de vecteurs
 * \return Pointeur sur la liste
 */
 __host__ Vector_List *createVectorList();

 /**
 * \fn  __host__ void addVector(Vector_List *list, const int *vec, int size) 
 * \brief Ajoute un vecteur à la liste de vecteurs
 * \param list Liste dans laquelle ajouter le vecteur
 * \param vec Le vecteur à ajouter à la liste
 * \param size Taille de la liste
 */
 __host__ void addVector(Vector_List *list, const int *vec, int size);

 /**
 * \fn  __host__ int *getVector(const Vector_List list, int index)
 * \brief Accesseur : Récupère un vecteur dans la liste
 * \param list Liste de vecteurs
 * \param index Index du vecteur dans la liste
 * \param NULL : L'index n'est pas dans la liste | Le vecteur correspondant 
 */
 __host__ int *getVector(const Vector_List list, int index);

 /**
 * \fn  __host__ int *getVector(const Vector_List list, int index)
 * \brief Accesseur : Récupère un vecteur dans la liste
 * \param list Liste de vecteurs
 * \param index Index du vecteur dans la liste
 * \param NULL : L'index n'est pas dans la liste | Le vecteur correspondant 
 */
 __host__ void removeLastVector(Vector_List *list);

 /**
 * \fn  __host__ void resetVectorList(Vector_List *list)
 * \brief Efface et libère la liste de vecteurs
 * \param list Liste à effacer et à libérer
 */
 __host__ void resetVectorList(Vector_List *list);

 /**
 * \fn  __host__ int isNullVector(int *vec, int size)
 * \brief Vérifie si un vecteur est nul 
 * \param vec Vecteur à évaluer
 * \param size Taille du vecteur
 * \return 0 : le vecteur est nul | 1 : le vecteur n'est pas nul 
 */ 
 __host__ int isNullVector(int *vec, int size);

#endif /* VECTOR_H_ */
