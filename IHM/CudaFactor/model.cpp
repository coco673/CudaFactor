#include "model.h"

Model::Model()
{
    methode = CUDA;
    nombre = 0;
    temps = -1;
}

int Model::getMethode() {
    return methode;
}

long double Model::getNombre() {
    return nombre;
}

QList<long double> Model::getListFacteursPremiers() {
    return listFacteursPremiers;
}

int Model::getTempsExecution() {
    return temps;
}

void Model::setMethode(int m) {
    methode = m;
}

void Model::setNombre(long double n) {
    nombre = n;
}

void Model::setListFacteursPremiers(QList<long double> l) {
    listFacteursPremiers = l;
}

void Model::setTempsExecution(int t) {
    temps = t;
}

void Model::reinitialiser() {
    methode = CUDA;
    nombre = 0;
    temps = -1;
    listFacteursPremiers.clear();
}
