#ifndef MODELFENPRINC_H
#define MODELFENPRINC_H

#include <QList>
#include <QPushButton>
#include <QLabel>
#include "Frame.h"
#include "model.h"
#include "modelcomparaison.h"

class ModelFenPrinc
{
public:
    ModelFenPrinc(Model* mod,
                  modelComparaison* modComp,
                  int* chxCompFact,
                  QPushButton * prec,
                  QPushButton * suiv,
                  QList<Frame *> listAv,
                  QList<Frame *> listfact,
                  QList<Frame *> listComp,
                  QLabel * bulleInfo);
    Model* getModel();
    modelComparaison* getModelComp();
    void initLists(QList<Frame *> listAv, QList<Frame *> listFact, QList<Frame *> listComp);
    int getPage();
    int getChxCompFact();
    void prev();
    void next();
    void reinitialiser();

private :
    Model * model;
    modelComparaison * modelComp;
    int page;
    QList<Frame *> listFramesAvant;
    QList<Frame *> listFramesFact;
    QList<Frame *> listFramesComp;
    int* chxCompFact;
    QLabel* bulle;
    QPushButton * suivant;
    QPushButton * precedent;

};

#endif // MODELFENPRINC_H
