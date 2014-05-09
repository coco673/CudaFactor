#include "choixnombre.h"
#include <sstream>
#include <QButtonGroup>
#include <QDebug>
#include <gmpxx.h>

// Initialisation de la Frame
ChoixNombre::ChoixNombre(Model * m)
{
    model = m;

    label = new QLabel("Choix du nombre", this);
    label->move(210, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    nombre = new QTextEdit(this);
    nombre->setFixedSize(700, 75);
    nombre->move(50, 238);
    nombre->setStyleSheet("background-color: white; border: 2px solid gray");

    binaire = new QRadioButton("binaire", this);
    decimal = new QRadioButton("decimal", this);
    hexa = new QRadioButton("hexadecimal", this);

    binaire->move(200, 330);
    decimal->move(350, 330);
    hexa->move(500, 330);

    binaire->setStyleSheet("color : black;");
    decimal->setStyleSheet("color : black;");
    hexa->setStyleSheet("color : black;");

    QButtonGroup * group = new QButtonGroup(this);
    group->addButton(binaire, 1);
    group->addButton(decimal, 2);
    group->addButton(hexa, 3);
    decimal->setChecked(true);

    //QObject::connect(nombre, SIGNAL(textChanged()), this, SLOT(changerNombre()));
    QObject::connect(group, SIGNAL(buttonClicked(int)), this, SLOT(boutonClique()));

    setStyleSheet("background-color: rgb(1,74,111);");
}

//Execution lorsque l'un des boutons radiobouton est pressé
void ChoixNombre::boutonClique() {
    check();
}

//Actualisation de la frame après qu'elle soit show
void ChoixNombre::actualiseApresAffichage() {
}

//Verifie la validité des éléments
void ChoixNombre::check() {
    QStringList listString = nombre->toPlainText().split("\n");

    if (listString.length() > 1) {
        QTextCursor temp = nombre->textCursor();
        QString s = "";
        for (int i=0; i<listString.length(); i++) {
            s+=listString.at(i);
        }
        nombre->setPlainText(s);
        nombre->setTextCursor(temp);
    }

    mpz_class chiffre = 0;
    QString s = nombre->toPlainText();
    if (s != NULL) {
        if (decimal->isChecked()) {
            chiffre = s.toStdString();
        } else if (hexa->isChecked()) {
            chiffre = mpz_class(s.toStdString(),16);
        } else {
            chiffre = mpz_class(s.toStdString(),2);
        }
    }
    model->setNombre(chiffre);
}

//Réinitialisation de la frame
void ChoixNombre::actualiser() {
    if (model->getNombre() == 0) {
        nombre->setText("");
    } else {
        std::stringstream stream;
        stream << model->getNombre();
        QString s = QString::fromStdString(stream.str());
        nombre->setText(s);
    }
    decimal->setChecked(true);
}

//Bouton suivant affiché ou non
bool ChoixNombre::boutonSuivant() {
    return true;
}
