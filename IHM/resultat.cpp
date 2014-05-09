#include "resultat.h"
#include <sstream>
#include <QMap>
#include <QFile>
#include <QMessageBox>
#include <QXmlStreamWriter>
#include <QMapIterator>
#include <QFileDialog>
#include <sstream>
#include <QTextStream>

// Initialisation de la Frame
Resultat::Resultat(Model *m)
{
    model = m;

    label = new QLabel("Resultat", this);
    label->move(300, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    text = new QTextEdit(this);

    text->setFixedSize(750, 300);
    text->setReadOnly(true);
    text->move(25, 135);
    text->setStyleSheet("background-color: white; border: 2px solid gray");
    remplirText();

    sauvegarder = new QPushButton(this);

    sauvegarder->setFixedSize(250, 50);
    sauvegarder->move(260, 500);
    sauvegarder->setCursor(Qt::PointingHandCursor);
    sauvegarder->setText("Enregistrer rapport");
    sauvegarder->raise(); //au premier plan

    QObject::connect(sauvegarder, SIGNAL(clicked()), this, SLOT(enregistrer()));

    setStyleSheet("background-color: rgb(1,74,111);");
}

//Réinitialisation de la frame
void Resultat::actualiser() {
    remplirText();
}

//Verifie la validité des éléments mais inutile dans cette frame
void Resultat::check() {

}

//Actualisation de la frame après qu'elle soit show
void Resultat::actualiseApresAffichage() {

}

//Bouton suivant affiché ou non
bool Resultat::boutonSuivant() {
    return true;
}

//Permet de remplir la zone de texte avec le rapport d'exécution
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
            +"temps (en sec)= "+tps+"\n"
            +"liste des facteurs : "+listfact;

    text->setPlainText(s);
}

//Permet d'enregistrer le rapport
void Resultat::enregistrer() {
    QString s = QFileDialog::getSaveFileName(0, "Save File",
                                                   "untitled.xml",
                                                   "Xml (*.xml)");
    if (s != "") {
        fileName = s;
        creerXml();
    }
}

//Création du rapport en XML
void Resultat::creerXml() {
    QFile file(fileName);
    if(file.open(QFile::WriteOnly|QFile::Text)) {

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
        bool ok;
        printf("getTpsExec() %f\n",tps.toDouble(&ok));

        QXmlStreamWriter out(&file);
        out.setAutoFormatting(true);
        out.writeStartDocument();
        out.writeStartElement("rapport");
        out.writeStartElement("nombre");
        out.writeCharacters(nbr);
        out.writeEndElement(); //</nombre>
        out.writeStartElement("methode");
        out.writeCharacters(meth);
        out.writeEndElement(); //</methode>
        out.writeStartElement("temps");
        out.writeCharacters(tps);
        out.writeEndElement(); //</temps>
        if (model->getListFacteursPremiers().length() > 0) {
            out.writeStartElement("listfacteurs");
            for (int i=0; i < model->getListFacteursPremiers().length(); i++) {
                QString listfact;
                stream.str("");
                stream << model->getListFacteursPremiers()[i];
                listfact += QString::fromStdString(stream.str());
                out.writeStartElement("facteur");
                out.writeCharacters(listfact);
                out.writeEndElement(); //</facteur>
            }
            out.writeEndElement(); //</listfacteurs>
        }
            out.writeEndElement(); //</rapport>
        out.writeEndDocument();
        file.close();
    }
}
