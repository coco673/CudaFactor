#include "comparaisonxml.h"
#include <QFileDialog>

comparaisonXml::comparaisonXml(modelComparaison* m)
{
    modelComp = m;

    label = new QLabel("Comparaison", this);
    label->move(250, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    labelErreur = new QLabel("Impossible de comparer car les nombres \na factoriser ne sont pas les mêmes !", this);
    labelErreur->move(38, 230);
    labelErreur->setStyleSheet("color: red; background-color: black; font-family:\"Arial\",Georgia,Serif; font-size: 40px;");
    labelErreur->hide();

    text1 = new QTextEdit(this);
    text2 = new QTextEdit(this);

    text1->setFixedSize(350, 300);
    text1->setReadOnly(true);
    text1->move(25, 135);
    text1->setStyleSheet("background-color: white; border: 2px solid gray");

    text2->setFixedSize(350, 300);
    text2->setReadOnly(true);
    text2->move(425, 135);
    text2->setStyleSheet("background-color: white; border: 2px solid gray");

    icon = new QIcon("images/boutonOuvrir.png");
    boutonOpen1 = new QPushButton(this);
    boutonOpen2 = new QPushButton(this);

    boutonOpen1->setFixedSize(190, 150);
    boutonOpen1->move(157, 440);
    boutonOpen1->setCursor(Qt::PointingHandCursor);
    boutonOpen1->raise(); //au premier plan
    boutonOpen1->setStyleSheet("border-radius: 10px;");
    boutonOpen1->setIcon(*icon);
    boutonOpen1->setIconSize(QSize(190, 150));

    boutonOpen2->setFixedSize(190, 150);
    boutonOpen2->move(457, 440);
    boutonOpen2->setCursor(Qt::PointingHandCursor);
    boutonOpen2->raise(); //au premier plan
    boutonOpen2->setStyleSheet("border-radius: 10px;");
    boutonOpen2->setIcon(*icon);
    boutonOpen2->setIconSize(QSize(190, 150));

    labelErreur->raise();

    QObject::connect(boutonOpen1, SIGNAL(clicked()), this, SLOT(ouvrirFichier1()));
    QObject::connect(boutonOpen2, SIGNAL(clicked()), this, SLOT(ouvrirFichier2()));

    setStyleSheet("background-color: rgb(1,74,111);");

}

void comparaisonXml::check() {

}

void comparaisonXml::ouvrirFichier1() {
    QString s = QFileDialog::getOpenFileName(0, "Open File",
                                                   "untitled.xml",
                                                   "Xml (*.xml)");
    if (s != "") {
        modelComp->setXML1(s);
        lecturefichierXML1();
        if (isComparable()) {
            labelErreur->hide();
            comparaison();
        } else if (modelComp->getXML2() != ""){
            remplirText1();
            labelErreur->show();
        } else {
            remplirText1();
            labelErreur->hide();
        }
    }
}

void comparaisonXml::ouvrirFichier2() {
    QString s = QFileDialog::getOpenFileName(0, "Open File",
                                                   "untitled.xml",
                                                   "Xml (*.xml)");
    if (s != "") {
        modelComp->setXML2(s);
        lecturefichierXML2();
        if (isComparable()) {
            labelErreur->hide();
            comparaison();
        } else if (modelComp->getXML1() != ""){
            remplirText2();
            labelErreur->show();
        } else {
            remplirText2();
            labelErreur->hide();
        }
    }
}

bool comparaisonXml::isComparable() {
    if (modelComp->getXML1() == "" || modelComp->getXML2() == "") {
        return false;
    }
    if (nombre1 != nombre2) {
        return false;
    }
    return true;
}

void comparaisonXml::comparaison() {
    text1->clear();
    text2->clear();
    QString backgroundGreen = "background:green";
    QString backgroundRed = "background:red";

    if (nombre1 != "") {
        text1->insertPlainText("nombre = "+nombre1+"\n");
    }
    if (nombre2 != "") {
        text2->insertPlainText("nombre = "+nombre1+"\n");
    }
    if (methode1 != "") {
        text1->insertPlainText("methode = "+methode1+"\n");
    }
    if (methode2 != "") {
        text2->insertPlainText("methode = "+methode1+"\n");
    }
    if (temps1 != "" && temps2 != "") {
        text1->insertPlainText("temps = ");
        text2->insertPlainText("temps = ");
        if (temps1.toDouble() < temps2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundGreen, temps1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundRed, temps2));
        } else if (temps1.toDouble() > temps2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundRed, temps1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundGreen, temps2));
        } else {
            text1->insertPlainText(temps1+"\n");
            text2->insertPlainText(temps2+"\n");
        }
    }
    if (nbInstr1 != "" && nbInstr2 != "") {
        text1->insertPlainText("nombre d'intructions = ");
        text2->insertPlainText("nombre d'intructions = ");
        if (nbInstr1.toDouble() < nbInstr2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundGreen, nbInstr1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundRed, nbInstr2));
        } else if (nbInstr1.toDouble() > nbInstr2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundRed, nbInstr1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundGreen, nbInstr2));
        } else {
            text1->insertPlainText(nbInstr1+"\n");
            text2->insertPlainText(nbInstr2+"\n");
        }
    }
    if (nbInstrSec1 != "" && nbInstrSec2 != "") {
        text1->insertPlainText("nombre d'intructions par seconde = ");
        text2->insertPlainText("nombre d'intructions par seconde = ");
        if (nbInstrSec1.toDouble() > nbInstrSec2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundGreen, nbInstrSec1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundRed, nbInstrSec2));
        } else if (nbInstrSec1.toDouble() < nbInstrSec2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundRed, nbInstrSec1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(backgroundGreen, nbInstrSec2));
        } else {
            text1->insertPlainText(nbInstrSec1+"\n");
            text2->insertPlainText(nbInstrSec2+"\n");
        }
    }
    if (listFacteursPremiers1.length() != 0) {
        QString s = "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers1.length()-1; i++) {
            s += listFacteursPremiers1[i]+", ";
        }
        s += listFacteursPremiers1[listFacteursPremiers1.length()-1];
        text1->insertPlainText(s);
    }
    if (listFacteursPremiers2.length() != 0) {
        QString s = "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers2.length()-1; i++) {
            s += listFacteursPremiers2[i]+", ";
        }
        s += listFacteursPremiers1[listFacteursPremiers2.length()-1];
        text2->insertPlainText(s);
    }
}

