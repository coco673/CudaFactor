#ifndef CHOIXCOMPA_FACTO_H
#define CHOIXCOMPA_FACTO_H

#include <QPushButton>
#include <QLabel>
#include "Frame.h"
#include "modelfenprinc.h"

#define factorisation 0
#define Comparaison 1

class choixCompa_facto: public Frame
{
    Q_OBJECT

public:
    choixCompa_facto(int* chx, ModelFenPrinc* m);
    void actualiser();
    bool boutonSuivant();
    void check();
    void actualiseAprèsAffichage();

public slots:
    void pressFact();
    void pressComp();

private:
    QLabel * label;
    QIcon * FactIcon;
    QIcon * CompIcon;
    QPushButton * FactButton;
    QPushButton * CompButton;
    int* chxCompFact;
    QPushButton* suivant;
    ModelFenPrinc* model;
};

#endif // CHOIXCOMPA_FACTO_H
