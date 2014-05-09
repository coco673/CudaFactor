/**
 * \file coupleList.cu
 * \brief Suite d'outils nécéssaires à la gestion des couples pour la construction de l'ensemble R
 */

#ifndef _COUPLELIST_H
#define _COUPLELIST_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "ensemble.h"

 /**
  * \fn __host__ Couple_List *createCoupleList() 
  * \brief Initialise une liste de couple
  * \return list : le pointeur sur la liste de couple initialisée
  */
 __host__ Couple_List *createCoupleList();

  /**
  * \fn  __host__ void addCouple(Couple_List *list, const Couple c) 
  * \brief Ajoute un couple à la liste
  * \param list Liste dans laquelle ajouter le couple
  * \param c Couple à ajouter à la liste
  */
 __host__ void addCouple(Couple_List *list, Couple c);

  /**
  * \fn  __host__ Couple getCouple(const Couple_List list, int index) 
  * \brief Accesseur pour accéder à un couple dans la liste
  * \param list Liste où est contenu le couple
  * \param index Position du couple dans la liste
  * \return tmp.list->c : Le couple demandé | error : Le couple n'est pas dans la liste
  */
 __host__ Couple getCouple(const Couple_List list, int index);
 
 /**
  * \fn  __host__ void removeLastCouple(Couple_List *list) 
  * \brief Efface le dernier couple dans la liste
  * \param list Liste dans laquelle effectuer l'opération
  */
 __host__ void removeLastCouple(Couple_List *list);

  /**
  * \fn  __host__ void resetCoupleList(Couple_List *list) 
  * \brief Efface et libère la liste de couples passée en paramètre
  * \param list Liste à effacer
  */
 __host__ void resetCoupleList(Couple_List *list);

  /**
  * \fn void printCouple(Couple c) 
  * \brief Affiche le couple passé en paramètre
  * \param c Couple à print
  */
void printCouple(Couple c);

 /**
  * \fn void printCoupleList(const Couple_List list) 
  * \brief Affiche la liste des couples passée en paramètre
  * \param list Liste des couples à afficher
  */
void printCoupleList(const Couple_List list);

#endif
