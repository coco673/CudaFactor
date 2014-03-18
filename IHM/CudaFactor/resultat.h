#ifndef RESULTAT_H
#define RESULTAT_H

#include "model.h"
#include "Frame.h"
#include <QtCore>
#include <QTextEdit>
#include <QLabel>
#include <QPushButton>

class Resultat: public Frame
{
    Q_OBJECT

public:
    Resultat(Model *m);
    void actualiser();
    bool boutonSuivant();
    void lecturefichierXML(QString fileName);
    void remplirText();
    void creerXml();
    void check();

public slots:
    void enregistrer();

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
    QString fileName;
    QPushButton * sauvegarder;
    QIcon * icon;
};

#endif // RESULTAT_H
