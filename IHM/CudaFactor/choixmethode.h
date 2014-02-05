#ifndef CHOIXMETHODE_H
#define CHOIXMETHODE_H

#include"model.h"
#include <QPushButton>
#include <QFrame>

class ChoixMethode: public QFrame
{
    Q_OBJECT

public:
    ChoixMethode(Model *m);

public slots:
    void pressCUDA();
    void pressSAGE();
    void actualiser();

private:
    Model * model;
    QPushButton * cudaButton;
    QPushButton * sageButton;

};

#endif // CHOIXMETHODE_H
