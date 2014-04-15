#ifndef ATTENTE_H
#define ATTENTE_H

#include "model.h"
#include "Frame.h"
#include <QLabel>
#include <QTextEdit>

class Attente: public Frame
{
    Q_OBJECT
public:
    Attente(Model *m);
    void actualiser();
    bool boutonSuivant();
    void check();
    void actualiseAprèsAffichage();

private:
    Model * model;
    QLabel * label;
    QTextEdit * text;
    bool boolBoutonSuiv;

};

#endif // ATTENTE_H
