#ifndef ATTENTE_H
#define ATTENTE_H

#include "modelattente.h"
#include <QFrame>

class Attente: public QFrame
{
public:
    Attente(ModelAttente *m);

private:
    ModelAttente * model;

};

#endif // ATTENTE_H
