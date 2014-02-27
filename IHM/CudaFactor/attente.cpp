#include "attente.h"
#include <QMap>
#include <QFile>
#include <QMessageBox>
#include <QXmlStreamWriter>
#include <QMapIterator>
#include <QFileDialog>

Attente::Attente(Model *m)
{
    model = m;

    label = new QLabel("Execution", this);
    label->move(300, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    creerXml();

    setStyleSheet("background-color: rgb(1,74,111);");

}

void Attente::actualiser() {

}

void Attente::creerXml() {
    fileName = "xml/untitled.xml";
    QFile file(fileName);
    if(file.open(QFile::WriteOnly|QFile::Text))
    {
        QXmlStreamWriter out(&file);
        out.setAutoFormatting(true);
        out.writeStartDocument();
        out.writeStartElement("rapport");
        out.writeStartElement("temps");
        out.writeCharacters("35");
        out.writeEndElement(); //</temps>
        out.writeEndElement(); //</rapport>
        out.writeEndDocument();
        file.close();
    }
}
