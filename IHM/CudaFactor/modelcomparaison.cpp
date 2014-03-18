#include "modelcomparaison.h"

modelComparaison::modelComparaison()
{
    xml1 = "";
    xml2 = "";
}

QString modelComparaison::getXML1() {
    return xml1;
}

QString modelComparaison::getXML2() {
    return xml2;
}

void modelComparaison::setXML1(QString s) {
    xml1 = s;
}

void modelComparaison::setXML2(QString s) {
    xml2 = s;
}

void modelComparaison::reinitialiser() {
    xml1 = "";
    xml2 = "";
}
