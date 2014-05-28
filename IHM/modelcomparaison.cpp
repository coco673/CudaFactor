#include "modelcomparaison.h"

// Initialisation de la Frame
modelComparaison::modelComparaison()
{
    xml1 = "";
    xml2 = "";
}

//Retourne le chemin courant du rapport n°1
QString modelComparaison::getXML1() {
    return xml1;
}

//Retourne le chemin courant du rapport n°2
QString modelComparaison::getXML2() {
    return xml2;
}

//Change le chemin courant du rapport n°1
void modelComparaison::setXML1(QString s) {
    xml1 = s;
}

//Change le chemin courant du rapport n°2
void modelComparaison::setXML2(QString s) {
    xml2 = s;
}

//Réinitialise le model de comparaison
void modelComparaison::reinitialiser() {
    xml1 = "";
    xml2 = "";
}
