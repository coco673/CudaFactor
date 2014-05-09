#include "model.h"
#include <gmpxx.h>

// Initialisation de la Frame
Model::Model()
{
    methode = CUDA;
    nombre = 0;
    temps = -1;
}

//Retourne la méthode d'exécution
int Model::getMethode() {
    return methode;
}

//Retourne le nombre à factoriser
mpz_class Model::getNombre() {
    return nombre;
}

//Retourne la liste des facteurs premiers
QList<mpz_class> Model::getListFacteursPremiers() {
    return listFacteursPremiers;
}

//Retourne le temps d'exécution
double Model::getTempsExecution() {
    return temps;
}

//Change la méthode d'exécution
void Model::setMethode(int m) {
    methode = m;
}

//Change le nombre à factoriser
void Model::setNombre(mpz_class n) {
    if (n == 0 || n == NULL)
        nombre = 0;
    else
        nombre = n;
}

//Change la liste des facteurs premiers
void Model::setListFacteursPremiers(QList<mpz_class> l) {
    listFacteursPremiers = l;
}

//Change le temps d'exécution
void Model::setTempsExecution(double t) {
    temps = t;
}

//Retourne le titre du rapport
QString Model::getTitre() {
    return titre;
}

//Change le titre du rapport
void Model::setTitre(QString titre) {
    this->titre = titre;
}

//Réinitialise le model
void Model::reinitialiser() {
    methode = CUDA;
    nombre = 0;
    temps = 0;
    listFacteursPremiers.clear();
}
