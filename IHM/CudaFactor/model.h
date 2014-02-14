#ifndef MODEL_H
#define MODEL_H

#include <QList>
#include <QString>

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
    int getNbreInstruction();
    double getNbreInstrParSec();
    void setNbreInstruction(int nbrInstruction);
    QString getTitre();
    void setTitre(QString titre);

private:
    int methode;
    long double nombre;
    QList<long double> listFacteursPremiers;
    int temps;
    QString titre;
    int nbre_instructions;

};

#endif // MODEL_H
