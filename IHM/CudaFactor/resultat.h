#ifndef RESULTAT_H
#define RESULTAT_H

#include "model.h"
#include <QFrame>
#include <QtCore>
#include <QTextEdit>
#include <QLabel>

class Resultat: public QFrame
{
public:
    Resultat(Model *m);
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

#endif // RESULTAT_H
