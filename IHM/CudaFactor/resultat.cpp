#include "resultat.h"
#include <sstream>

Resultat::Resultat(Model *m)
{
    model = m;

    label = new QLabel("Resultat", this);
    label->move(310, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    text = new QTextEdit(this);

    text->setFixedSize(750, 300);
    text->setReadOnly(true);
    text->move(25, 135);
    text->setStyleSheet("background-color: white; border: 2px solid gray");
    remplirText();

    setStyleSheet("background-color: rgb(1,74,111);");
}

void Resultat::actualiser() {
    remplirText();
}

void Resultat::remplirText() {

    std::stringstream stream;
    stream << model->getNombre();
    QString nbr = QString::fromStdString(stream.str());

    QString meth = "";
    if (model->getMethode() == SAGE) {
        meth = "SAGE";
    } else {
        meth = "CUDA";
    }

    stream.str("");
    stream << model->getTempsExecution();
    QString tps = QString::fromStdString(stream.str());

    stream.str("");
    stream << model->getNbreInstruction();
    QString nbinst = QString::fromStdString(stream.str());

    stream.str("");
    stream << model->getNbreInstrParSec();
    QString nbinstsec = QString::fromStdString(stream.str());

    QString listfact = "aucun";
    if (model->getListFacteursPremiers().length() > 0) {
        listfact = "";
        int i=0;
        for (i=0; i < model->getListFacteursPremiers().length()-1; i++) {
            stream.str("");
            stream << model->getListFacteursPremiers()[i];
            listfact += QString::fromStdString(stream.str());
            listfact +=+", ";

        }
        stream.str("");
        stream << model->getListFacteursPremiers()[i];
        listfact += QString::fromStdString(stream.str());
    }
    QString s = "nombre = "+nbr+"\n"
            +"methode = "+meth+"\n"
            +"temps = "+tps+"\n"
            +"nombre d'intructions = "+nbinst+"\n"
            +"nombre d'intructions par seconde = "+nbinstsec+"\n"
            +"liste des facteurs : "+listfact;

    text->setPlainText(s);
}
