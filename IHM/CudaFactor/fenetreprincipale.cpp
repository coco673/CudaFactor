#include "fenetreprincipale.h"

FenetrePrincipale::FenetrePrincipale() {
    // Initialisation du model
    model = new Model();

    // Construction de la frame visible
    for (int i = 0; i < model->getListeFrames().size(); i++) {
        (model->getListeFrames()[i])->setParent(this);
        (model->getListeFrames()[i])->setFixedSize(800, 600);
        (model->getListeFrames()[i])->hide();
    }

    model->getFrameCourante()->show();

    // Construction des boutons

    suivant = new QPushButton("Suivant", this);
    precedent = new QPushButton("Précédent", this);

    suivant->setFixedSize(70, 70);
    suivant->move(700, 500);
    suivant->setCursor(Qt::PointingHandCursor);
    suivant->raise(); //au premier plan

    precedent->setFixedSize(70, 70);
    precedent->move(30, 500);
    precedent->setCursor(Qt::PointingHandCursor);
    precedent->raise(); //au premier plan

    //Connection SLOTS-SIGNAUX
    QObject::connect(suivant, SIGNAL(clicked()), this, SLOT(next()));
    QObject::connect(precedent, SIGNAL(clicked()), this, SLOT(prev()));

}

void FenetrePrincipale::prev() {
    model->getFrameCourante()->hide();
    model->pagePrec();
    model->getFrameCourante()->show();
}

void FenetrePrincipale::next() {
    model->getFrameCourante()->hide();
    model->pageSuiv();
    model->getFrameCourante()->show();
}
