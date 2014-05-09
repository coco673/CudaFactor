/*
 * Frame permettant à l'utilisateur de choisir si il veut factoriser le nombre sous Sage ou sous Cuda
 */

#ifndef CHOIXMETHODE_H
#define CHOIXMETHODE_H

#include "model.h"
#include "Frame.h"
#include "modelfenprinc.h"
#include <QPushButton>
#include <QLabel>

class ChoixMethode: public Frame
{
    Q_OBJECT

public:
    ChoixMethode(Model *m, ModelFenPrinc *mfp);
    void actualiser();
    bool boutonSuivant();
    void check();
    void actualiseApresAffichage();

public slots:
    void pressCUDA();
    void pressSAGE();

private:
    Model * model;
    ModelFenPrinc* modelFen;
    QLabel * label;
    QIcon * cudaIcon;
    QIcon * sageIcon;
    QPushButton * cudaButton;
    QPushButton * sageButton;

};

#endif // CHOIXMETHODE_H
