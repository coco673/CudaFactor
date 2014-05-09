#include "fenetreprincipale.h"

// Initialisation de la Frame
FenetrePrincipale::FenetrePrincipale() {

    suivant = new QPushButton(this);
    precedent = new QPushButton(this);

    // Construction des boutons

    suivantIcon = new QIcon("images/boutonSuivant.png");
    precedentIcon = new QIcon("images/boutonRetour.png");
    bulleIcon = new QPixmap("images/bulle.png");

    suivant->setFixedSize(50, 50);
    suivant->move(700, 500);
    suivant->setCursor(Qt::PointingHandCursor);
    suivant->setIcon(*suivantIcon);
    suivant->setIconSize(QSize(100, 100));

    precedent->setFixedSize(50, 50);
    precedent->move(30, 500);
    precedent->setCursor(Qt::PointingHandCursor);
    precedent->setIcon(*precedentIcon);
    precedent->setIconSize(QSize(100, 100));
    precedent->hide();

    bulle = new QLabel(this);
    bulle->setPixmap(*bulleIcon);
    bulle->move(560, 400);
    //bulle->move(700-1.5*bulle->size().width(), 500-3.5*bulle->size().height());
    bulle->hide();

    int* chxCompFact;
    chxCompFact = (int*)malloc(sizeof(int));
    *chxCompFact = factorisation;

    Model* model = new Model();
    modelComparaison* modelComp = new modelComparaison();

    modelFen = new ModelFenPrinc(model,
                                 modelComp,
                                 chxCompFact,
                                 precedent,
                                 suivant,
                                 listFramesAvant,
                                 listFramesFact,
                                 listFramesComp,
                                 bulle);

    choixNombre = new ChoixNombre(model);
    choixMethode = new ChoixMethode(model, modelFen);
    attente = new Attente(model);
    resultat = new Resultat(model);

    compXml = new comparaisonXml(modelComp);

    listFramesFact.append(choixNombre);
    listFramesFact.append(choixMethode);
    listFramesFact.append(attente);
    listFramesFact.append(resultat);

    listFramesComp.append(compXml);

    for (int i = 0; i < listFramesFact.size(); i++) {
        (listFramesFact[i])->setParent(this);
        (listFramesFact[i])->setFixedSize(800, 600);
        (listFramesFact[i])->hide();
    }

    for (int i = 0; i < listFramesComp.size(); i++) {
        (listFramesComp[i])->setParent(this);
        (listFramesComp[i])->setFixedSize(800, 600);
        (listFramesComp[i])->hide();
    }

    choixCompFact = new choixCompa_facto(chxCompFact, modelFen);

    listFramesAvant.append(choixCompFact);

    for (int i = 0; i < listFramesAvant.size(); i++) {
        (listFramesAvant[i])->setParent(this);
        (listFramesAvant[i])->setFixedSize(800, 600);
        (listFramesAvant[i])->hide();
    }

    modelFen->initLists(listFramesAvant, listFramesFact, listFramesComp);
    modelFen->reinitialiser();

    listFramesAvant[0]->show();

    suivant->raise(); //au premier plan
    precedent->raise(); //au premier plan
    bulle->raise(); //au premier plan

    if (choixCompFact->boutonSuivant() == true) {
        suivant->show();
    } else {
        suivant->hide();
    }
    //Connection SLOTS-SIGNAUX
    QObject::connect(suivant, SIGNAL(clicked()), this, SLOT(next()));
    QObject::connect(precedent, SIGNAL(clicked()), this, SLOT(prev()));

}

//Retourne le modèle de la fenetre principale
ModelFenPrinc* FenetrePrincipale::getModelFenPrinc() {
    return modelFen;
}

//Retourne la frame show
Frame * FenetrePrincipale::getFrameCourante() {
    if (modelFen->getPage() < listFramesAvant.size()) {
        return listFramesAvant[modelFen->getPage()];
    } else if (modelFen->getChxCompFact() == factorisation) {
        return listFramesFact[modelFen->getPage()-listFramesAvant.size()];
    } else if (modelFen->getChxCompFact() == Comparaison){
        return listFramesComp[modelFen->getPage()-listFramesAvant.size()];
    } else {
        return NULL;
    }
}

//Retourne la liste des fenêtres affichées avant que l'utilisateur
//puisse choisir si il souhaite comparer deux rapports ou factoriser un nombre
QList<Frame *> FenetrePrincipale::getListeFramesAvant() {
    return listFramesAvant;
}

//Retourne la liste des fenêtres permettant la factorisation du nombre
QList<Frame *> FenetrePrincipale::getListeFramesFact() {
    return listFramesFact;
}

//Retourne la liste des fenêtres permettant la comparaison du nombre
QList<Frame *> FenetrePrincipale::getListeFramesComp() {
    return listFramesComp;
}

//Retourne la fenêtre permettant à l'utilisateur de choisir si il souhaite factoriser un nombre ou comparer deux rapports
choixCompa_facto* FenetrePrincipale::getChoixCompFact() {
    return choixCompFact;
}

//Retourne la fenêtre permettant à l'utilisateur de rentrer son nombre
ChoixNombre* FenetrePrincipale::getChoixNombre() {
    return choixNombre;
}

//Retourne la fenêtre permettant à l'utilisateur de choisir la langage sous lequel l'algorithme sera exécuté (Sage ou Cuda)
ChoixMethode* FenetrePrincipale::getChoixMethode() {
    return choixMethode;
}

//Retourne la fenêtre permettant à l'utilisateur de lancer l'exécution
Attente* FenetrePrincipale::getAttente() {
    return attente;
}

//Retourne la fenêtre permettant à l'utilisateur de visualiser et d'enregistrer le rapport d'exécution
Resultat* FenetrePrincipale::getResultat() {
    return resultat;
}

//Retourne la fenêtre permettant à l'utilisateur de comparer deux rapports
comparaisonXml* FenetrePrincipale::getComparaisonXml() {
    return compXml;
}

//Permet de revenir à la fenêtre précédente
void FenetrePrincipale::prev() {
    modelFen->prev();
}

//Permet de passer à la fenêtre suivante
void FenetrePrincipale::next() {
    modelFen->next();
}
