#ifndef CHOIXNOMBRE_H
#define CHOIXNOMBRE_H

#include <QFrame>
#include "modelchoixnombre.h"

class ChoixNombre : public QFrame {
public:
    ChoixNombre(ModelChoixNombre *m);

private:
    ModelChoixNombre * model;
};

#endif // CHOIXNOMBRE_H
