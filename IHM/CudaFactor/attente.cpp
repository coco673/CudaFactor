#include "attente.h"

Attente::Attente(Model *m)
{
    model = m;

    label = new QLabel("Execution", this);
    label->move(290, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    text = new QTextEdit(this);

    text->setFixedSize(750, 300);
    text->setReadOnly(true);
    text->move(25, 135);
    text->setStyleSheet("background-color: white; border: 2px solid gray");

    setStyleSheet("background-color: rgb(1,74,111);");
}

void Attente::actualiser() {
    text->clear();
}

void Attente::check() {

}

bool Attente::boutonSuivant() {
    return true;
}
