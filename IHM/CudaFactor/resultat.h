#ifndef RESULTAT_H
#define RESULTAT_H

#include "modelresultat.h"
#include <QFrame>

class Resultat: public QFrame
{
public:
    Resultat(ModelResultat *m);

private:
    ModelResultat * model;

};

#endif // RESULTAT_H
