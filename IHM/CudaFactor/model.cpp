#include "model.h"

Model::Model()
{
    page = 0;

    //Initialisation des models
    modelChoixNombre = new ModelChoixNombre();
    modelChoixMethode = new ModelChoixMethode();
    modelAttente = new ModelAttente();
    modelResultat = new ModelResultat();

    //Initialisation des QFrames
    choixNombre = new ChoixNombre(modelChoixNombre);
    choixMethode = new ChoixMethode(modelChoixMethode);
    attente = new Attente(modelAttente);
    resultat = new Resultat(modelResultat);

    listFrames.append(choixNombre);
    listFrames.append(choixMethode);
    listFrames.append(attente);
    listFrames.append(resultat);
}

int Model::getPage(){
    return page;
}

QFrame * Model::getFrameCourante() {
    return listFrames[page];
}

QList<QFrame *> Model::getListeFrames() {
    return listFrames;
}

ChoixNombre Model::getChoixNombre() {
    return choixNombre;
}

ChoixMethode Model::getChoixMethode() {
    return choixMethode;
}

Attente Model::getAttente() {
    return attente;
}

Resultat Model::getResultat() {
    return resultat;
}

ModelChoixNombre Model::getModelChoixNombre() {
    return modelChoixNombre;
}

ModelChoixMethode Model::getModelChoixMethode() {
    return modelChoixMethode;
}

ModelAttente Model::getModelAttente() {
    return modelAttente;
}

ModelResultat Model::getModelResultat() {
    return modelResultat;
}

void Model::pagePrec() {
    if (page < 1) {
        page = 0;
    } else {
        page--;
    }
}

void Model::pageSuiv() {
    if (page >= listFrames.size()-1) {
        page = 0;
    } else {
        page++;
    }
}
