#ifndef MODEL_H
#define MODEL_H

#include <QList>
#include <QString>
#include <gmpxx.h>

#define CUDA 0
#define SAGE 1

class Model
{
public:
    Model();
    void reinitialiser();
    int getMethode();
    void setMethode(int m);
    //long double getNombre();
    mpz_class getNombre();
    //void setNombre(long double);
    void setNombre(mpz_class);
    QList<long double> getListFacteursPremiers();
    void setListFacteursPremiers(QList<long double> l);
    double getTempsExecution();
    void setTempsExecution(double t);
    QString getTitre();
    void setTitre(QString titre);

private:
    int methode;
    //long double nombre;
    mpz_class nombre;
    QList<long double> listFacteursPremiers;
    double temps;
    QString titre;

};

#endif // MODEL_H
