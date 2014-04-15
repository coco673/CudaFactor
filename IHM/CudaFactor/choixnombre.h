#ifndef CHOIXNOMBRE_H
#define CHOIXNOMBRE_H

#include <QTextEdit>
#include <QRadioButton>
#include <QLabel>
#include "model.h"
#include "Frame.h"

class ChoixNombre: public Frame
{
    Q_OBJECT

public:
    ChoixNombre(Model *m);
    void actualiser();
    bool boutonSuivant();
    void check();
    void actualiseAprèsAffichage();

private slots:
    void boutonClique();

private:
    Model * model;
    QLabel * label;
    QTextEdit * nombre;
    QRadioButton * decimal;
    QRadioButton * binaire;
    QRadioButton * hexa;
};

#endif // CHOIXNOMBRE_H
