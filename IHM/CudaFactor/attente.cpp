#include "attente.h"

Attente::Attente(Model *m)
{
    model = m;

    label = new QLabel("Execution", this);
    label->move(290, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    setStyleSheet("background-color: rgb(1,74,111);");
}

void Attente::actualiser() {

}

void Attente::check() {

}

bool Attente::boutonSuivant() {
    return true;
}
