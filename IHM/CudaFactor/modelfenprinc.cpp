#include "modelfenprinc.h"

ModelFenPrinc::ModelFenPrinc(Model* mod,
                             modelComparaison* modComp,
                             int* chx,
                             QPushButton * prec,
                             QPushButton * suiv,
                             QList<Frame *> listAv,
                             QList<Frame *> listfact,
                             QList<Frame *> listComp,
                             QLabel * bulleInfo) {

    precedent = prec;
    suivant = suiv;
    chxCompFact = chx;
    listFramesAvant = listAv;
    listFramesFact = listfact;
    listFramesComp = listComp;
    bulle = bulleInfo;

    // Initialisation des models
    model = mod;
    modelComp = modComp;

    page = 0;

    model->reinitialiser();
    modelComp->reinitialiser();

}

Model* ModelFenPrinc::getModel() {
    return model;
}

modelComparaison* ModelFenPrinc::getModelComp() {
    return modelComp;
}

void ModelFenPrinc::initLists(QList<Frame *> listAv, QList<Frame *> listFact, QList<Frame *> listComp) {
    listFramesAvant = listAv;
    listFramesFact = listFact;
    listFramesComp = listComp;
}

int ModelFenPrinc::getPage(){
    return page;
}

int ModelFenPrinc::getChxCompFact() {
    return *chxCompFact;
}

void ModelFenPrinc::prev() {
    bulle->hide();
    if (page < 1) {
        page = 0;
        if (listFramesAvant[page]->boutonSuivant() == true) {
            suivant->show();
        } else {
            suivant->hide();
        }
        listFramesAvant[page]->show();
    }
    else if (getChxCompFact() == factorisation) {
        listFramesFact[page-listFramesAvant.size()]->hide();
        page--;
        if (page < listFramesAvant.size()) {
            if (listFramesAvant[page]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesAvant[page]->show();
        } else {
            if (listFramesFact[page-listFramesAvant.size()]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesFact[page-listFramesAvant.size()]->show();
        }
    }
    else {
        listFramesComp[page-listFramesAvant.size()]->hide();
        page--;
        if (page < listFramesAvant.size()) {
            if (listFramesAvant[page]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesAvant[page]->show();
        } else {
            if (listFramesFact[page-listFramesAvant.size()]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesComp[page-listFramesAvant.size()]->show();
        }
    }
    if (page == 0) {
        precedent->hide();
    } else {
        precedent->show();
    }
}

void ModelFenPrinc::next() {
    bulle->hide();
    if (getChxCompFact() == factorisation) {
        if (page < listFramesAvant.size()) {
            listFramesAvant[page]->hide();
        } else {
            listFramesFact[page-listFramesAvant.size()]->hide();
        }
        if (page >= listFramesFact.size()+listFramesAvant.size()-1) {
            page = 0;
            model->reinitialiser();
        } else {
            if (page == listFramesAvant.size() && getChxCompFact() == factorisation) {
                listFramesFact[0]->check();
            }
            if (page == 0 || model->getNombre() != 0) {
                page++;
            } else {
                bulle->show();
            }
        }
        if (page < listFramesAvant.size()) {
            listFramesAvant[page]->actualiser();
            if (listFramesAvant[page]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesAvant[page]->show();
            listFramesAvant[page]->actualiseApresAffichage();
        } else {
            listFramesFact[page-listFramesAvant.size()]->actualiser();
            if (listFramesFact[page-listFramesAvant.size()]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesFact[page-listFramesAvant.size()]->show();
            listFramesFact[page]->actualiseApresAffichage();
        }
    } else {
        if (page < listFramesAvant.size()) {
            listFramesAvant[page]->hide();
        } else {
            listFramesComp[page-listFramesAvant.size()]->hide();
        }
        if (page >= listFramesComp.size()+listFramesAvant.size()-1) {
            page = 0;
            modelComp->reinitialiser();
        } else {
            page++;
        }
        if (page < listFramesAvant.size()) {
            listFramesAvant[page]->actualiser();
            if (listFramesAvant[page]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesAvant[page]->show();
            listFramesAvant[page]->actualiseApresAffichage();
        } else {
            listFramesComp[page-listFramesAvant.size()]->actualiser();
            if (listFramesFact[page-listFramesAvant.size()]->boutonSuivant() == true) {
                suivant->show();
            } else {
                suivant->hide();
            }
            listFramesComp[page-listFramesAvant.size()]->show();
            listFramesComp[page-listFramesAvant.size()]->actualiseApresAffichage();
        }
    }
    if (page == 0) {
        precedent->hide();
    } else {
        precedent->show();
    }
}

void ModelFenPrinc::reinitialiser() {
    model->reinitialiser();
    modelComp->reinitialiser();
}
