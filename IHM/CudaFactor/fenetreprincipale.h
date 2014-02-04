#ifndef FENETREPRINCIPALE_H
#define FENETREPRINCIPALE_H

#include <QFrame>
#include "model.h"
#include <QPushButton>


class FenetrePrincipale: public QWidget {

    Q_OBJECT

public:
    FenetrePrincipale();
    Model getModel();

public slots:
    void next();
    void prev();

private:
    QPushButton * precedent;
    QPushButton * suivant;
    Model * model;
};

#endif // FENETREPRINCIPALE_H
