#ifndef ATTENTE_H
#define ATTENTE_H

#include "model.h"
#include <QFrame>

class Attente: public QFrame
{
public:
    Attente(Model *m);
    void actualiser();

private:
    Model * model;

};

#endif // ATTENTE_H
