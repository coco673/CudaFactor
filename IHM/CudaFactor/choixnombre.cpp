#include "choixnombre.h"
#include <sstream>
#include <QButtonGroup>
#include <QDebug>

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

void ChoixNombre::boutonClique() {
    check();
}

void ChoixNombre::actualiseApresAffichage() {
}

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

    long double chiffre = 0;
    if (decimal->isChecked()) {
        bool ok;
        chiffre = nombre->toPlainText().toUInt(&ok,10);
    } else if (hexa->isChecked()) {
        bool ok;
        chiffre = nombre->toPlainText().toUInt(&ok,16);
    } else {
        bool ok;
        chiffre = nombre->toPlainText().toUInt(&ok,2);
    }
    model->setNombre(chiffre);
}

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

bool ChoixNombre::boutonSuivant() {
    return true;
}
