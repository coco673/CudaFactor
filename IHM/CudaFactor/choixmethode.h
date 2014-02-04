#ifndef CHOIXMETHODE_H
#define CHOIXMETHODE_H

#include"modelchoixmethode.h"
#include <QPushButton>
#include <QFrame>

class ChoixMethode: public QFrame
{
    Q_OBJECT

public:
    ChoixMethode(ModelChoixMethode *m);

public slots:
    void pressCUDA();
    void pressSAGE();

private:
    ModelChoixMethode * model;
    QPushButton * cudaButton;
    QPushButton * sageButton;

};

#endif // CHOIXMETHODE_H