void comparaisonXml::remplirText1() {
    text1->clear();

    QString s = "";
    if (nombre1 != "") {
        s += "nombre = "+nombre1+"\n";
    }
    if (methode1 != "") {
        s += "methode = "+methode1+"\n";
    }
    if (temps1 != "") {
        s += "temps = "+temps1+"\n";
    }
    if (nbInstr1 != "") {
        s += "nombre d'intructions = "+nbInstr1+"\n";
    }
    if (nbInstrSec1 != "") {
        s += "nombre d'intructions par seconde = "+nbInstrSec1+"\n";
    }
    if (listFacteursPremiers1.length() != 0) {
        s += "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers1.length()-1; i++) {
            s += listFacteursPremiers1[i]+", ";
        }
        s += listFacteursPremiers1[listFacteursPremiers1.length()-1];
    }
    text1->setPlainText(s);
}

void comparaisonXml::remplirText2() {

    QString s = "";
    if (nombre2 != "") {
        s += "nombre = "+nombre2+"\n";
    }
    if (methode2 != "") {
        s += "methode = "+methode2+"\n";
    }
    if (temps2 != "") {
        s += "temps = "+temps2+"\n";
    }
    if (nbInstr2 != "") {
        s += "nombre d'intructions = "+nbInstr2+"\n";
    }
    if (nbInstrSec2 != "") {
        s += "nombre d'intructions par seconde = "+nbInstrSec2+"\n";
    }
    if (listFacteursPremiers2.length() != 0) {
        s += "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers2.length()-1; i++) {
            s += listFacteursPremiers2[i]+", ";
        }
        s += listFacteursPremiers2[listFacteursPremiers2.length()-1];
    }
    text2->setPlainText(s);
}

