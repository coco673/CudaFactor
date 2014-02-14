#ifndef CHOIXNOMBRE_H
#define CHOIXNOMBRE_H

#include <QFrame>
#include <QTextEdit>
#include <QRadioButton>
#include <QLabel>
#include "model.h"

class ChoixNombre: public QFrame
{
    Q_OBJECT

public:
    ChoixNombre(Model *m);
    void actualiser();

private slots:
    void changerNombre();
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
