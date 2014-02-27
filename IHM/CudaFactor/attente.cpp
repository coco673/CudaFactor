#include "attente.h"
#include <QMap>
#include <QFile>
#include <QMessageBox>
#include <QXmlStreamWriter>
#include <QMapIterator>
#include <QFileDialog>
#include <sstream>
#include <QTextStream>

Attente::Attente(Model *m)
{
    model = m;

    label = new QLabel("Execution", this);
    label->move(290, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    icon = new QIcon("images/boutonEnregistrer.png");
    sauvegarder = new QPushButton(this);

    sauvegarder->setFixedSize(190, 150);
    sauvegarder->move(305, 400);
    sauvegarder->setCursor(Qt::PointingHandCursor);
    sauvegarder->raise(); //au premier plan
    sauvegarder->setStyleSheet("border-radius: 10px;");
    sauvegarder->setIcon(*icon);
    sauvegarder->setIconSize(QSize(190, 150));

    QObject::connect(sauvegarder, SIGNAL(clicked()), this, SLOT(enregistrer()));

    setStyleSheet("background-color: rgb(1,74,111);");

}

void Attente::enregistrer()
{
    //Choix du chemin d'enregistrement
    fileName = QFileDialog::getSaveFileName(0, "Save File",
                                                   "untitled.xml",
                                                   "Xml (*.xml)");
    //Enregistrement
    creerXml();
    sauvegarder->hide();
}

void Attente::actualiser() {
    sauvegarder->show();
}

void Attente::creerXml() {
    //fileName = "xml/untitled.xml";
    QFile file(fileName);
    if(file.open(QFile::WriteOnly|QFile::Text))
    {

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
        out.writeStartElement("nb_instr");
        out.writeCharacters(nbinst);
        out.writeEndElement(); //</nb_instr>
        out.writeStartElement("nb_instr_sec");
        out.writeCharacters(nbinstsec);
        out.writeEndElement(); //</nb_instr_sec>
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
