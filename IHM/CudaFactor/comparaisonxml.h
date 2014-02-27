#ifndef COMPARAISONXML_H
#define COMPARAISONXML_H

#include "model.h"
#include <QFrame>
#include <QtCore>
#include <QTextEdit>
#include <QLabel>

class comparaisonXml: public QFrame
{
    Q_OBJECT

public:
    comparaisonXml(Model *m);
    void actualiser();
    void lecturefichierXML(QString fileName);
    void remplirText();

private:
    Model * model;
    QTextEdit * text;
    QString methode;
    QString nombre;
    QList<QString> listFacteursPremiers;
    QString temps;
    QString nbInstr;
    QString nbInstrSec;
    QLabel * label;
};

#endif // COMPARAISONXML_H
