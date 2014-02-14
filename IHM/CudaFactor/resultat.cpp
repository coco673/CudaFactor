#include "resultat.h"

Resultat::Resultat(Model *m)
{
    model = m;

    label = new QLabel("Resultat", this);
    label->move(310, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    QString titre = "xml/exemple.xml"; //A remplacer
    //QString titre = "xml/"+model->getTitre(); //par ca

    lecturefichierXML(titre);

    text = new QTextEdit(this);

    text->setFixedSize(750, 300);
    text->setReadOnly(true);
    text->move(25, 135);
    text->setStyleSheet("background-color: white; border: 2px solid gray");
    remplirText();

    setStyleSheet("background-color: rgb(1,74,111);");
}

void Resultat::actualiser() {
    lecturefichierXML("xml/exemple.xml");
    remplirText();
}

void Resultat::remplirText() {

    QString s = "";
    if (nombre != "") {
        s += "nombre = "+nombre+"\n";
    }
    if (methode != "") {
        s += "methode = "+methode+"\n";
    }
    if (temps != "") {
        s += "temps = "+temps+"\n";
    }
    if (nbInstr != "") {
        s += "nombre d'intructions = "+nbInstr+"\n";
    }
    if (nbInstrSec != "") {
        s += "nombre d'intructions par seconde = "+nbInstrSec+"\n";
    }
    if (listFacteursPremiers.length() != 0) {
        s += "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers.length()-1; i++) {
            s += listFacteursPremiers[i]+", ";
        }
        s += listFacteursPremiers[listFacteursPremiers.length()-1];
    }
    text->setPlainText(s);
}

void Resultat::lecturefichierXML(QString fileName) {

    QXmlStreamReader reader;//Objet servant à la navigation
    QFile file(fileName);
    file.open(QFile::ReadOnly | QFile::Text); //Ouverture du fichier XML en lecture seul et en mode texte
    reader.setDevice(&file);//Initialise l'instance reader avec le flux XML venant de file


//Le but de cette boucle est de parcourir le fichier et de vérifier si l'on est au debut d'un element.
QString derniereBaliseOuverte = "";
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
                    nombre = t;
                }
            }
            else if (derniereBaliseOuverte == "methode") {
                if (t != "") {
                    methode = t;
                }
            }
            else if (derniereBaliseOuverte == "temps") {
                if (t != "") {
                    temps = t;
                }
            }
            else if (derniereBaliseOuverte == "nb_instr") {
                if (t != "") {
                    nbInstr = t;
                }
            }
            else if (derniereBaliseOuverte == "nb_instr_sec") {
                if (t != "") {
                    nbInstrSec = t;
                }
            }
            else if (derniereBaliseOuverte == "listfacteurs" ) {
            }
            else if (derniereBaliseOuverte == "facteur" ) {
                if (t != "") {
                    listFacteursPremiers.append(t);
                }
            }
            break;
        }
    }
}
