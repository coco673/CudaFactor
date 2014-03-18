#ifndef MODELCOMPARAISON_H
#define MODELCOMPARAISON_H

#include <QString>

#define factorisation 0
#define Comparaison 1

class modelComparaison
{
public:
    modelComparaison();
    QString getXML1();
    QString getXML2();
    void setXML1(QString s);
    void setXML2(QString s);
    void reinitialiser();

private :
    QString xml1;
    QString xml2;
};

#endif // MODELCOMPARAISON_H
