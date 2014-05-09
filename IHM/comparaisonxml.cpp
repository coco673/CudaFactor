#include "comparaisonxml.h"
#include <QFileDialog>
#include <QMessageBox>

// Initialisation de la Frame
comparaisonXml::comparaisonXml(modelComparaison* m)
{
    modelComp = m;

    label = new QLabel("Comparaison", this);
    label->move(250, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    text1 = new QTextEdit(this);
    text2 = new QTextEdit(this);

    text1->setFixedSize(350, 150);
    text1->setReadOnly(true);
    text1->move(25, 200);
    text1->setStyleSheet("background-color: white; border: 2px solid gray");

    text2->setFixedSize(350, 150);
    text2->setReadOnly(true);
    text2->move(425, 200);
    text2->setStyleSheet("background-color: white; border: 2px solid gray");

    boutonOpen1 = new QPushButton(this);
    boutonOpen2 = new QPushButton(this);

    boutonOpen1->setFixedSize(250, 50);
    boutonOpen1->setText("Ouvrir rapport N°1");
    boutonOpen1->move(75, 400);
    boutonOpen1->setCursor(Qt::PointingHandCursor);
    boutonOpen1->setStyleSheet("color: white; background-color: rgb(1,65,100);");
    boutonOpen1->raise(); //au premier plan

    boutonOpen2->setFixedSize(250, 50);
    boutonOpen2->setText("Ouvrir rapport N°2");
    boutonOpen2->move(475, 400);
    boutonOpen2->setCursor(Qt::PointingHandCursor);
    boutonOpen2->setStyleSheet("color: white; background-color: rgb(1,65,100);");
    boutonOpen2->raise(); //au premier plan

    QObject::connect(boutonOpen1, SIGNAL(clicked()), this, SLOT(ouvrirFichier1()));
    QObject::connect(boutonOpen2, SIGNAL(clicked()), this, SLOT(ouvrirFichier2()));

    setStyleSheet("background-color: rgb(1,74,111);");

}

//Verifie la validité des éléments mais inutile dans cette frame
void comparaisonXml::check() {

}

//Actualisation de la frame après qu'elle soit show
void comparaisonXml::actualiseApresAffichage() {
}

//Execution pour sélectionner et ouvrir le rapport n°1
void comparaisonXml::ouvrirFichier1() {
    QString s = QFileDialog::getOpenFileName(0, "Open File",
                                             "untitled.xml",
                                             "Xml (*.xml)");
    if (s != "") {
        modelComp->setXML1(s);
        lecturefichierXML1();
        if (isComparable()) {
            comparaison();
        } else if (modelComp->getXML2() != ""){
            remplirText1();
            QString message = "<span style = color:'white'>Les nombres sont différents !<br />Comparaison impossible !</span>";
            QMessageBox::information(
                this,
                tr("Erreur"),
                message
            );
        } else {
            remplirText1();
        }
    }
}

//Execution pour sélectionner et ouvrir le rapport n°2
void comparaisonXml::ouvrirFichier2() {
    QString s = QFileDialog::getOpenFileName(0, "Open File",
                                             "untitled.xml",
                                             "Xml (*.xml)");
    if (s != "") {
        modelComp->setXML2(s);
        lecturefichierXML2();
        if (isComparable()) {
            comparaison();
        } else if (modelComp->getXML1() != ""){
            remplirText2();
            QString message = "<span style = color:'white'>Les nombres sont différents !<br />Comparaison impossible !</span>";
            QMessageBox::information(
                this,
                tr("Erreur"),
                message
            );
        } else {
            remplirText2();
        }
    }
}

//Est-il possible de comparer les deux rapports
bool comparaisonXml::isComparable() {
    if (modelComp->getXML1() == "" || modelComp->getXML2() == "") {
        return false;
    }
    if (nombre1 != nombre2) {
        return false;
    }
    return true;
}

//Execution pour de la comparaison des deux rapports
void comparaisonXml::comparaison() {
    text1->clear();
    text2->clear();
    QString colorGreen = "color:green; font-size: 20px;";
    QString colorRed = "color:red; font-size: 20px;";
    QString taille = "font-size: 20px;";

    if (nombre1 != "") {
        text1->insertHtml(QString("<span style=\"%1\">nombre = %2</span><br />").arg(taille, nombre1));
    }
    if (nombre2 != "") {
        text2->insertHtml(QString("<span style=\"%1\">nombre = %2</span><br />").arg(taille, nombre2));
    }
    if (methode1 != "") {
        text1->insertHtml(QString("<span style=\"%1\">methode = %2</span><br />").arg(taille, methode1));
    }
    if (methode2 != "") {
        text2->insertHtml(QString("<span style=\"%1\">methode = %2</span><br />").arg(taille, methode2));
    }
    if (temps1 != "" && temps2 != "") {
        text1->insertHtml(QString("<span style=\"%1\">temps = </span>").arg(taille));
        text2->insertHtml(QString("<span style=\"%1\">temps = </span>").arg(taille));
        if (temps1.toDouble() < temps2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(colorGreen, temps1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(colorRed, temps2));
        } else if (temps1.toDouble() > temps2.toDouble()) {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(colorRed, temps1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(colorGreen, temps2));
        } else {
            text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(taille, temps1));
            text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(taille, temps2));
        }
    }
    if (listFacteursPremiers1.length() != 0) {
        QString s = "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers1.length()-1; i++) {
            s += listFacteursPremiers1[i]+", ";
        }
        s += listFacteursPremiers1[listFacteursPremiers1.length()-1];
        text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(taille, s));
    }
    if (listFacteursPremiers2.length() != 0) {
        QString s = "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers2.length()-1; i++) {
            s += listFacteursPremiers2[i]+", ";
        }
        s += listFacteursPremiers1[listFacteursPremiers2.length()-1];
        text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(taille, s));
    }
}

