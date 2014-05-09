/*
 * Widget principale permettant de changer de fenetre
 */

#ifndef FENETREPRINCIPALE_H
#define FENETREPRINCIPALE_H

#include <QPushButton>
#include <QLabel>

#include "modelfenprinc.h"

#include "choixnombre.h"
#include "choixmethode.h"
#include "attente.h"
#include "resultat.h"
#include "comparaisonxml.h"
#include "choixcompa_facto.h"

class FenetrePrincipale: public QWidget {

    Q_OBJECT

public:
    FenetrePrincipale();
    ModelFenPrinc* getModelFenPrinc();
    Frame * getFrameCourante();
    choixCompa_facto* getChoixCompFact();
    ChoixNombre* getChoixNombre();
    ChoixMethode* getChoixMethode();
    Attente* getAttente();
    Resultat* getResultat();
    comparaisonXml* getComparaisonXml();
    QList<Frame *> getListeFramesAvant();
    QList<Frame *> getListeFramesFact();
    QList<Frame *> getListeFramesComp();

public slots:
    void next();
    void prev();

private:
    QPushButton * precedent;
    QPushButton * suivant;
    QIcon * suivantIcon;
    QIcon * precedentIcon;
    QPixmap * bulleIcon;
    QLabel * bulle;
    ModelFenPrinc * modelFen;
    choixCompa_facto * choixCompFact;
    ChoixNombre * choixNombre;
    ChoixMethode * choixMethode;
    Attente * attente;
    Resultat * resultat;
    comparaisonXml* compXml;
    QList<Frame *> listFramesAvant;
    QList<Frame *> listFramesFact;
    QList<Frame *> listFramesComp;

};

#endif // FENETREPRINCIPALE_H
