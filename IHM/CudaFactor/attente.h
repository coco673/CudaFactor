#ifndef ATTENTE_H
#define ATTENTE_H

#include "model.h"
#include "Frame.h"
#include <QLabel>

class Attente: public Frame
{
    Q_OBJECT
public:
    Attente(Model *m);
    void actualiser();
    bool boutonSuivant();
    void check();

private:
    Model * model;
    QLabel * label;


};

#endif // ATTENTE_H
