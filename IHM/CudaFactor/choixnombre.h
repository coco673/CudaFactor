#ifndef CHOIXNOMBRE_H
#define CHOIXNOMBRE_H

#include <QFrame>
#include "model.h"

class ChoixNombre : public QFrame {
public:
    ChoixNombre(Model *m);
    void actualiser(); //actualiser le texte de la zone de texte avec le model

private:
    Model * model;
};

#endif // CHOIXNOMBRE_H
