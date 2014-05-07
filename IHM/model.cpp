#include "model.h"
#include <gmpxx.h>
Model::Model()
{
    methode = CUDA;
    nombre = 0;
    temps = -1;
}

int Model::getMethode() {
    return methode;
}

/*long double Model::getNombre() {
    return nombre;
}*/
mpz_class Model::getNombre() {
    return nombre;
}

QList<long double> Model::getListFacteursPremiers() {
    return listFacteursPremiers;
}

double Model::getTempsExecution() {
    return temps;
}

void Model::setMethode(int m) {
    methode = m;
}

void Model::setNombre(mpz_class n) {
    nombre = n;
}

void Model::setListFacteursPremiers(QList<long double> l) {
    listFacteursPremiers = l;
}

void Model::setTempsExecution(double t) {
    temps = t;
}

QString Model::getTitre() {
    return titre;
}

void Model::setTitre(QString titre) {
    this->titre = titre;
}

void Model::reinitialiser() {
    methode = CUDA;
    nombre = 0;
    temps = 0;
    listFacteursPremiers.clear();
}
