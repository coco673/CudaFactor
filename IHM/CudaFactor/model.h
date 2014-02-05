#ifndef MODEL_H
#define MODEL_H

#include <QList>

#define CUDA 0
#define SAGE 1

class Model
{
public:
    Model();
    void reinitialiser();
    int getMethode();
    void setMethode(int m);
    long double getNombre();
    void setNombre(long double);
    QList<long double> getListFacteursPremiers();
    void setListFacteursPremiers(QList<long double> l);
    int getTempsExecution();
    void setTempsExecution(int t);

private:
    int methode;
    long double nombre;
    QList<long double> listFacteursPremiers;
    int temps;

};

#endif // MODEL_H