void comparaisonXml::lecturefichierXML1() {

    QXmlStreamReader reader;//Objet servant à la navigation
    QFile file(modelComp->getXML1());
    file.open(QFile::ReadOnly | QFile::Text); //Ouverture du fichier XML en lecture seul et en mode texte
    reader.setDevice(&file);//Initialise l'instance reader avec le flux XML venant de file


//Le but de cette boucle est de parcourir le fichier et de vérifier si l'on est au debut d'un element.
QString derniereBaliseOuverte = "";
listFacteursPremiers1.clear();
while (!reader.atEnd())
    {
        QXmlStreamReader::TokenType t = reader.readNext();
        QString name = reader.name().toString ();
        switch (t) {
        case QXmlStreamReader::StartElement :
            derniereBaliseOuverte = name;
            break;

        case QXmlStreamReader::EndElement :
            break;

        case QXmlStreamReader::Characters :
            QString t = "";
            t+= reader.text();
            t.remove(QChar(' '), Qt::CaseInsensitive);
            t.remove(QChar('\n'), Qt::CaseInsensitive);
            if (derniereBaliseOuverte == "nombre") {
                if (t != "") {
                    nombre1 = t;
                }
            }
            else if (derniereBaliseOuverte == "methode") {
                if (t != "") {
                    methode1 = t;
                }
            }
            else if (derniereBaliseOuverte == "temps") {
                if (t != "") {
                    temps1 = t;
                }
            }
            else if (derniereBaliseOuverte == "nb_instr") {
                if (t != "") {
                    nbInstr1 = t;
                }
            }
            else if (derniereBaliseOuverte == "nb_instr_sec") {
                if (t != "") {
                    nbInstrSec1 = t;
                }
            }
            else if (derniereBaliseOuverte == "listfacteurs" ) {
            }
            else if (derniereBaliseOuverte == "facteur" ) {
                if (t != "") {
                    listFacteursPremiers1.append(t);
                }
            }
            break;
        }
    }
}

void comparaisonXml::lecturefichierXML2() {

    QXmlStreamReader reader;//Objet servant à la navigation
    QFile file(modelComp->getXML2());
    file.open(QFile::ReadOnly | QFile::Text); //Ouverture du fichier XML en lecture seul et en mode texte
    reader.setDevice(&file);//Initialise l'instance reader avec le flux XML venant de file


//Le but de cette boucle est de parcourir le fichier et de vérifier si l'on est au debut d'un element.
QString derniereBaliseOuverte = "";
listFacteursPremiers2.clear();
while (!reader.atEnd())
    {
        QXmlStreamReader::TokenType t = reader.readNext();
        QString name = reader.name().toString ();
        switch (t) {
        case QXmlStreamReader::StartElement :
            derniereBaliseOuverte = name;
            break;

        case QXmlStreamReader::EndElement :
            break;

        case QXmlStreamReader::Characters :
            QString t = "";
            t+= reader.text();
            t.remove(QChar(' '), Qt::CaseInsensitive);
            t.remove(QChar('\n'), Qt::CaseInsensitive);
            if (derniereBaliseOuverte == "nombre") {
                if (t != "") {
                    nombre2 = t;
                }
            }
            else if (derniereBaliseOuverte == "methode") {
                if (t != "") {
                    methode2 = t;
                }
            }
            else if (derniereBaliseOuverte == "temps") {
                if (t != "") {
                    temps2 = t;
                }
            }
            else if (derniereBaliseOuverte == "nb_instr") {
                if (t != "") {
                    nbInstr2 = t;
                }
            }
            else if (derniereBaliseOuverte == "nb_instr_sec") {
                if (t != "") {
                    nbInstrSec2 = t;
                }
            }
            else if (derniereBaliseOuverte == "listfacteurs" ) {
            }
            else if (derniereBaliseOuverte == "facteur" ) {
                if (t != "") {
                    listFacteursPremiers2.append(t);
                }
            }
            break;
        }
    }
}

void comparaisonXml::actualiser() {
    text1->setPlainText("");
    text2->setPlainText("");
    methode1 = "";
    nombre1 = "";
    listFacteursPremiers1.clear();
    temps1 = "";
    nbInstr1 = "";
    nbInstrSec1 = "";
    methode2 = "";
    nombre2 = "";
    listFacteursPremiers2.clear();
    temps2 = "";
    nbInstr2 = "";
    nbInstrSec2 = "";
    labelErreur->hide();
}

bool comparaisonXml::boutonSuivant() {
    return true;
}
