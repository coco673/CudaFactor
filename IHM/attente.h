/*
 * Frame permettant à l'utilisateur d'exécuter l'algorithme
 */

#ifndef ATTENTE_H
#define ATTENTE_H

#include "model.h"
#include "Frame.h"
#include <QLabel>
#include <QTextEdit>
#include <QPushButton>

class Attente: public Frame
{
    Q_OBJECT
public:
    Attente(Model *m);
    void actualiser();
    bool boutonSuivant();
    void check();
    void actualiseApresAffichage();
    void execSAGE();
    void execCUDA();

public slots :
    void lancerExec();

private:
    Model * model;
    QLabel * label;
    QTextEdit * text;
    bool boolBoutonSuiv;
    QPushButton * execButton;

};

#endif // ATTENTE_H
