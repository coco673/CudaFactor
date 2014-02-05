#ifndef RESULTAT_H
#define RESULTAT_H

#include "model.h"
#include <QFrame>

class Resultat: public QFrame
{
public:
    Resultat(Model *m);
    void actualiser();

private:
    Model * model;

};

#endif // RESULTAT_H
