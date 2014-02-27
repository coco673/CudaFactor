#ifndef FENETREPRINCIPALE_H
#define FENETREPRINCIPALE_H

#include <QFrame>
#include <QList>
#include <QPushButton>
#include <QLabel>

#include "model.h"
#include "choixnombre.h"
#include "choixmethode.h"
#include "attente.h"
#include "resultat.h"


class FenetrePrincipale: public QWidget {

    Q_OBJECT

public:
    FenetrePrincipale();
    Model getModel();
    int getPage();
    QFrame * getFrameCourante();
    QList<QFrame *> getListeFrames();
    ChoixNombre* getChoixNombre();
    ChoixMethode* getChoixMethode();
    Attente* getAttente();
    Resultat* getResultat();

public slots:
    void next();
    void prev();

private:
    void foo();
    QPushButton * precedent;
    QPushButton * suivant;
    QIcon * suivantIcon;
    QIcon * precedentIcon;
    QPixmap * bulleIcon;
    QLabel * bulle;
    Model * model;
    int page;
    ChoixNombre * choixNombre;
    ChoixMethode * choixMethode;
    Attente * attente;
    Resultat * resultat;
    QList<QFrame *> listFrames;
};

#endif // FENETREPRINCIPALE_H