//Execution pour remplir la zone de texte n°1 avec le rapport choisi
void comparaisonXml::remplirText1() {
    text1->clear();
    QString taille = "font-size: 20px;";

    QString s = "";
    if (nombre1 != "") {
        s += "nombre = "+nombre1+"<br />";
    }
    if (methode1 != "") {
        s += "methode = "+methode1+"<br />";
    }
    if (temps1 != "") {
        s += "temps = "+temps1+"<br />";
    }
    if (listFacteursPremiers1.length() != 0) {
        s += "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers1.length()-1; i++) {
            s += listFacteursPremiers1[i]+", ";
        }
        s += listFacteursPremiers1[listFacteursPremiers1.length()-1];
    }
    text1->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(taille, s));
}

//Execution pour remplir la zone de texte n°2 avec le rapport choisi
void comparaisonXml::remplirText2() {
    text2->clear();
    QString taille = "font-size: 20px;";
    QString s = "";
    if (nombre2 != "") {
        s += "nombre = "+nombre2+"<br />";
    }
    if (methode2 != "") {
        s += "methode = "+methode2+"<br />";
    }
    if (temps2 != "") {
        s += "temps = "+temps2+"<br />";
    }
    if (listFacteursPremiers2.length() != 0) {
        s += "liste des facteurs : ";
        for (int i=0; i<listFacteursPremiers2.length()-1; i++) {
            s += listFacteursPremiers2[i]+", ";
        }
        s += listFacteursPremiers2[listFacteursPremiers2.length()-1];
    }
    text2->insertHtml(QString("<span style=\"%1\">%2</span><br />").arg(taille, s));
}

//Parsing du rapport n°1
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
        {
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
            else if (derniereBaliseOuverte == "listfacteurs" ) {
            }
            else if (derniereBaliseOuverte == "facteur" ) {
                if (t != "") {
                    listFacteursPremiers1.append(t);
                }
            }
            break;
        }
        default :
            break;
        }
    }
}

//Parsing du rapport n°2
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
        {
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
            else if (derniereBaliseOuverte == "listfacteurs" ) {
            }
            else if (derniereBaliseOuverte == "facteur" ) {
                if (t != "") {
                    listFacteursPremiers2.append(t);
                }
            }
            break;
        }
        default :
            break;
        }
    }
}

//Réinitialisation de la frame
void comparaisonXml::actualiser() {
    text1->setPlainText("");
    text2->setPlainText("");
    methode1 = "";
    nombre1 = "";
    listFacteursPremiers1.clear();
    temps1 = "";
    methode2 = "";
    nombre2 = "";
    listFacteursPremiers2.clear();
    temps2 = "";
}

//Bouton suivant affiché ou non
bool comparaisonXml::boutonSuivant() {
    return true;
}
