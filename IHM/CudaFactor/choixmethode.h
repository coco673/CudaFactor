#ifndef CHOIXMETHODE_H
#define CHOIXMETHODE_H

#include"model.h"
#include <QPushButton>
#include <QFrame>
#include <QLabel>

class ChoixMethode: public QFrame
{
    Q_OBJECT

public:
    ChoixMethode(Model *m);
    void actualiser();

public slots:
    void pressCUDA();
    void pressSAGE();

private:
    Model * model;
    QLabel * label;
    QIcon * cudaIcon;
    QIcon * cudaIconSelect;
    QIcon * sageIcon;
    QIcon * sageIconSelect;
    QPushButton * cudaButton;
    QPushButton * sageButton;

};

#endif // CHOIXMETHODE_H
