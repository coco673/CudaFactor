#include "fenetreprincipale.h"

FenetrePrincipale::FenetrePrincipale() {
    // Initialisation du model
    model = new Model();

    page = 0;

    //Initialisation des QFrames

    choixNombre = new ChoixNombre(model);
    choixMethode = new ChoixMethode(model);
    attente = new Attente(model);
    resultat = new Resultat(model);

    listFrames.append(choixNombre);
    listFrames.append(choixMethode);
    listFrames.append(attente);
    listFrames.append(resultat);


    // Construction de la frame visible
    for (int i = 0; i < listFrames.size(); i++) {
        (listFrames[i])->setParent(this);
        (listFrames[i])->setFixedSize(800, 600);
        (listFrames[i])->hide();
    }

    listFrames[page]->show();

    // Construction des boutons

    suivant = new QPushButton("Suivant", this);
    precedent = new QPushButton("Precedent", this);

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

int FenetrePrincipale::getPage(){
    return page;
}

QList<QFrame *> FenetrePrincipale::getListeFrames() {
    return listFrames;
}

ChoixNombre* FenetrePrincipale::getChoixNombre() {
    return choixNombre;
}

ChoixMethode* FenetrePrincipale::getChoixMethode() {
    return choixMethode;
}

Attente* FenetrePrincipale::getAttente() {
    return attente;
}

Resultat* FenetrePrincipale::getResultat() {
    return resultat;
}

void FenetrePrincipale::prev() {
    listFrames[page]->hide();
    if (page < 1) {
        page = 0;
    } else {
        page--;
    }
    listFrames[page]->show();
}

void FenetrePrincipale::next() {
    listFrames[page]->hide();
    if (page >= listFrames.size()-1) {
        page = 0;
        model->reinitialiser();
        choixNombre->actualiser();
        choixMethode->actualiser();
        attente->actualiser();
        resultat->actualiser();
    } else {
        page++;
    }
    listFrames[page]->show();
}
