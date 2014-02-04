#ifndef MODEL_H
#define MODEL_H

#include "choixnombre.h"
#include "choixmethode.h"
#include "attente.h"
#include "resultat.h"
#include "modelchoixnombre.h"
#include "modelchoixmethode.h"
#include "modelattente.h"
#include "modelresultat.h"

#include <QList>

class Model
{
public:
    Model();
    int getPage();
    QFrame * getFrameCourante();
    void pagePrec();
    void pageSuiv();
    QList<QFrame *> getListeFrames();
    ChoixNombre getChoixNombre();
    ChoixMethode getChoixMethode();
    Attente getAttente();
    Resultat getResultat();
    ModelChoixNombre getModelChoixNombre();
    ModelChoixMethode getModelChoixMethode();
    ModelAttente getModelAttente();
    ModelResultat getModelResultat();

private:
    int page;
    ChoixNombre * choixNombre;
    ChoixMethode * choixMethode;
    Attente * attente;
    Resultat * resultat;
    ModelChoixNombre * modelChoixNombre;
    ModelChoixMethode * modelChoixMethode;
    ModelAttente * modelAttente;
    ModelResultat * modelResultat;
    QList<QFrame *> listFrames;


};

#endif // MODEL_H
