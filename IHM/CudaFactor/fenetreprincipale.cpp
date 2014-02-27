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

    suivantIcon = new QIcon("images/boutonSuivant.png");
    precedentIcon = new QIcon("images/boutonRetour.png");
    bulleIcon = new QPixmap("images/bulle.png");

    suivant = new QPushButton(this);
    precedent = new QPushButton(this);

    suivant->setFixedSize(50, 50);
    suivant->move(700, 500);
    suivant->setCursor(Qt::PointingHandCursor);
    suivant->raise(); //au premier plan
    suivant->setIcon(*suivantIcon);
    suivant->setIconSize(QSize(100, 100));

    precedent->setFixedSize(50, 50);
    precedent->move(30, 500);
    precedent->setCursor(Qt::PointingHandCursor);
    precedent->raise(); //au premier plan
    precedent->setIcon(*precedentIcon);
    precedent->setIconSize(QSize(100, 100));

    bulle = new QLabel(this);
    bulle->setPixmap(*bulleIcon);
    bulle->move(560, 400);
    //bulle->move(700-1.5*bulle->size().width(), 500-3.5*bulle->size().height());
    bulle->hide();

    model->reinitialiser();

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
        if (model->getNombre() != 0) {
            bulle->hide();
            page++;
        } else {
            bulle->show();
        }
    }
    if (page == 3) {
        resultat->actualiser();
    }
    listFrames[page]->show();
}
