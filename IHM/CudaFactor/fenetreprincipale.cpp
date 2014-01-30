#include "fenetreprincipale.h"
#include "choixmethodeexecution.h"
#include "choixnombre.h"
#include "attente.h"
#include "resultat.h"

FenetrePrincipale::FenetrePrincipale()
{

    //Taille de la fenetre
    setFixedSize(800, 600);

    //page actuellement visualisée

    page = 1;

    // Construction de la frame visible

    frame = new ChoixNombre();
    frame->setParent(this);
    frame->setFixedSize(800, 600);
    frame->show();

    // Construction des boutons

    suivant = new QPushButton("Suivant", this);
    precedent = new QPushButton("Précédent", this);

    suivant->setFixedSize(70, 70);
    suivant->setFixedSize(70, 70);
    suivant->move(700, 500);
    suivant->setCursor(Qt::PointingHandCursor);
    suivant->raise(); //au premier plan

    precedent->setFixedSize(70, 70);
    precedent->setFixedSize(70, 70);
    precedent->move(30, 500);
    precedent->setCursor(Qt::PointingHandCursor);
    precedent->raise(); //au premier plan
    precedent->setVisible(false);
    //m_c1->setStyleSheet("border:10px; background-color:red;");


    //Connection SLOTS-SIGNAUX
    QObject::connect(suivant, SIGNAL(clicked()), this, SLOT(next()));
    QObject::connect(precedent, SIGNAL(clicked()), this, SLOT(prev()));
    //QObject::connect(m_c1, SIGNAL(clicked()), qApp, SLOT(quit()));
}

void FenetrePrincipale::prev()
{
    page--;
    if (page < 0) {
        page = 1;
    }
    if (page == 2) {
        frame = new ChoixMethodeExecution();
        precedent->setVisible(true);
    } else if (page == 3) {
        frame = new Attente();
        precedent->setVisible(true);
    } else if (page == 4) {
        frame = new Resultat();
        precedent->setVisible(true);
    } else { // page = 1
        frame = new ChoixNombre();
        precedent->setVisible(false);
    }
    frame->setParent(this);
    frame->setFixedSize(800, 600);
    suivant->raise();
    precedent->raise();
    frame->show();
}

void FenetrePrincipale::next()
{
    page++;
    if (page > 4) {
        page = 1;
    }
    if (page == 2) {
        frame = new ChoixMethodeExecution();
        precedent->setVisible(true);
    } else if (page == 3) {
        frame = new Attente();
        precedent->setVisible(true);
    } else if (page == 4) {
        frame = new Resultat();
        precedent->setVisible(true);
    } else { // page = 1
        frame = new ChoixNombre();
        precedent->setVisible(false);
    }
    frame->setParent(this);
    frame->setFixedSize(800, 600);
    suivant->raise();
    precedent->raise();
    frame->show();
}
